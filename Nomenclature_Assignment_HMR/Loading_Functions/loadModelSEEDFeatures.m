function [ outDict ] = loadModelSEEDFeatures( filename )

    %Reading the file
    fileID = fopen(filename);
    features = textscan(fileID,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s','delimiter','\t');
    fclose(fileID);

    outDict=containers.Map( features{6},features{16} );
    tmp=containers.Map( features{16},features{6} );
    tmp=tmp('');
    remove(outDict,tmp);
    remove(outDict,'patric_id')
end