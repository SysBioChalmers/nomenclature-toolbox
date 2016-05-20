function [geneIds,geneMaps]=findMapping(aliases,targetDB,organismName)
	load('uniprotIdMap')

	if nargin<3
		organismName=false;
	end

	if nargin<2
		targetDB='UniProtKB AC';
	end
	
	chop=@(x,k,chunkSize) x(1+k*chunkSize:min((k+1)*chunkSize,length(x)));
	chopCell=@(x,chunkSize) arrayfun(@(k) chop(x,k,chunkSize),[1:floor(length(x)/chunkSize)],'UniformOutput',false);
	searchX=@(u,x,name) structFromPyObj(u.search(['(' strjoin(x,' OR ') ') organism:"' name '"'],'list'),false,true);
	rf=@(valCell,key) repmat({key},1,length(valCell));
	evalAccEx=@(cellEx,mapId) cellfun(@(x) regexp(x,mapId,'match'),cellEx,'UniformOutput',false,'ErrorHandler',@(S,varargin) []);

	geneMaps={};
	geneIds={};
	u=py.bioservices.UniProt();

	% find key-val with regex
	ind=cellfun(@(x) ~strcmp(x.regex,'none'),values(dbStr));
	regexKey=keys(dbStr);
	regexKey=regexKey(ind);

	% create nameCell
	nameCell={};
	for j=1:length(regexKey)
		a=cellfun(@(x) evalAccEx(x,dbStr(regexKey{j}).regex), aliases,'UniformOutput',false);
		b=cellfun(@(x) x(~cellfun('isempty',x)),a,'UniformOutput',false);
		nameCell{end+1}=cellfun(@(x) x{:}{:},b,'UniformOutput',false,'ErrorHandler',@(S,varargin) S);
		%nameCell{end+1}=[a{:}];%cellfun(@(x) x{:}{:},b,'UniformOutput',false,'ErrorHandler',@(S,varargin) varargin);
	end

	% sort "id line" by ascending non-matches to find most present type of id among all gene aliases
	[val,ind]=sort(cellfun(@(y) sum(cellfun(@(x) strcmp(class(x),'struct'),y)),nameCell));

	% search for most present type (descending order)
	for j=1:numel(ind)
		aliasDbId=dbStr(regexKey{ind(j)}).id;
		aliasSearch=nameCell{ind(j)};
		map1=structFromPyObj(u.mapping(aliasDbId,dbStr('UniProtKB AC').id,aliasSearch'),false,true);
		if(~isstruct(map1)) break; end
	end

	map1v=values(map1);

	% if no uniprot returned, identify return, do a search based on organism name to verify
	if (isempty(regexp(map1v{1},dbStr('UniProtKB AC').regex)) && isempty(regexp(map1v{1},dbStr(targetDB).regex)) && ischar(organismName))
		
		% identify each alias
		a=cellfun(@(x) evalAccEx(map1v,x),cellfun(@(x) dbStr(x).regex,regexKey,'UniformOutput',false),'UniformOutput',false);
		b=cellfun(@(x) x(~cellfun('isempty',x)),a,'UniformOutput',false);
		[i1,j1]=cellfun(@(x) size(x),b);
		[i2,j2]=max(j1);

		aliasDbId=dbStr(regexKey{ind(j2)}).id;

		map2=structFromPyObj(u.mapping(aliasDbId,dbStr('UniProtKB AC').id, map1v),false,true);

		srch=values(map2);
		srchIn=[srch{:}];

		gensrch=cellfun(@(srch) searchX(u,srch,organismName),chopCell(srchIn,100),'UniformOutput',false);

		geneMaps={map2 map1};

		% check for other organism name
		if isempty([gensrch{:}])
			name=strread(structFromPyObj(u.search(pyargs('query',organismName,'limit',1,'sort','score','frmt','xls','columns','organism'))), '%[^\n]',2);
			if(isempty(name))
				geneIds=aliases;
				return;
			end	
			gensrch=cellfun(@(srch) searchX(u,srch,name{2}),chopCell(srchIn,100),'UniformOutput',false);
		end

		gensrch=cellfun(@(x) strsplit(x,'\n'),gensrch,'UniformOutput',false);
		gensrch=[gensrch{:}];
		gensrch(strcmp('', gensrch))=[];

		tmp2v=values(map2);
		tmp2k=keys(map2);

		for j=1:length(tmp2v)
			if (strcmp(class(tmp2v{j}),'char'))
				tmp2v{j}={tmp2v{j}};
			end
		end

		tmp2kRep=cellfun(@(x,y) rf(x,y),tmp2v',tmp2k','UniformOutput',false);
		tmp2kRep=[tmp2kRep{:}];

		tmp2r=containers.Map([tmp2v{:}],tmp2kRep);

		srchE=applyMap({tmp2r},gensrch);

		tmp3=containers.Map(srchE,gensrch);

		geneIds=applyMap({tmp3},values(map1))';
	else
		geneMaps={map1};
		geneIds=applyMap(geneMaps,aliasSearch);
	end

	if(isempty(regexp(targetDB,'UniProtKB')))
		map3=structFromPyObj(u.mapping(dbStr('UniProtKB AC').id,dbStr(targetDB).id,geneIds'),false,true);
		geneIds=applyMap({map3},geneIds);
		geneMaps{end+1}=map3;
	end

end