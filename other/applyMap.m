function out = applyMap(mapsIn,out)%,returnOld)
	%global returnOld;

	map=mapsIn{end};
	%try
	%	out=cell2mat(cellfun(@(x) mapTo(x,map),out,'UniformOutput',false,'ErrorHandler',@errorfun));
	%catch
	%	out=cellfun(@(x) mapTo(x,map),out,'UniformOutput',false,'ErrorHandler',@errorfun);
	%end

	out=cellfun(@(x) mapTo(x,map),out,'UniformOutput',false,'ErrorHandler',@errorfun);

	if(length(mapsIn)>1)% && strcmp(class(funs),'cell'))
		out=applyMap(mapsIn(1:end-1),out);%,returnOld);
	end	
end

function result = errorfun(S, varargin)
	% supress error
	%warning(S.identifier, S.message)
	%disp(varargin)
	%for i=1:length(varargin)
	%	fprintf([num2str(i) ': '])
	%	disp(varargin)
	%end
	
	%if length(varargin)>1
   	result = varargin{1};
   	%else
   	%	result = {};
   	%end
end


function res = mapTo(x,map)
	errorStruct.message = 'Field value empty.';
	errorStruct.identifier = 'mapTo:EmptyField';

	if (strcmp(class(map(x)),'struct'))
		if(isempty(fields(map(x))))
			error(errorStruct);
		end
	else
		res=map(x);
	end
end