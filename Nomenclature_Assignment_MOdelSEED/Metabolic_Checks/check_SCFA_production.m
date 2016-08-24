
%% load the mat file of model
%load('kbg84.mat');
load('52Models.mat');

%num_model = length(kbg84);
num_model = length(model);
%% load the short-chain fatty acid information
scfa_info = readtable('SCFA.txt', 'Delimiter', '\t', 'ReadVariableNames',false);
scfa_id = scfa_info{2:end, 'Var1'}
scfa_name = scfa_info{2:end, 'Var2'}

num_scfa = length(scfa_id);

%% for each of model check the SCFA production

% create a array to store the production
scfa_production = zeros(num_scfa, num_model);

for i = 1:num_scfa
    
    i_scfa_name = scfa_name(i);
    i_scfa_id = scfa_id(i);
    
    i_scfa_exchange_rxns_name = strcat('EX_', i_scfa_id, '_e0');
    i_scfa_met = strcat(i_scfa_id, '_c0');
    i_scfa_demand_rxns_name = strcat('DM_', i_scfa_met);
    
    for j = 1:num_model
        
        j_model = model(j);
        
        % set all the exchange rxns are free
        [j_model, j_exchange_rxns] = set_exchange_lb(j_model, -10, 1000);
        
        % check if the exchange of scfa is open in the model, if yes, close
        % it
        i_in_exchange_status = ismember(i_scfa_exchange_rxns_name, j_exchange_rxns);
        if i_in_exchange_status
            j_model = changeRxnBounds(j_model, i_scfa_exchange_rxns_name, 0, 'l');
        end
        
        % add the demand reaction of scfa
        j_model = addDemandReaction(j_model, i_scfa_met);
        
        % change objective function
        j_model = changeObjective(j_model, i_scfa_demand_rxns_name);
        
        % maximize the obj
        j_sol = optimizeCbModel(j_model);
        
        scfa_production(i, j) = j_sol.f;
        
    end
end

save('scfa_production.mat', 'scfa_production')
save scfa_id;
save scfa_name;