function spline_rib_func_flip(rib)
    
    % This function flips the convex rib to the region of the concave. It
    % is flipped on the x-axis. 
        
    % rib : [x, y, z] coordinates of the desired rib landmarks
    
    % rib side1 moving
    x_rib_1 = [rib(2,1);rib(1,1);rib(6,1);rib(4,1)];
    y_rib_1 = [rib(2,2);rib(1,2);rib(6,2);rib(4,2)];
    z_rib_1 = [rib(2,3);rib(1,3);rib(6,3);rib(4,3)];
    t = [1,2,3,4]; % Assumed time stamp

    % flip 180 decrees to the right
    flippedX_p = - x_rib_1;
    flippedX_p = flippedX_p - (min(flippedX_p(:)) - max(x_rib_1(:)));
    flippedY_p = y_rib_1;
    flippedZ_p = z_rib_1;

    flippedX_p(1,1)= rib(2,1);
    flippedX_p(4,1)= rib(4,1);

    % Apply interpolation for each x,y and z 
    tt = linspace(t(1),t(end));
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
    %figure
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

end