function str = applyMap(mapsIn,str)
	% applyMap
	% 	Successively applies a set of maps (dictionaries) to a
	%	set of strings. If any key value pairs do not exist, the
	%	last applied mapping that worked is returned.
	%
	%	input:
	%	  mapsIn					a cell array of dictionaries in application
	%								order right to left {map3,map2,map1}
	%	  str						the input strings on which to apply maps
	%
	%	output:
	%	  str						a cell array of converted strings 
	%	
	%	usage:
	%	  str = applyMap({map3,map2,map1},inputString)
	%
	% 	Daniel Hermansson, 01-06-2016
	%global returnOld;

	map=mapsIn{end};
	
	str=cellfun(@(x) mapTo(x,map),str,'UniformOutput',false,'ErrorHandler',@errorfun);

	if(length(mapsIn)>1)
		str=applyMap(mapsIn(1:end-1),str);
	end	
end

function result = errorfun(S, varargin)
	result = varargin{1};
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