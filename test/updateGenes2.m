% test script to update the genome protein ids of the 52 models of Parizad

% first I noticed that genes had not been parsed correctly, kb| had been
% removed from all genes and kb was added as a gene

load('52Models')
load('52GenomeFeatures')

for i=1:length(model)
	for j=2:(length(model(i).genes)-1)
		model(i).genes{j}=['kb|' model(i).genes{j}];
	end
	model(i).genes(end)=[];
	model(i).genes(1)=[];
end

genesNewE={};

tic

for j=1:length(model)
	sciName=data(j).tax.scientific_name;
	disp(['Updating annotation for ' sciName '.']);

	fieldn=fieldnames(data(j).gene);
	genes=cell(0);
	for i=1:length(fieldn)
		tmp=getfield(getfield(data(j).gene,fieldn{i}),'aliases');
		if(~isstruct(tmp))
			if(~isempty(tmp{1}))
				genes{end+1}=tmp;
			end
		end
	end
	genes=genes';

	try
		genesNewE{end+1}=findMapping(genes,'UniProtKB AC',sciName);
	catch e
		disp(e)
	end
end

toc