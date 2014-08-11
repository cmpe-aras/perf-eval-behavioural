function parameters(~, pars, timestamp)
%% Write Parameters to txt file
fileID = fopen(sprintf('%s\\parameters_%s.txt', pars.results.save.directory, timestamp),'w');
if (fileID == -1)
    error('Could not create file');
end
fields = fieldnamesr(pars,'prefix');
fprintf(fileID,'Parameters\n');
for i=1:length(fields)
    if(ischar(eval(fields{i})))
        %out = sprintf('%s \n %s = %s', out, fields{i}, eval(fields{i}));
        fprintf(fileID,'%s = %s\n', fields{i}, eval(fields{i}));
    else
        %out = sprintf('%s \n %s = %d', out, fields{i}, eval(fields{i}));
        X = eval(fields{i});
        out = '';
        for j=1:length(X)
            out = sprintf('%s %d', out, X(j));
        end
        %fprintf(fileID,'%s = %d\n', fields{i}, eval(fields{i}));
        fprintf(fileID,'%s = %s\n', fields{i}, out);
    end
end
fclose(fileID);
end