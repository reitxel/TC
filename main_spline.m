clc
clear
close all

warning('off','all')
warning

% INSERT HERE THE FOLDER TO THE LANDMARKS OF THE PATIENT
folder = 'C:\Users\raque\OneDrive\Escritorio\UU\team challenge\Software_Group2\Landmarks_JSON\Preop\Preop1\'; % replace with the path of your folder
files = dir(fullfile(folder, '*')); % get information about all files and folders in the directory
files = files(~[files.isdir]); % keep only non-directory files
filepaths = fullfile(folder, {files.name}); % create full file paths for each file
disp(filepaths)

% Read json files
for i = 1:length(filepaths)
    fid = fopen(filepaths{i}, 'r');
    json_str = fscanf(fid, '%c', inf);
    fclose(fid);
    json_data = jsondecode(json_str);
    controlPoints{i} = json_data.markups.controlPoints;
end
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

%% Interpolation of the ribs

% 1st rib
x_rib1_1 = [positions_rib1(2,1);positions_rib1(1,1);positions_rib1(6,1);positions_rib1(4,1)];
y_rib1_1 = [positions_rib1(2,2);positions_rib1(1,2);positions_rib1(6,2);positions_rib1(4,2)];
z_rib1_1 = [positions_rib1(2,3);positions_rib1(1,3);positions_rib1(6,3);positions_rib1(4,3)];
t = [1,2,3,4]; % time stamp

% Apply spline interpolation for each x, y and z on the convex side
tt = linspace(t(1),t(end), 250);
xx_rib1_1 = interp1(t,x_rib1_1,tt,'spline');
yy_rib1_1 = interp1(t,y_rib1_1,tt,'spline');
zz_rib1_1 = interp1(t,z_rib1_1,tt,'spline');

x_rib1_2 = [positions_rib1(2,1);positions_rib1(3,1);positions_rib1(8,1);positions_rib1(4,1)];
y_rib1_2 = [positions_rib1(2,2);positions_rib1(3,2);positions_rib1(8,2);positions_rib1(4,2)];
z_rib1_2 = [positions_rib1(2,3);positions_rib1(3,3);positions_rib1(8,3);positions_rib1(4,3)];

% Apply spline interpolation for each x, y and z on the concave side
xx_rib1_2 = interp1(t,x_rib1_2,tt,'spline');
yy_rib1_2 = interp1(t,y_rib1_2,tt,'spline');
zz_rib1_2 = interp1(t,z_rib1_2,tt,'spline');

disp('RIB 1')
% Visualize the result, both landmarks and the interpolations
subplot(4,2,1)
scatter3(x_rib1_1,y_rib1_1,z_rib1_1, 'MarkerEdgeColor','r')
hold on
scatter3(x_rib1_2,y_rib1_2,z_rib1_2, 'MarkerEdgeColor','b')
hold on
plot3(xx_rib1_1,yy_rib1_1,zz_rib1_1, 'color','r')
hold on
plot3(xx_rib1_2,yy_rib1_2,zz_rib1_2, 'color','b')
hold off
title('Rib 1');

subplot(4,2,2)
spline_rib_func_flip(positions_rib1);


% Interpolation 3r rib

x_rib3_1 = [positions_rib3(2,1);positions_rib3(1,1);positions_rib3(6,1);positions_rib3(4,1)];
y_rib3_1 = [positions_rib3(2,2);positions_rib3(1,2);positions_rib3(6,2);positions_rib3(4,2)];
z_rib3_1 = [positions_rib3(2,3);positions_rib3(1,3);positions_rib3(6,3);positions_rib3(4,3)];

% Apply interpolation for each x,y and z on the convex side
xx_rib3_1 = interp1(t,x_rib3_1,tt,'spline');
yy_rib3_1 = interp1(t,y_rib3_1,tt,'spline');
zz_rib3_1 = interp1(t,z_rib3_1,tt,'spline');

x_rib3_2 = [positions_rib3(2,1);positions_rib3(3,1);positions_rib3(8,1);positions_rib3(4,1)];
y_rib3_2 = [positions_rib3(2,2);positions_rib3(3,2);positions_rib3(8,2);positions_rib3(4,2)];
z_rib3_2 = [positions_rib3(2,3);positions_rib3(3,3);positions_rib3(8,3);positions_rib3(4,3)];

% Apply interpolation for each x,y and z on the concave side
xx_rib3_2 = interp1(t,x_rib3_2,tt,'spline');
yy_rib3_2 = interp1(t,y_rib3_2,tt,'spline');
zz_rib3_2 = interp1(t,z_rib3_2,tt,'spline');

disp(' ')
disp('RIB 3')
% Visualize the result
subplot(4,2,3)
scatter3(x_rib3_1,y_rib3_1,z_rib3_1, 'MarkerEdgeColor','r')
hold on
scatter3(x_rib3_2,y_rib3_2,z_rib3_2, 'MarkerEdgeColor','b')
hold on
plot3(xx_rib3_1,yy_rib3_1,zz_rib3_1, 'color','r')
hold on
plot3(xx_rib3_2,yy_rib3_2,zz_rib3_2, 'color','b')
title('Rib 3');
hold off

subplot(4,2,4)
spline_rib_func_flip(positions_rib3);

% Interpolation 5th rib
x_rib5_1 = [positions_rib5(2,1);positions_rib5(1,1);positions_rib5(6,1);positions_rib5(4,1)];
y_rib5_1 = [positions_rib5(2,2);positions_rib5(1,2);positions_rib5(6,2);positions_rib5(4,2)];
z_rib5_1 = [positions_rib5(2,3);positions_rib5(1,3);positions_rib5(6,3);positions_rib5(4,3)];

% Apply interpolation for each x,y and z on the convex side
xx_rib5_1 = interp1(t,x_rib5_1,tt,'spline');
yy_rib5_1 = interp1(t,y_rib5_1,tt,'spline');
zz_rib5_1 = interp1(t,z_rib5_1,tt,'spline');

x_rib5_2 = [positions_rib5(2,1);positions_rib5(3,1);positions_rib5(8,1);positions_rib5(4,1)];
y_rib5_2 = [positions_rib5(2,2);positions_rib5(3,2);positions_rib5(8,2);positions_rib5(4,2)];
z_rib5_2 = [positions_rib5(2,3);positions_rib5(3,3);positions_rib5(8,3);positions_rib5(4,3)];
% Apply interpolation for each x,y and z on the concave side
xx_rib5_2 = interp1(t,x_rib5_2,tt,'spline');
yy_rib5_2 = interp1(t,y_rib5_2,tt,'spline');
zz_rib5_2 = interp1(t,z_rib5_2,tt,'spline');

disp(' ')
disp('RIB 5')
% Visualize the result
subplot(4,2,5)
scatter3(x_rib5_1,y_rib5_1,z_rib5_1, 'MarkerEdgeColor','r')
hold on
scatter3(x_rib5_2,y_rib5_2,z_rib5_2, 'MarkerEdgeColor','b')
hold on
plot3(xx_rib5_1,yy_rib5_1,zz_rib5_1, 'color','r')
hold on
plot3(xx_rib5_2,yy_rib5_2,zz_rib5_2, 'color','b')
title('Rib 5');
hold off

subplot(4,2,6)
spline_rib_func_flip(positions_rib5);

% Interpolation 7th rib
% condition in case there are no landmarks for rib 7
if all(positions_rib7(:)==0)
    disp('No 7th rib')
else
    x_rib7_1 = [positions_rib7(2,1);positions_rib7(1,1);positions_rib7(6,1);positions_rib7(4,1)];
    y_rib7_1 = [positions_rib7(2,2);positions_rib7(1,2);positions_rib7(6,2);positions_rib7(4,2)];
    z_rib7_1 = [positions_rib7(2,3);positions_rib7(1,3);positions_rib7(6,3);positions_rib7(4,3)];
    % Apply interpolation for each x,y and z on the convex side
    xx_rib7_1 = interp1(t,x_rib7_1,tt,'spline');
    yy_rib7_1 = interp1(t,y_rib7_1,tt,'spline');
    zz_rib7_1 = interp1(t,z_rib7_1,tt,'spline');

    x_rib7_2 = [positions_rib7(2,1);positions_rib7(3,1);positions_rib7(8,1);positions_rib7(4,1)];
    y_rib7_2 = [positions_rib7(2,2);positions_rib7(3,2);positions_rib7(8,2);positions_rib7(4,2)];
    z_rib7_2 = [positions_rib7(2,3);positions_rib7(3,3);positions_rib7(8,3);positions_rib7(4,3)];
    % Apply interpolation for each x,y and z on the concave side
    xx_rib7_2 = interp1(t,x_rib7_2,tt,'spline');
    yy_rib7_2 = interp1(t,y_rib7_2,tt,'spline');
    zz_rib7_2 = interp1(t,z_rib7_2,tt,'spline');

    disp(' ')
    disp('RIB 7')
    % Visualize the result
    subplot(4,2,7)
    scatter3(x_rib7_1,y_rib7_1,z_rib7_1, 'MarkerEdgeColor','r')
    hold on
    scatter3(x_rib7_2,y_rib7_2,z_rib7_2, 'MarkerEdgeColor','b')
    hold on
    plot3(xx_rib7_1,yy_rib7_1,zz_rib7_1, 'color','r')
    hold on
    plot3(xx_rib7_2,yy_rib7_2,zz_rib7_2, 'color','b')
    title('Rib 7');
    hold off

    subplot(4,2,8)
    spline_rib_func_flip(positions_rib7);
end

%% Visualization of all ribs

figure
subplot(1,2,1)
scatter3(x_rib1_1,y_rib1_1,z_rib1_1,'MarkerEdgeColor','r')
hold on
scatter3(x_rib3_1,y_rib3_1,z_rib3_1,'MarkerEdgeColor','g')
hold on
scatter3(x_rib5_1,y_rib5_1,z_rib5_1,'MarkerEdgeColor','b')

hold on
scatter3(x_rib1_2,y_rib1_2,z_rib1_2,'MarkerEdgeColor','r')
hold on
scatter3(x_rib3_2,y_rib3_2,z_rib3_2,'MarkerEdgeColor','g')
hold on
scatter3(x_rib5_2,y_rib5_2,z_rib5_2,'MarkerEdgeColor','b')

hold on
plot3(xx_rib1_1,yy_rib1_1,zz_rib1_1,'color','r')
hold on
plot3(xx_rib3_1,yy_rib3_1,zz_rib3_1,'color','g')
hold on
plot3(xx_rib5_1,yy_rib5_1,zz_rib5_1,'color','b')

hold on
plot3(xx_rib1_2,yy_rib1_2,zz_rib1_2,'color','r')
hold on
plot3(xx_rib3_2,yy_rib3_2,zz_rib3_2,'color','g')
hold on
plot3(xx_rib5_2,yy_rib5_2,zz_rib5_2,'color','b')
hold on

if all(positions_rib7(:)==0)
    disp('No 7th rib')
else
    scatter3(x_rib7_1,y_rib7_1,z_rib7_1,'MarkerEdgeColor','c')
    hold on
    scatter3(x_rib7_2,y_rib7_2,z_rib7_2,'MarkerEdgeColor','c')
    hold on
    plot3(xx_rib7_1,yy_rib7_1,zz_rib7_1,'color','c')
    hold on
    plot3(xx_rib7_2,yy_rib7_2,zz_rib7_2,'color','c')
end

legend('Rib1', 'Rib3', 'Rib5', 'Rib7')
title('Visualization of rib 1, 3, 5, and 7')

% Visualization of all ribs with spine and sternum
% SPINE
if all(positions_rib7(:)==0)
    % SPINE
    x_spine = [positions_rib1(4,1);positions_rib3(4,1);positions_rib5(4,1)];
    y_spine = [positions_rib1(4,2);positions_rib3(4,2);positions_rib5(4,2)];
    z_spine = [positions_rib1(4,3);positions_rib3(4,3);positions_rib5(4,3)];
    
    % STERNUM
    x_ster = [positions_rib1(2,1);positions_rib3(2,1);positions_rib5(2,1)];
    y_ster = [positions_rib1(2,2);positions_rib3(2,2);positions_rib5(2,2)];
    z_ster = [positions_rib1(2,3);positions_rib3(2,3);positions_rib5(2,3)];
    
    t = [1,2,3]; % Assumed time stamp
    tt = linspace(t(1),t(end), 250);
else
    % SPINE
    x_spine = [positions_rib1(4,1);positions_rib3(4,1);positions_rib5(4,1);positions_rib7(4,1)];
    y_spine = [positions_rib1(4,2);positions_rib3(4,2);positions_rib5(4,2);positions_rib7(4,2)];
    z_spine = [positions_rib1(4,3);positions_rib3(4,3);positions_rib5(4,3);positions_rib7(4,3)];
    
    % STERNUM
    x_ster = [positions_rib1(2,1);positions_rib3(2,1);positions_rib5(2,1);positions_rib7(2,1)];
    y_ster = [positions_rib1(2,2);positions_rib3(2,2);positions_rib5(2,2);positions_rib7(2,2)];
    z_ster = [positions_rib1(2,3);positions_rib3(2,3);positions_rib5(2,3);positions_rib7(2,3)];
    
    x_con_7 = [positions_rib7(2,1)', positions_rib7(4,1)'];
    y_con_7 = [positions_rib7(2,2)', positions_rib7(4,2)'];
    z_con_7 = [positions_rib7(2,3)', positions_rib7(4,3)'];
end

% interpolation to optain the spine and sternum path
xx_spine = interp1(t,x_spine,tt,'spline');
yy_spine = interp1(t,y_spine,tt,'spline');
zz_spine = interp1(t,z_spine,tt,'spline');

xx_ster = interp1(t,x_ster,tt,'spline');
yy_ster = interp1(t,y_ster,tt,'spline');
zz_ster = interp1(t,z_ster,tt,'spline');

x_con_1 = [positions_rib1(2,1)', positions_rib1(4,1)'];
y_con_1 = [positions_rib1(2,2)', positions_rib1(4,2)'];
z_con_1 = [positions_rib1(2,3)', positions_rib1(4,3)'];

x_con_3 = [positions_rib3(2,1)', positions_rib3(4,1)'];
y_con_3 = [positions_rib3(2,2)', positions_rib3(4,2)'];
z_con_3 = [positions_rib3(2,3)', positions_rib3(4,3)'];

x_con_5 = [positions_rib5(2,1)', positions_rib5(4,1)'];
y_con_5 = [positions_rib5(2,2)', positions_rib5(4,2)'];
z_con_5 = [positions_rib5(2,3)', positions_rib5(4,3)'];

% plot the line between the two points
subplot(1,2,2)
plot3(xx_spine,yy_spine,zz_spine,'color','m','LineWidth', 2)
hold on
plot3(xx_ster, yy_ster, zz_ster,'color','k','LineWidth', 2)
hold on
plot3(x_con_1, y_con_1, z_con_1, 'color','y','LineWidth', 2);
hold on
plot3(x_con_3, y_con_3, z_con_3, 'color','y','LineWidth', 2);
hold on
plot3(x_con_5, y_con_5, z_con_5, 'color','y','LineWidth', 2);
hold on

scatter3(x_rib1_1,y_rib1_1,z_rib1_1,'MarkerEdgeColor','r')
hold on
scatter3(x_rib3_1,y_rib3_1,z_rib3_1,'MarkerEdgeColor','g')
hold on
scatter3(x_rib5_1,y_rib5_1,z_rib5_1,'MarkerEdgeColor','b')
hold on

scatter3(x_rib1_2,y_rib1_2,z_rib1_2,'MarkerEdgeColor','r')
hold on
scatter3(x_rib3_2,y_rib3_2,z_rib3_2,'MarkerEdgeColor','g')
hold on
scatter3(x_rib5_2,y_rib5_2,z_rib5_2,'MarkerEdgeColor','b')

hold on
plot3(xx_rib1_1,yy_rib1_1,zz_rib1_1,'color','r')
hold on
plot3(xx_rib3_1,yy_rib3_1,zz_rib3_1,'color','g')
hold on
plot3(xx_rib5_1,yy_rib5_1,zz_rib5_1,'color','b')

hold on
plot3(xx_rib1_2,yy_rib1_2,zz_rib1_2,'color','r')
hold on
plot3(xx_rib3_2,yy_rib3_2,zz_rib3_2,'color','g')
hold on
plot3(xx_rib5_2,yy_rib5_2,zz_rib5_2,'color','b')

if all(positions_rib7(:)==0)
    disp('No 7th rib')
else
    plot3(x_con_7, y_con_7, z_con_7, 'color','y','LineWidth', 2)
    hold on
    scatter3(x_rib7_1,y_rib7_1,z_rib7_1,'MarkerEdgeColor','c')
    hold on
    scatter3(x_rib7_2,y_rib7_2,z_rib7_2,'MarkerEdgeColor','c')
    hold on
    plot3(xx_rib7_1,yy_rib7_1,zz_rib7_1,'color','c')
    hold on
    plot3(xx_rib7_2,yy_rib7_2,zz_rib7_2,'color','c')
end

legend('Spine', 'Sternum', 'Connection')
title('Visualization of rib 1, 3, 5, and 7 with spine and sternum')

%% AREAS between ribs

p_rib1 = [positions_rib1(2,:); positions_rib1(1,:); positions_rib1(6,:); positions_rib1(4,:); positions_rib1(8,:); positions_rib1(3,:)];
p_rib1_spline = [p_rib1; xx_rib1_1' yy_rib1_1' zz_rib1_1'; xx_rib1_2' yy_rib1_2' zz_rib1_2'];
p_rib1_1_spline = [positions_rib1(2,:); positions_rib1(1,:); positions_rib1(6,:); positions_rib1(4,:); xx_rib1_1' yy_rib1_1' zz_rib1_1'];
p_rib1_2_spline = [positions_rib1(2,:); positions_rib1(4,:); positions_rib1(8,:); positions_rib1(3,:); xx_rib1_2' yy_rib1_2' zz_rib1_2'];

p_rib3 = [positions_rib3(2,:); positions_rib3(1,:); positions_rib3(6,:); positions_rib3(4,:); positions_rib3(8,:); positions_rib3(3,:)];
p_rib3_spline = [p_rib3; xx_rib3_1' yy_rib3_1' zz_rib3_1'; xx_rib3_2' yy_rib3_2' zz_rib3_2'];
p_rib3_1_spline = [positions_rib3(2,:); positions_rib3(1,:); positions_rib3(6,:); positions_rib3(4,:); xx_rib3_1' yy_rib3_1' zz_rib3_1'];
p_rib3_2_spline = [positions_rib3(2,:);positions_rib3(4,:); positions_rib3(8,:); positions_rib3(3,:); xx_rib3_2' yy_rib3_2' zz_rib3_2'];

p_rib5 = [positions_rib5(2,:); positions_rib5(1,:); positions_rib5(6,:); positions_rib5(4,:); positions_rib5(8,:); positions_rib5(3,:)];
p_rib5_spline = [p_rib5; xx_rib5_1' yy_rib5_1' zz_rib5_1'; xx_rib5_2' yy_rib5_2' zz_rib5_2'];
p_rib5_1_spline = [positions_rib5(2,:); positions_rib5(1,:); positions_rib5(6,:); positions_rib5(4,:); xx_rib5_1' yy_rib5_1' zz_rib5_1'];
p_rib5_2_spline = [positions_rib5(2,:); positions_rib5(4,:); positions_rib5(8,:); positions_rib5(3,:); xx_rib5_2' yy_rib5_2' zz_rib5_2'];

if all(positions_rib7(:)~=0)
    p_rib7 = [positions_rib7(2,:); positions_rib7(1,:); positions_rib7(6,:); positions_rib7(4,:); positions_rib7(8,:); positions_rib7(3,:)];
    p_rib7_spline = [p_rib7; xx_rib7_1' yy_rib7_1' zz_rib7_1'; xx_rib7_2' yy_rib7_2' zz_rib7_2'];
    p_rib7_1_spline = [positions_rib7(2,:); positions_rib7(1,:); positions_rib7(6,:); positions_rib7(4,:); xx_rib7_1' yy_rib7_1' zz_rib7_1'];
    p_rib7_2_spline = [positions_rib7(2,:); positions_rib7(4,:); positions_rib7(8,:); positions_rib7(3,:); xx_rib7_2' yy_rib7_2' zz_rib7_2'];
end

%% Enclosed areas ribs

% Visualization of delaunay triangulation and ribs areas
figure
k = convhulln(p_rib1_spline);
trisurf(k, p_rib1_spline(:,1), p_rib1_spline(:,2), p_rib1_spline(:,3), 'FaceColor', 'red', 'FaceAlpha', 0.5);
hold on
trisurf(k, p_rib3_spline(:,1), p_rib3_spline(:,2), p_rib3_spline(:,3), 'FaceColor', 'green', 'FaceAlpha', 0.5);
hold on
trisurf(k, p_rib5_spline(:,1), p_rib5_spline(:,2), p_rib5_spline(:,3), 'FaceColor', 'blue', 'FaceAlpha', 0.5);
if all(positions_rib7(:)~=0)
    hold on
    trisurf(k, p_rib7_spline(:,1), p_rib7_spline(:,2), p_rib7_spline(:,3), 'FaceColor', 'cyan', 'FaceAlpha', 0.5);
end
legend('Rib1', 'Rib3', 'Rib5', 'Rib7')
title('Visualization of enclosed rib area for ribs 1, 3, 5, and 7')

figure
subplot(4,2,1)
trisurf(k, p_rib1_spline(:,1), p_rib1_spline(:,2), p_rib1_spline(:,3), 'FaceColor', 'red', 'FaceAlpha', 0.5);
title('Rib 1')
subplot(4,2,3)
trisurf(k, p_rib3_spline(:,1), p_rib3_spline(:,2), p_rib3_spline(:,3), 'FaceColor', 'green', 'FaceAlpha', 0.5);
title('Rib 3')
subplot(4,2,5)
trisurf(k, p_rib5_spline(:,1), p_rib5_spline(:,2), p_rib5_spline(:,3), 'FaceColor', 'blue', 'FaceAlpha', 0.5);
title('Rib 5')
if all(positions_rib7(:)~=0)
    subplot(4,2,7)
    trisurf(k, p_rib7_spline(:,1), p_rib7_spline(:,2), p_rib7_spline(:,3), 'FaceColor', 'cyan', 'FaceAlpha', 0.5);
    title('Rib 7')
end
subplot(4,2,2)
spline_area_func_flip(p_rib1_2_spline, p_rib1_1_spline);
subplot(4,2,4)
spline_area_func_flip(p_rib3_2_spline, p_rib3_1_spline);
subplot(4,2,6)
spline_area_func_flip(p_rib5_2_spline, p_rib5_1_spline);
if all(positions_rib7(:)~=0)
    subplot(4,2,8)
    spline_area_func_flip(p_rib7_2_spline, p_rib7_1_spline);
end

%% AREAS RIBS CALCULATION

% Area  RIB1
% Delaunay Triangulation
area_rib1 = spline_area_func(p_rib1_spline);
% Now, just for the concave or convex sides
area_rib1_1 = spline_area_func(p_rib1_1_spline);
area_rib1_2 = spline_area_func(p_rib1_2_spline);

% Area RIB3 
area_rib3 = spline_area_func(p_rib3_spline);
% Concave or convex sides
area_rib3_1 = spline_area_func(p_rib3_1_spline);
area_rib3_2 = spline_area_func(p_rib3_2_spline);

% Area RIB 5
area_rib5 = spline_area_func(p_rib5_spline);
% Concave or convex sides
area_rib5_1 = spline_area_func(p_rib5_1_spline);
area_rib5_2 = spline_area_func(p_rib5_2_spline);

% Area RIB 7
if all(positions_rib7(:)~=0)
    area_rib7 = spline_area_func(p_rib7_spline); 
    % Concave or convex sides
    area_rib7_1 = spline_area_func(p_rib7_1_spline);
    area_rib7_2 = spline_area_func(p_rib7_2_spline);
end

% AREAS DISPLAY
areas_rib1 = [area_rib1; area_rib1_1; area_rib1_2];
areas_rib3 = [area_rib3; area_rib3_1; area_rib3_2];
areas_rib5 = [area_rib5; area_rib5_1; area_rib5_2];
if all(positions_rib7(:)==0)
    T = table(areas_rib1, areas_rib3, areas_rib5, 'RowNames', {'Total Area', 'Concave Area', 'Convex Area'});
    disp('The area of the triangular surface of the different ribs is cm^2')
    disp(' ')
    disp(T)
else
    areas_rib7 = [area_rib7; area_rib7_1; area_rib7_2];
    T = table(areas_rib1, areas_rib3, areas_rib5, areas_rib7, 'RowNames', {'Total Area', 'Concave Area', 'Convex Area'});
    disp('The area of the triangular surface of the different ribs is cm^2')
    disp(' ')
    disp(T)
end


%% METRICS
% In this section several metric between the landmarks and interpolations
% are calculated. First the convex rib (side 1 in the code) was flipped 180
% degrees to compare the differences in symmetry between the right and left
% rib. From this, the distance between landmarks 2,1,6,4 and
% landmarks 2,3,8,4 (see displayed table on Command Window)

% Furthermore the distance between landmarks 1 and 3, and 6 and 8 were
% remarked on the Command Window.

% Next, the distance between all the points in the interpolation was calculated 
% and the mean value of this distance is displayed

% Lastly and approximation of the area for the distances between the
% interpolated points of the ribs is also displayed

% p_rib_spline_moving, convex side
disp('Rib 1 distances between landmarks')
[xx_rib1_flipped, yy_rib1_flipped, zz_rib1_flipped, flippedX_p1, flippedY_p1, flippedZ_p1] =  spline_rib_func_flip_dist(positions_rib1);
flipped_rib1_interpolation = [xx_rib1_flipped; yy_rib1_flipped; zz_rib1_flipped]';
fixed_rib1_interpolation = [xx_rib1_2; yy_rib1_2; zz_rib1_2]';

disp('Rib 3 distances between landmarks')
[xx_rib3_flipped, yy_rib3_flipped, zz_rib3_flipped, flippedX_p3, flippedY_p3, flippedZ_p3] =  spline_rib_func_flip_dist(positions_rib3);
flipped_rib3_interpolation = [xx_rib3_flipped; yy_rib3_flipped; zz_rib3_flipped]';
fixed_rib3_interpolation = [xx_rib3_2; yy_rib3_2; zz_rib3_2]';

disp('Rib 5 distances between landmarks')
[xx_rib5_flipped, yy_rib5_flipped, zz_rib5_flipped, flippedX_p5, flippedY_p5, flippedZ_p5] =  spline_rib_func_flip_dist(positions_rib5);
flipped_rib5_interpolation = [xx_rib5_flipped; yy_rib5_flipped; zz_rib5_flipped]';
fixed_rib5_interpolation = [xx_rib5_2; yy_rib5_2; zz_rib5_2]';

if all(positions_rib7(:)~=0)
    disp('Rib 7 distances between landmarks')
    [xx_rib7_flipped, yy_rib7_flipped, zz_rib7_flipped, flippedX_p7, flippedY_p7, flippedZ_p7] =  spline_rib_func_flip_dist(positions_rib7);
    flipped_rib7_interpolation = [xx_rib7_flipped; yy_rib7_flipped; zz_rib7_flipped]';
    fixed_rib7_interpolation = [xx_rib7_2; yy_rib7_2; zz_rib7_2]';
end

% RIB 1
subplot(4,2,1)
spline_rib_func_flip(positions_rib1);
subplot(4,2,2)
plot3(xx_rib1_flipped,yy_rib1_flipped,zz_rib1_flipped, 'color','r')
hold on
plot3(xx_rib1_2,yy_rib1_2,zz_rib1_2, 'color','b')
hold on
scatter3(flippedX_p1,flippedY_p1,flippedZ_p1, 'MarkerEdgeColor','r')
hold on
scatter3(x_rib1_2,y_rib1_2,z_rib1_2, 'MarkerEdgeColor','b')
hold on
for i= 1:250
    x_con_1 = [flipped_rib1_interpolation(i,1), fixed_rib1_interpolation(i,1)];
    y_con_1 = [flipped_rib1_interpolation(i,2), fixed_rib1_interpolation(i,2)];
    z_con_1 = [flipped_rib1_interpolation(i,3), fixed_rib1_interpolation(i,3)]; 
    hold on
    plot3(x_con_1, y_con_1, z_con_1, 'color','y');
end
title('Flipped ribs comparison connection');
legend('Right', 'Left');
hold off

% RIB 3
subplot(4,2,3)
spline_rib_func_flip(positions_rib3);
subplot(4,2,4)
plot3(xx_rib3_flipped,yy_rib3_flipped,zz_rib3_flipped, 'color','r')
hold on
plot3(xx_rib3_2,yy_rib3_2,zz_rib3_2, 'color','b')
hold on
scatter3(flippedX_p3,flippedY_p3,flippedZ_p3, 'MarkerEdgeColor','r')
hold on
scatter3(x_rib3_2,y_rib3_2,z_rib3_2, 'MarkerEdgeColor','b')
hold on
for i= 1:250
    
    x_con_3 = [flipped_rib3_interpolation(i,1), fixed_rib3_interpolation(i,1)];
    y_con_3 = [flipped_rib3_interpolation(i,2), fixed_rib3_interpolation(i,2)];
    z_con_3 = [flipped_rib3_interpolation(i,3), fixed_rib3_interpolation(i,3)]; 
    
    hold on
    plot3(x_con_3, y_con_3, z_con_3, 'color','y');
    
end
title('Flipped ribs comparison connection');
legend('Right', 'Left');
hold off

% RIB 5
subplot(4,2,5)
spline_rib_func_flip(positions_rib5);
subplot(4,2,6)
plot3(xx_rib5_flipped,yy_rib5_flipped,zz_rib5_flipped, 'color','r')
hold on
plot3(xx_rib5_2,yy_rib5_2,zz_rib5_2, 'color','b')
hold on
scatter3(flippedX_p5,flippedY_p5,flippedZ_p5, 'MarkerEdgeColor','r')
hold on
scatter3(x_rib5_2,y_rib5_2,z_rib5_2, 'MarkerEdgeColor','b')
hold on
for i= 1:250
    x_con_5 = [flipped_rib5_interpolation(i,1), fixed_rib5_interpolation(i,1)];
    y_con_5 = [flipped_rib5_interpolation(i,2), fixed_rib5_interpolation(i,2)];
    z_con_5 = [flipped_rib5_interpolation(i,3), fixed_rib5_interpolation(i,3)]; 
    hold on
    plot3(x_con_5, y_con_5, z_con_5, 'color','y');
end
title('Flipped ribs comparison connection');
legend('Right', 'Left');
hold off

% RIB 7
if all(positions_rib7(:)~=0)
    subplot(4,2,7)
    spline_rib_func_flip(positions_rib7);
    subplot(4,2,8)
    plot3(xx_rib7_flipped,yy_rib7_flipped,zz_rib7_flipped, 'color','r')
    hold on
    plot3(xx_rib7_2,yy_rib7_2,zz_rib7_2, 'color','b')
    hold on
    scatter3(flippedX_p7,flippedY_p7,flippedZ_p7, 'MarkerEdgeColor','r')
    hold on
    scatter3(x_rib7_2,y_rib7_2,z_rib7_2, 'MarkerEdgeColor','b')
    hold on
    for i= 1:250
        x_con_7 = [flipped_rib7_interpolation(i,1), fixed_rib7_interpolation(i,1)];
        y_con_7 = [flipped_rib7_interpolation(i,2), fixed_rib7_interpolation(i,2)];
        z_con_7 = [flipped_rib7_interpolation(i,3), fixed_rib7_interpolation(i,3)]; 
        hold on
        plot3(x_con_7, y_con_7, z_con_7, 'color','y');
    end
    title('Flipped ribs comparison connection');
    legend('Right', 'Left');
    hold off
end
