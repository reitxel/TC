function area_rib = spline_area_func(p_rib_spline)
    
    % This function computes the area enclosed inside a set of interpolated
    % points. In this case, it can be used for the whole enclosed area or
    % also the convex and concave areas of the desired rib.
    
    % It is based on Delaunay triangulation, and then the area of each
    % triangle is sum to obtain the final approximated area of the rib cage
    
    % p_rib_spline : [x, y, z] of the interpolated points of a rib
    % area_rib : final area in cm^2 of the enclosed area
    
    x_rib_t = p_rib_spline(:,1)';  % x-coordinates of the rib
    y_rib_t = p_rib_spline(:,2)';  % y-coordinates of the rib
    z_rib_t = p_rib_spline(:,3)';  % z-coordinates of the rib

    % triangulation of the coordinates
    tri = delaunay(x_rib_t,y_rib_t); 
    
    % area calculation
    area_rib = 0;
    for i = 1:size(tri,1)
        v1 = [x_rib_t(tri(i,2))-x_rib_t(tri(i,1)), y_rib_t(tri(i,2))-y_rib_t(tri(i,1)), z_rib_t(tri(i,2))-z_rib_t(tri(i,1))];
        v2 = [x_rib_t(tri(i,3))-x_rib_t(tri(i,1)), y_rib_t(tri(i,3))-y_rib_t(tri(i,1)), z_rib_t(tri(i,3))-z_rib_t(tri(i,1))];
        % cross product between the two vectors
        n = cross(v1,v2); 
        % add area of the current triangle to the total
        area_rib = area_rib + norm(n)/2;  
    end

    % divide by 100 to obtain the are in cm^2
    area_rib = area_rib/100;

end