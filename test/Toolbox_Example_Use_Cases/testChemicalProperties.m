clear
tic
%% Exemplary code for assigning Chemical Properties to models 

model = assignChemicalProperties(model, 'formula');
model = assignChemicalProperties(model, 'deltaG');
model = assignChemicalProperties(model, 'random');
model = assignChemicalProperties(model, '');
%%
toc
