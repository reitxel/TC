function [xx_rib_flipped, yy_rib_flipped, zz_rib_flipped, flippedX_p, flippedY_p, flippedZ_p] =  spline_rib_func_flip_dist(rib)
    
    % This function flips the convex rib to the region of the concave. It
    % is flipped on the x-axis. Then computes the distances between 
    % landmarks 2,1,6,4 and landmarks 2,3,8,4 and creates a table
    % Then the distance between landmarks 1 and 3, and 6 and 8 specifically
    % are displayed
    % Next, the distance between all the points in the interpolation was 
    % calculated and the mean value of this distance is displayed
    % Lastly and approximation of the area for the distances between the
    % interpolated points of the ribs is also displayed
        
    % rib : [x, y, z] coordinates of the desired rib landmarks
    % xx_rib_flipped : x coordinates of the interpolated flipped rib
    % yy_rib_flipped : y coordinates of the interpolated flipped rib
    % zz_rib_flipped : z coordinates of the interpolated flipped rib
    % flippedX_p : x coordinates of the rib flipped landmark
    % flippedY_p : y coordinates of the rib flipped landmark
    % flippedZ_p : z coordinates of the rib flipped landmark

    % rib side 1 moving - to be flipped
    x_rib_1 = [rib(2,1);rib(1,1);rib(6,1);rib(4,1)];
    y_rib_1 = [rib(2,2);rib(1,2);rib(6,2);rib(4,2)];
    z_rib_1 = [rib(2,3);rib(1,3);rib(6,3);rib(4,3)];
    t = [1,2,3,4]; % time stamp

    % flip 180 degrees to the right from the x-axis
    flippedX_p = - x_rib_1;
    flippedX_p = flippedX_p - (min(flippedX_p(:)) - max(x_rib_1(:)));
    flippedY_p = y_rib_1;
    flippedZ_p = z_rib_1;
    flippedX_p(1,1)= rib(2,1);
    flippedX_p(4,1)= rib(4,1);

    % Apply interpolation for each x, y and z 
    tt = linspace(t(1),t(end), 250);
    xx_rib_flipped = interp1(t,flippedX_p,tt,'spline');
    yy_rib_flipped = interp1(t,flippedY_p,tt,'spline');
    zz_rib_flipped = interp1(t,flippedZ_p,tt,'spline');

    % rib side 2 fixed
    x_rib_2 = [rib(2,1);rib(3,1);rib(8,1);rib(4,1)];
    y_rib_2 = [rib(2,2);rib(3,2);rib(8,2);rib(4,2)];
    z_rib_2 = [rib(2,3);rib(3,3);rib(8,3);rib(4,3)];
    
    % % Apply interpolation for each x,y and z 
    xx_rib_2 = interp1(t,x_rib_2,tt,'spline');
    yy_rib_2 = interp1(t,y_rib_2,tt,'spline');
    zz_rib_2 = interp1(t,z_rib_2,tt,'spline');

    % Visualize the results
    plot3(xx_rib_flipped,yy_rib_flipped,zz_rib_flipped, 'color','r')
    hold on
    plot3(xx_rib_2,yy_rib_2,zz_rib_2, 'color','b')
    hold on
    scatter3(flippedX_p,flippedY_p,flippedZ_p, 'MarkerEdgeColor','r')
    hold on
    scatter3(x_rib_2,y_rib_2,z_rib_2, 'MarkerEdgeColor','b')
    title('Flipped ribs comparison');
    legend('Right', 'Left');
    hold off
    
    flipped_rib_landmaks=[flippedX_p, flippedY_p, flippedZ_p];
    fixed_rib_landmarks = [x_rib_2, y_rib_2, z_rib_2];
    flipped_rib_interpolation=[xx_rib_flipped; yy_rib_flipped; zz_rib_flipped];
    fixed_rib_interpolation = [xx_rib_2; yy_rib_2; zz_rib_2];
    
    % 3d distances between landmarks
    dist_general_landmarks = pdist2(flipped_rib_landmaks, fixed_rib_landmarks);

    titles_row = {'Landmark_2'; 'Landmark_1' ; 'Landmark_6'; 'Landmark_4'};
    titles_col = {'Landmark_2'; 'Landmark_3' ; 'Landmark_8'; 'Landmark_4'};

    table_landmarks = array2table(dist_general_landmarks, 'RowNames', titles_row, 'VariableNames', titles_col);
    disp(table_landmarks)

    fprintf('Distance between landmark 1 and 3: %f\n', dist_general_landmarks(2,2));
    fprintf('Distance between landmark 6 and 8: %f\n', dist_general_landmarks(3,3));

    % 3d distances between all the interpolated points
    dist_general_interpolation = pdist2(flipped_rib_interpolation', fixed_rib_interpolation');
   
    mean_val = mean(dist_general_interpolation(:));
    fprintf('Mean value of the distances between interpolated points: %f\n', mean_val);
    
    % add the diagonal values of the distance matrix
    total_area = sum(diag(dist_general_interpolation));
    fprintf('Area approximation of the distances between interpolated points: %f\n', total_area);
    
    disp(' ')
end