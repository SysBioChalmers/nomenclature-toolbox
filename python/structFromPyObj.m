function obj=structFromPyObj(obj,printBool,stripCell)
	% structFromPyObj
	% 	Converts a Python object (as returned from eg. Python bioservies)
	%	into a MATLAB friendly struct by recursively walking through the
	%	structure and converting atomic objects (strings and numbers).
	%
	%	input:
	%	  object					a Python nested object structure
	%								consisting of other objects and
	%								strings and numbers.
	%	  printBool (opt)			flag to optionally print the structure 
	%								as it is converted, default: false
	%	  stripCell (opt)			flag to optionally strip returned
	%								cells containing a single atom
	%
	%	output:
	%	  obj						a nested cell array
	%
	%	Daniel Hermansson, 28-04-16

	if nargin<3
		stripCell=false;
	end
	if nargin<2
		printBool=false;
	end

	% supress struct on object warnings
	w=warning('off','MATLAB:structOnObject');
	obj=structFromPyObjH(obj,printBool,stripCell);
	warning(w);
end

function obj = structFromPyObjH(obj, printBool,stripCell)
	% lists are converted into a matlab cell and passed on
	if(strcmp(class(obj),'py.list'))
		obj=structFromPyObjH(cell(obj),printBool,stripCell);
	elseif(strcmp(class(obj),'cell')) % all objects of a cell are passed on
		obj=cellfun(@(x) structFromPyObjH(x,printBool,stripCell),obj,'UniformOutput',false);
		%for i=1:length(obj)
		%	obj{i}=structFromPyObjH(obj{i},printBool);
		%end
		if (strcmp(class(obj),'cell') && length(obj)==1 && stripCell) obj=obj{1}; end % optionally flatten cells with only one object
	elseif(strcmp(class(obj),'py.unicode') || strcmp(class(obj),'py.str') || strcmp(class(obj),'py.suds.sax.text.Text')) % there are many kinds of python strings wich just are converted in MATLAB strings via char()
		obj=char(obj);
	elseif(isnumeric(obj))
		obj=obj; % numbers need not be converted
	elseif(strcmp(class(obj),'py.dict') && ~isempty(cell(keys(obj))) || strcmp(class(obj),'py.collections.defaultdict')) % py.dict are turned directly into dictionaries and are assumed not to hold any continued nested structure
		keys1=cellfun(@char,cell(keys(obj)),'UniformOutput',false);
		values1=structFromPyObjH(values(obj),printBool,stripCell);
		obj=containers.Map(keys1,values1);
		%end
	else % assume that all other datatypes are struct like and handle explicitly
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