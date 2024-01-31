machine_type = {'fan','pump','slider','valve'};
machine_id = {'id_00','id_02','id_04','id_06'};
label = {'normal','abnormal'};

for a = 1:length(machine_type)
    for b = 1:length(machine_id)
        for c = 1:length(label)
            mt = machine_type{a};
            mi = machine_id{b};
            lb = label{c};

            fprintf('Type: %s, ID: %s, Label: %s\n', mt, mi, lb);

            % String templating for dirpath
            dirpath_template = 'E:\\Downloads\\dataset-timbral\\6_dB_%s\\%s\\%s\\%s';
            
            % Create the formatted dirpath string
            dirpath = sprintf(dirpath_template, mt, mt, mi, lb);
            
            % Display the result
            disp(dirpath);
            
            fileList = dir(dirpath);
            
            for i = 1:5%length(fileList)
                if strcmp(fileList(i).name, '.') || strcmp(fileList(i).name, '..')
                    continue;
                end
            
                filename = sprintf('%s\\%s', dirpath, fileList(i).name);
                disp(filename);
                [audioIn,fs] = audioread(filename);
                
                audioIn = audioIn(:,1);
                
                f0 = pitch(audioIn,fs);
                
                % Check if there is any zero value in the array
                hasZero = any(f0 <= 1);
                
                % Display the result
                if hasZero
                    disp('The array contains at least one zero value.');
                else
                    disp('The array does not contain any zero value.');
                end
                
                tiledlayout(2,1)
                
                nexttile
                t = (0:length(audioIn)-1)/fs;
                plot(t,audioIn)
                xlabel("Time (s)")
                ylabel("Amplitude")
                grid minor
                axis tight
                
                nexttile
                pitch(audioIn,fs)
                
                saveas(gcf, sprintf('%s-%s-%s-%s.png', mt, mi, lb, fileList(i).name))
            end
        end
    end
end

