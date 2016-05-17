function out=diginto(thestruct, level)

if nargin < 2
    level = 0;
end

out={};
fn = fieldnames(thestruct);
for n = 1:length(fn)
    tabs = '';
    for m = 1:level
        tabs = [tabs '    '];
    end
    out{end+1}=fn{n};%disp([tabs fn{n}])
    fn2 = getfield(thestruct,fn{n});
    if isstruct(fn2)
        diginto(fn2, level+1);
    end
end
end