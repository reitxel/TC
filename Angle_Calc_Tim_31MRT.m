clc
clear all

%vertebra to which landmark you want to calculate angle to: (1,3,6,8)
LMnmbr = 3;
%The reference landmark on the spine that the angle is calculated to
%(4,5,7)
LMspine = 4;
% replace with the path of your folder (control, preop or postop)
path = 'C:\Users\timhe\Desktop\control\';



%%
% Extracting the information from all the files and folders in the directory
folder = dir(fullfile(path, '*'));
folder = {folder([folder.isdir]).name};
folder= folder(~ismember(folder,{'.','..'}));
col_names = folder;
row_names = {'Rib 1'; 'Rib 3'; 'Rib 5'; 'Rib 7'};

for i=1:length(folder)
    folder{i}= fullfile(path,folder{i});
end

for m=1:length(folder)
    data = char(folder(1,m));
    files = dir(fullfile(data, '*')); % get information about all files and folders in the directory
    files = files(~[files.isdir]); % keep only non-directory files    
    filepaths = fullfile(data, {files.name}); % create full file paths for each file
    % read the json files
    for i = 1:length(filepaths)
        fid = fopen(filepaths{i}, 'r');
        json_str = fscanf(fid, '%c', inf);
        fclose(fid);
        json_data = jsondecode(json_str);
        controlPoints{i} = json_data.markups.controlPoints;
    end
    
    % if the file has rib7
    if length(files)==4
    
        % eight landmarks per each rib, coordinates in 3D
        positions_rib1 = zeros(8, 3);
        positions_rib3 = zeros(8, 3);
        positions_rib5 = zeros(8, 3);
        positions_rib7 = zeros(8, 3);

        for i = 1:length(controlPoints)
            for j = 1:length(controlPoints{i})
                if i == 1
                   positions_rib1(j,:) = controlPoints{i}(j).position;
                end
                if i == 2
                    positions_rib3(j,:) = controlPoints{i}(j).position;
                end
                if i == 3
                    positions_rib5(j,:) = controlPoints{i}(j).position;
                end
                if i == 4
                    positions_rib7(j,:) = controlPoints{i}(j).position;
                end
            end

        end
    end

        ribs= {positions_rib1, positions_rib3, positions_rib5, positions_rib7};

        % Calculating the angles in the 3D-coordinate system 
        for i = 1:length(ribs)
            
            posspine=[ribs{i}(LMspine,1),ribs{i}(LMspine,2),ribs{i}(LMspine,3)];
            posonrib=[ribs{i}(LMnmbr,1),ribs{i}(LMnmbr,2),ribs{i}(LMnmbr,3)];
            
            if i == 1
                posspineup = posspine;
                posspinedown = [ribs{i+1}(LMspine,1),ribs{i+1}(LMspine,2),ribs{i+1}(LMspine,3)];
            elseif i == 4
                posspineup = [ribs{i-1}(LMspine,1),ribs{i-1}(LMspine,2),ribs{i-1}(LMspine,3)];
                posspinedown = posspine;
            else
                posspineup=[ribs{i-1}(LMspine,1),ribs{i-1}(LMspine,2),ribs{i-1}(LMspine,3)];
                posspinedown=[ribs{i+1}(LMspine,1),ribs{i+1}(LMspine,2),ribs{i+1}(LMspine,3)];
            end

            S1= posspineup - posspinedown;
            S2= posonrib - posspine;
            Theta = atan2(norm(cross(S1, S2)), dot(S1, S2));
            theta3d (i,m)= Theta*360/(2*pi);
        end

        % Calculating the angles in a 2D-coordinate system (not taking
        % posterior and anterior differences into account
        for i = 1:length(ribs)
            posspine=[ribs{i}(LMspine,1), 1 , ribs{i}(LMspine,3)];
            posonrib=[ribs{i}(LMnmbr,1), 1 , ribs{i}(LMnmbr,3)];
            if i == 1
                posspineup = posspine;
                posspinedown = [ribs{i+1}(LMspine,1),1,ribs{i+1}(LMspine,3)];
            elseif i == 4
                posspineup = [ribs{i-1}(LMspine,1),1,ribs{i-1}(LMspine,3)];
                posspinedown = posspine;
            else
                posspineup=[ribs{i-1}(LMspine,1),1,ribs{i-1}(LMspine,3)];
                posspinedown=[ribs{i+1}(LMspine,1),1,ribs{i+1}(LMspine,3)];

            end
            S1= posspineup - posspinedown;
            S2= posonrib - posspine;
            Theta = atan2(norm(cross(S1, S2)), dot(S1, S2));
            theta2d (i,m)= Theta*360/(2*pi);
        end
    
    % If the file does NOT have rib7
    if length(files)==3
    
        % eight landmarks per each rib, coordinates in 3D
        positions_rib1 = zeros(8, 3);
        positions_rib3 = zeros(8, 3);
        positions_rib5 = zeros(8, 3);
        positions_rib7 = zeros(8, 3);

        for i = 1:length(controlPoints)
            for j = 1:length(controlPoints{i})
                if i == 1
                   positions_rib1(j,:) = controlPoints{i}(j).position;
                end
                if i == 2
                    positions_rib3(j,:) = controlPoints{i}(j).position;
                end
                if i == 3
                    positions_rib5(j,:) = controlPoints{i}(j).position;
                end
            end
        end

        ribs= {positions_rib1, positions_rib3, positions_rib5, positions_rib7};

        % Calculating the angles in the 3D-coordinate system
        for i = 1:length(ribs) 
            if i~=4 
                posspine=[ribs{i}(LMspine,1),ribs{i}(LMspine,2),ribs{i}(LMspine,3)];
                posonrib=[ribs{i}(LMnmbr,1),ribs{i}(LMnmbr,2),ribs{i}(LMnmbr,3)];
                if i == 1
                    posspineup = posspine;
                    posspinedown = [ribs{i+1}(LMspine,1),ribs{i+1}(LMspine,2),ribs{i+1}(LMspine,3)];

                elseif i == 3
                    posspineup = [ribs{i-1}(LMspine,1),ribs{i-1}(LMspine,2),ribs{i-1}(LMspine,3)];
                    posspinedown = posspine;

                else
                    posspineup=[ribs{i-1}(LMspine,1),ribs{i-1}(LMspine,2),ribs{i-1}(LMspine,3)];
                    posspinedown=[ribs{i+1}(LMspine,1),ribs{i+1}(LMspine,2),ribs{i+1}(LMspine,3)];

                end
                
                S1= posspineup - posspinedown;
                S2= posonrib - posspine;
                Theta = atan2(norm(cross(S1, S2)), dot(S1, S2));
                theta3d (i,m)= Theta*360/(2*pi); 
            end
            if i==4
                theta3d (i,m) = NaN;
            end
        end

        % Calculating the angles in a 2D-coordinate system (not taking
        % posterior and anterior differences into account
        for i = 1:length(ribs) 
            if i~=4
                posspine=[ribs{i}(LMspine,1), 1 , ribs{i}(LMspine,3)];
                posonrib=[ribs{i}(LMnmbr,1), 1 , ribs{i}(LMnmbr,3)];
                if i == 1
                    posspineup = posspine;
                    posspinedown = [ribs{i+1}(LMspine,1),1,ribs{i+1}(LMspine,3)];
                elseif i == 3
                    posspineup = [ribs{i-1}(LMspine,1),1,ribs{i-1}(LMspine,3)];
                    posspinedown = posspine;
                else
                    posspineup=[ribs{i-1}(LMspine,1),1,ribs{i-1}(LMspine,3)];
                    posspinedown=[ribs{i+1}(LMspine,1),1,ribs{i+1}(LMspine,3)];
                end

                S1= posspineup - posspinedown;
                S2= posonrib - posspine;
                Theta = atan2(norm(cross(S1, S2)), dot(S1, S2));
                theta2d (i,m)= Theta*360/(2*pi);
            end
            if i==4
                theta2d (i,m) = NaN;
            end
        end
    end

 end

%% calculate mean and std and displaying the results

%Calculate average and STDEV for all ribs and all scans in the folder
%For the 2D and 3D data set
for n=1:length(row_names)
    sum2d=0;
    sum3d=0;
    num=1;
    values2d=[];
    values3d=[];

    for o=1:length(col_names)
        is_nan=isnan(theta2d);
        if is_nan(n,o)==0
            sum2d=theta2d(n,o)+sum2d;
            values2d(1,num)= theta2d(n,o);
            sum3d=theta3d(n,o)+sum3d;
            values3d(1,num)= theta3d(n,o);
            num=num+1;
        end
    end
    
    result2d(n,1)=sum2d/length(values2d);
    result3d(n,1)=sum3d/length(values3d);
    
    result2d(n,2)=std(values2d(1,:));
    result3d(n,2)=std(values3d(1,:));
    
end

titles = {'Average'; 'Std'};


% Display the 2D and 3D results in tables and also plotting the summary
% including Average and STDEV

T2d = array2table(theta2d, 'RowNames', row_names, 'VariableNames', col_names);
T3d = array2table(theta3d, 'RowNames', row_names, 'VariableNames', col_names);
Res2d = array2table(result2d, 'RowNames', row_names, 'VariableNames', titles);
Res3d = array2table(result3d, 'RowNames', row_names, 'VariableNames', titles);

disp(' ')
disp(['2D angles for landmark ', num2str(LMnmbr)])
disp(' ')
disp(T2d)
disp(' ')
disp(['2D Average and Std for landmark ', num2str(LMnmbr)])
disp(' ')
disp(Res2d)
disp(' ')
disp(['3D angles and Std for landmark ', num2str(LMnmbr)])
disp(' ')
disp(T3d)
disp(' ')
disp(['3D Average and Std for landmark ', num2str(LMnmbr)])
disp(' ')
disp(Res3d)

