

%% load the mat file of model
%load('kbg84.mat');
load('52Models.mat');

%num_model = length(kbg84);
num_model = length(model);

%% load the short-chain fatty acid information
aa_info = readtable('AA.txt', 'Delimiter', '\t', 'ReadVariableNames',false);
aa_id = aa_info{2:end, 'Var1'}
aa_name = aa_info{2:end, 'Var2'}

num_aa = length(aa_id);

%% for each of model check the aa production

% create a array to store the production
aa_production = zeros(num_aa, num_model);

for i = 1:num_aa
    
    i_aa_name = aa_name(i);
    i_aa_id = aa_id(i);
    
    i_aa_exchange_rxns_name = strcat('EX_', i_aa_id, '_e0');
    i_aa_met = strcat(i_aa_id, '_c0');
    i_aa_demand_rxns_name = strcat('DM_', i_aa_met);
    
    for j = 1:num_model
        
        j_model = model(j);
        
        % set all the exchange rxns are free
        [j_model, j_exchange_rxns] = set_exchange_lb(j_model, -10, 1000);
        
        % check if the exchange of aa is open in the model, if yes, close
        % it
        i_in_exchange_status = ismember(i_aa_exchange_rxns_name, j_exchange_rxns);
        if i_in_exchange_status
            j_model = changeRxnBounds(j_model, i_aa_exchange_rxns_name, 0, 'l');
        end
        
        % add the demand reaction of aa
        j_model = addDemandReaction(j_model, i_aa_met);
        
        % change objective function
        j_model = changeObjective(j_model, i_aa_demand_rxns_name);
        
        % maximize the obj
        j_sol = optimizeCbModel(j_model);
        
        aa_production(i, j) = j_sol.f;
        
    end
end

save('aa_production.mat', 'aa_production')
save aa_id;
save aa_name;