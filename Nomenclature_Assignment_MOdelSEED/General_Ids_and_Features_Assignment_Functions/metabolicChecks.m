function [ production ] = metabolicChecks( model, check )
%metabolicChecks
%   Function for performing different metabolic checks
%   to a Genome-Scale Metabolic Model reconstructed from ModelSEED.
%   The checks are verifying the production of:
%       a. ShortChain Fatty Acids:
%           Acetate
%             Propanoate
%             Butyrate
%       b. Amino Acids
%             Glutamate	
%             Glycine
%             Alanine
%             Lysine
%             Aspartate
%             Arginine
%             Glutamine
%             Serine
%             Methionine
%             Tryptophan
%             Phenylalanine
%             Tyrosine
%             Cysteine
%             Leucine
%             Histidine
%             Proline
%             Valine
%             Threonine
%             Isoleucine
%             Asparagine
%
% Takes as input argument:
%       a. a Genome-Scale Metabolic Model
%       b. a string representing the desired annotation, e.g.
%           i.  'scfa' for Short Chain Fatty Acids
%           ii. 'aa' for amino acids
%          
%
%   Returns one (nxm) matrix 'production' containg the production data for each SCFA or AA
%   after the model's optimisation and contstrains
%
%   Usage: production = metabolicChecks( model, check )
%   Dimitra Lappa & Manish Kumar, 2016-09-04


     if isempty(check)
                while isempty(check)
                    fprintf( 'Please provide a proper input argument \n');
                    fprintf( 'for performing metabolic checks such as:\n');
                    fprintf( ' "scfa " or \n');
                    fprintf( ' " aa "\n');
                    prompt = 'Please provide a proper answer\n';
                    check = input(prompt,'s');
                    check = input(prompt,'s');
                end
     end
    if strcmpi(check, 'scfa')
        % load the mat file of model
        num_model = length(model);
        % load the short-chain fatty acid information
        scfa_info = readtable('SCFA.txt', 'Delimiter', '\t', 'ReadVariableNames',false);
        scfa_id = scfa_info{2:end, 'Var1'}
        scfa_name = scfa_info{2:end, 'Var2'}

        num_scfa = length(scfa_id);

        % for each of model check the SCFA production
        % create a array to store the production
        scfa_production = zeros(num_scfa, num_model);

        for i = 1:num_scfa

            i_scfa_name = scfa_name(i);
            i_scfa_id = scfa_id(i);

            i_scfa_exchange_rxns_name = strcat('EX_', i_scfa_id, '_e0');
            i_scfa_met = i_scfa_id;
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
        production = scfa_production;
        save('scfa_production.mat', 'scfa_production')
        save scfa_id;
        save scfa_name;
    elseif strcmpi(check, 'aa')
        num_model = length(model);
        % load the short-chain fatty acid information
        aa_info = readtable('AA.txt', 'Delimiter', '\t', 'ReadVariableNames',false);
        aa_id = aa_info{2:end, 'Var1'}
        aa_name = aa_info{2:end, 'Var2'}

        num_aa = length(aa_id);

        % for each of model check the aa production
        % create a array to store the production
        aa_production = zeros(num_aa, num_model);

        for i = 1:num_aa

            i_aa_name = aa_name(i);
            i_aa_id = aa_id(i);

            i_aa_exchange_rxns_name = strcat('EX_', i_aa_id, '_e0');
            i_aa_met = i_aa_id;
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
        production = aa_production;
        save('aa_production.mat', 'aa_production')
        save aa_id;
        save aa_name;
    else
        fprintf( 'No proper input argument,cannot perform Metabolic Checks,re-run your command \n');
    end


end

