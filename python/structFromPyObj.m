function obj=structFromPyObj(obj,printBool,stripCell)
	% Daniel Hermansson, 28-04-16
	if nargin<3
		stripCell=false;
	end
	if nargin<2
		printBool=false;
	end

	w=warning('off','MATLAB:structOnObject');
	obj=structFromPyObjH(obj,printBool,stripCell);
	warning(w);
end

function obj = structFromPyObjH(obj, printBool,stripCell)
	if(strcmp(class(obj),'py.list'))
		obj=structFromPyObjH(cell(obj),printBool,stripCell);
	elseif(strcmp(class(obj),'cell'))
		obj=cellfun(@(x) structFromPyObjH(x,printBool,stripCell),obj,'UniformOutput',false);
		%for i=1:length(obj)
		%	obj{i}=structFromPyObjH(obj{i},printBool);
		%end
		if (strcmp(class(obj),'cell') && length(obj)==1 && stripCell) obj=obj{1}; end % optionally flatten cells with only one object
	elseif(strcmp(class(obj),'py.unicode') || strcmp(class(obj),'py.str') || strcmp(class(obj),'py.suds.sax.text.Text'))
		obj=char(obj);
	elseif(isnumeric(obj))
		obj=obj;
	elseif(strcmp(class(obj),'py.dict') && ~isempty(cell(keys(obj))) || strcmp(class(obj),'py.collections.defaultdict'))
		keys1=cellfun(@char,cell(keys(obj)),'UniformOutput',false);
		values1=structFromPyObjH(values(obj),printBool,stripCell);
		obj=containers.Map(keys1,values1);
		%end
	else % assume that all other datatypes are struct like
		obj=struct(obj);

		fn = fieldnames(obj);
		for i = 1:length(fn)
		    tmp=getfield(obj,fn{i});
		    if(isnumeric(tmp) && ~strcmp(class(tmp),'py.suds.sax.text.Text'))
		    	obj=setfield(obj,fn{i},tmp);
		    elseif(strcmp(class(tmp),'py.suds.sax.text.Text') || strcmp(class(tmp),'py.unicode'))
		    	if(all(ismember(char(tmp), '0123456789+-.eEdD'))) % check if string is a number
		    		obj=setfield(obj,fn{i},str2num(char(tmp)));
		    	else
		    		obj=setfield(obj,fn{i},char(tmp));
		    	end
		    elseif(strcmp(class(tmp),'py.list'))
		    	obj=setfield(obj,fn{i},structFromPyObjH(tmp, printBool,stripCell));
		    end
		end
	end

	if(printBool) disp(obj); end
end