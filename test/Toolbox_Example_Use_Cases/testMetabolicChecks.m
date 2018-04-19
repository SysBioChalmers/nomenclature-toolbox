clear
tic
%% Exemplary code for Running Metabolic Checks for SCFA and AA production 

production = metabolicChecks( model, 'scfa' );
production = metabolicChecks( model, 'aa' );
production = metabolicChecks( model, 'random' );
production = metabolicChecks( model, '' );

%%
toc