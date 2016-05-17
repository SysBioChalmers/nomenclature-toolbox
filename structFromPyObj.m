function obj=structFromPyObj(obj,printBool)
	w=warning('off','MATLAB:structOnObject');
	obj=structFromPyObjH(obj,printBool);
	warning(w);
end

function obj = structFromPyObjH(obj, printBool)
	% Daniel Hermansson, 28-04-16

	if nargin<2
		printBool=false;
	end

	if(strcmp(class(obj),'py.list'))
		obj=structFromPyObjH(cell(obj),printBool);
	elseif(strcmp(class(obj),'cell'))
		for i=1:length(obj)
			obj{i}=structFromPyObjH(obj{i},printBool);
		end
	elseif(strcmp(class(obj),'py.unicode') || strcmp(class(obj),'py.str') || strcmp(class(obj),'py.suds.sax.text.Text'))
		obj=char(obj);
	elseif(isnumeric(obj))
		obj=obj;
	elseif(strcmp(class(obj),'py.dict') && ~isempty(cell(keys(obj))))
		keys1=cellfun(@char,cell(keys(obj)),'UniformOutput',false);
		values1=structFromPyObjH(values(obj),printBool);
		obj=containers.Map(keys1,values1);
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
		    	obj=setfield(obj,fn{i},structFromPyObjH(tmp, printBool));
		    end
		end
	end

	if(printBool) disp(obj); end
end