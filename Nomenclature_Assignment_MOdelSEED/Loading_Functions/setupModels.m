clear
tic
%% Loading Genome'Scale Metabolic Mode  
load('52Models.mat');

% Converting model's metabolites and reactions identifiers according to
% SysBio standars
for i=1:length(model)    
    model(i)= convertIdsSysBioStandars(model(i));
end
%%
toc