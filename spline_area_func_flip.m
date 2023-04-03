function  spline_area_func_flip(p_rib_spline_fixed, p_rib_spline_moving)

    % This function flips the area of the convex side to the region
    % of the concave. In this case, it can be used for the whole 
    % enclosed area or also the convex and concave areas of the desired rib.
    
    % It is based on Delaunay triangulation, and then the trisurfaced is
    % visualized
    
    % p_rib_spline_moving : [x, y, z] of the interpolated points of a the
    % convex rib
    % p_rib_spline_fixed : [x, y, z] of the interpolated points of a the
    % concave rib

    x_rib_t_m = p_rib_spline_moving(:,1)';  % x-coordinates of the moving rib
    y_rib_t_m = p_rib_spline_moving(:,2)';  % y-coordinates of the moving rib
    z_rib_t_m = p_rib_spline_moving(:,3)';  % z-coordinates of the moving rib

    flippedX = - x_rib_t_m;
    flippedX = flippedX - (min(flippedX(:)) - max(x_rib_t_m(:)));
    flippedY = y_rib_t_m;
    flippedZ = z_rib_t_m;

    % compute the n-convex hull of the interpolated points
    k = convhulln(p_rib_spline_moving);
    % trisurface of the flipped coordinates and fill the enclosed area with
    % color
    trisurf(k, flippedX , flippedY ,flippedZ , 'FaceColor', 'red', 'FaceAlpha', 0.5);
    hold on
    
    k = convhulln(p_rib_spline_fixed);
    trisurf(k, p_rib_spline_fixed(:,1), p_rib_spline_fixed(:,2), p_rib_spline_fixed(:,3), 'FaceColor', 'green', 'FaceAlpha', 0.5);
    title('Flipped surfaces comparison');
    legend('Right', 'Left');
    hold off

end