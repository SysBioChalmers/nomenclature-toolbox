% web interface nomencalture test
load '52Models.mat'
loadStuff

ch=py.bioservices.ChEBI()

metN=cellfun(@(x) x(1:end-3),model.metNames,'UniformOutput',false);

for i=1:length(model.metFormulas)
	resForm=structFromPyObj(ch.getLiteEntity(model.metFormulas{i},'FORMULA'),false);

	resName = structFromPyObj(ch.getLiteEntity(metN{i}),false);

	disp(metN{i})

	for j=1:min(5,length(resForm))
		fprintf(['(' num2str(j) '): \n']);
		disp(resForm{j});
	end

	for j=1:min(5,length(resName))
		fprintf(['(' num2str(j) '): \n']);
		disp(resName{j});
	end


	in=input('')
end

