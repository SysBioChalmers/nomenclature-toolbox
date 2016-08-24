uiopen('uniprotMappings.tab');
strCell=cellfun(@(x,y) struct('id',x,'regex',y),ID,REGEX);
dbStr=containers.Map(DB, arrayfun(@(x) ({x}), strCell));
save('uniprotIdMap.mat','dbStr');