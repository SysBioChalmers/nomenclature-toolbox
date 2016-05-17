function [ outModel ] = getMetFormulaSEEDId( model )

    %Reading the file
    fileID = fopen('ModelSEED-compounds-db.csv');
    chemicalFormula = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s','delimiter',';');
    fclose(fileID);

    

end