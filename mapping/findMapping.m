function [geneIds,geneMaps]=findMapping(aliases,targetDB,organismName)
	% findMapping
	% 	Finds a mapping for a set of protein IDs of a certain database
	%	to a target database using the uniprot mapping service. The 
	%	input alias types are identified based on regex patterns present
	%	in the associative array 'uniprotIdMap' in the same folder.
	%
	%	Required: python bioservices should be installed and be
	%	accessible from within MATLAB via 'py.bioservices'.
	%	
	%	input:
	%	  aliases					a cell array of cell arrays of input
	%								IDs (can be multiple different db ids
	%								for each protein)
	%	  targetDB					a database identifier string present 
	%								in 'uniprotIdMap', (the end IDs will
	%								be of this kind)
	%	  organismName (opt)		a string with organism name to use
	%								as backup search in ambiguous mappings,
	%								this only applies if the proteins are
	%								derived from the same organism.
	%	output:
	%	  geneIds					a cell array of converted IDs
	%	  geneMaps					a cell of associative arrays of gene
	%								IDs, can contain intermediate maps)
	%	
	%	usage:
	%	  [geneIds,geneMaps]=findMapping(aliases,'UniProtKB AC','Escherichia coli')
	%
	% 	Daniel Hermansson, 01-06-2016

	load('uniprotIdMap')

	if nargin<3
		organismName=false;
	end

	if nargin<2
		targetDB='UniProtKB AC';
	end
	
	% The below functions are defined to enable effective use of 'cellfun'
	% on the many intermediate cell arrays of the procedure.

	% Chops an array at index k into length chunkSize.
	chop=@(x,k,chunkSize) x(1+k*chunkSize:min((k+1)*chunkSize,length(x)));
	
	% Chops an array into equally sized chunks.
	chopCell=@(x,chunkSize) arrayfun(@(k) chop(x,k,chunkSize),[1:floor(length(x)/chunkSize)],'UniformOutput',false);

	% Helper search function to form correct search strings and convert the acquired
	% python struct into MATLAB cells.
	searchX=@(u,x,name) structFromPyObj(u.search(['(' strjoin(x,' OR ') ') organism:"' name '"'],'list'),false,true);
	
	% Small helper function to replicate a cell array.
	rf=@(valCell,key) repmat({key},1,length(valCell));
	
	% Evaluates a mapping ID string mapId over a cell of regular expressions cellEx.
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

	% search for most present type (descending order) and use that alias to find a mapping to uniprot
	% this will be the first map
	for j=1:numel(ind)
		aliasDbId=dbStr(regexKey{ind(j)}).id;
		aliasSearch=nameCell{ind(j)};
		map1=structFromPyObj(u.mapping(aliasDbId,dbStr('UniProtKB AC').id,aliasSearch'),false,true);
		if(~isstruct(map1)) break; end
	end
	map1v=values(map1);

	% if no uniprot returned, identify return, do a search based on organism name to verify
	% this will produce a mapping with intermediate maps in the end (i.e. map1->map2->map3)
	if (isempty(regexp(map1v{1},dbStr('UniProtKB AC').regex)) && isempty(regexp(map1v{1},dbStr(targetDB).regex)) && ischar(organismName))
		
		% identify each alias (what kind of ID was returned)
		% save most present one to aliasDbId
		a=cellfun(@(x) evalAccEx(map1v,x),cellfun(@(x) dbStr(x).regex,regexKey,'UniformOutput',false),'UniformOutput',false);
		b=cellfun(@(x) x(~cellfun('isempty',x)),a,'UniformOutput',false);
		[i1,j1]=cellfun(@(x) size(x),b);
		[i2,j2]=max(j1);
		aliasDbId=dbStr(regexKey{ind(j2)}).id;

		% intermediate map from aliasDB to standard Uniprot
		map2=structFromPyObj(u.mapping(aliasDbId,dbStr('UniProtKB AC').id, map1v),false,true);

		geneMaps={map2 map1};

		% Note that this if clause handles cases when the above "u.mapping" not actually returns 
		% standard uniprot, but something like UNIPARC IDs. We can then make a search based on the
		% organism name instead to pick out relevant IDs and then create reverse maps to map back to 
		% uniprot ids.

		srch=values(map2);
		srchIn=[srch{:}];

		% send searches with 100 IDs in each search, note that this uses u.search() not u.mapping()
		gensrch=cellfun(@(srch) searchX(u,srch,organismName),chopCell(srchIn,100),'UniformOutput',false);

		% if search is empty check if reason is that the organism name has a synonym in the database which could be used instead
		if isempty([gensrch{:}])
			name=strread(structFromPyObj(u.search(pyargs('query',organismName,'limit',1,'sort','score','frmt','xls','columns','organism'))), '%[^\n]',2);
			if(isempty(name))
				geneIds=aliases;
				return;
			end	
			gensrch=cellfun(@(srch) searchX(u,srch,name{2}),chopCell(srchIn,100),'UniformOutput',false);
		end

		% some restructuring of the search cell and intermediate maps tmp2 for the steps below
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

		% since some of the matches are partial, the values in the reverse map tmp2r
		% have to be duplicated in order to make a one to one map
		tmp2kRep=cellfun(@(x,y) rf(x,y),tmp2v',tmp2k','UniformOutput',false);
		tmp2kRep=[tmp2kRep{:}];

		tmp2r=containers.Map([tmp2v{:}],tmp2kRep);

		% the reverse map is applied to pick out only those IDs which were 
		% initally present
		srchE=applyMap({tmp2r},gensrch);
		tmp3=containers.Map(srchE,gensrch);

		% the final map is applied to yield uniprot IDs
		geneIds=applyMap({tmp3},values(map1))';
	else % no intermediate maps need to be produced (just return map1)
		geneMaps={map1};
		geneIds=applyMap(geneMaps,aliasSearch);
	end

	% if targetDB is not uniprot perform the last search with the acquired uniprot IDs
	% to produce map3 and the final targetDB geneIds
	if(isempty(regexp(targetDB,'UniProtKB')))
		map3=structFromPyObj(u.mapping(dbStr('UniProtKB AC').id,dbStr(targetDB).id,geneIds'),false,true);
		geneIds=applyMap({map3},geneIds);
		geneMaps{end+1}=map3;
	end

end