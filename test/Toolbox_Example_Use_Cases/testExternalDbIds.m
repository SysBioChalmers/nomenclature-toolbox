clear
tic
%% Exemplary code for assigning Identifiers from External Databases 

model = assignExternalDbIds(model, 'KEGG');
model = assignExternalDbIds(model, 'EC');
model = assignExternalDbIds(model, 'ChEBI');
model = assignExternalDbIds(model, 'InChI');
model = assignExternalDbIds(model, 'random');
model = assignExternalDbIds(model, '');

%%
toc