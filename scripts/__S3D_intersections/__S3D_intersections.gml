function __S3D_intersections() {}

function sd_point_in_tri(_point, _tri)
{
    var _uwv = sd_barycentric_triangle(_point, _tri);
    var _u = _uwv[0];
    var _w = _uwv[1];
    var _v = _uwv[2];
    return sd_collision_return((_v >= 0) && (_w >= 0) && ((_v + _w) <= 1.0), _tri);
}

function sd_seg_in_plane(_seg, _plane)
{
    var _ab = vec3_subtract(_seg[0], _seg[1]);
    var _pn = sd_plane_get_normal(_plane);
    var _pd = sd_plane_get_distance(_plane);
    var _t = (_pd - vec3_dot(_pn, _seg[0])) / vec3_dot(_pn, _ab);
    if(_t >= 0 and _t <= 1)
    {
        var _q = vec3_add(_seg[0], vec3_scale(_ab, _t));
        return sd_collision_return(true, _plane, _q);
    }
    else
    {
        return sd_collision_return(false);
    }
}

function sd_seg_in_tri(_seg, _tri)
{
    // first: check if the ray collides with the plane of the triangle and return the point.
    // second: if it doesn't, no collision.
    // third: if it does, check if the point found is in the triangle.
    // if it is, yes collision found! if not, nope
    var _plane_coll = sd_seg_in_plane(_seg, sd_plane_from_tri(_tri));
    if(_plane_coll[0] == false)
    {
        return sd_collision_return(false);
    }
    else
    {
        var _pit = sd_point_in_tri_3d(_plane_coll[1], _tri);
        if(_pit == true)
        {
            return sd_collision_return(true, _tri, _plane_coll[1]);
        }
        else
        {
            return sd_collision_return(false);
        }
    }
}

function sd_sphere_in_aabb(_sphere, _aabb)
{
    var _sq_dist = sd_aabb_sq_dist_point(sd_sphere_get_center(_sphere), _aabb);
    return sd_collision_return((_sq_dist <= sd_sphere_get_radius(_sphere) * sd_sphere_get_radius(_sphere)));
}

function sd_sphere_in_tri(_sphere, _tri)
{
    var _sc = sd_sphere_get_center(_sphere);
    var _sr = sd_sphere_get_radius(_sphere);
    var _p = sd_closest_point_tri(_sc, _tri);
    // Sphere and triangle intersect if the (squared) distance from sphere
    // center to point p is less than the (squared) sphere radius
    var _v = vec3_subtract(_p, _sc);
    if(vec3_dot(_v, _v) <= _sr * _sr)
    {
        var _pen_depth = vec3_distance(_p, _sc) - _sr;
        return sd_collision_return(true, _tri, _p, _pen_depth);
    }
    else
    {
        return sd_collision_return(false);
    }
}

function sd_sphere_in_sphere(_sphere0, _sphere1)
{
    var _sc0 = sd_sphere_get_center(_sphere0);
    var _sc1 = sd_sphere_get_center(_sphere1);
    var _sr0 = sd_sphere_get_radius(_sphere0);
    var _sr1 = sd_sphere_get_radius(_sphere1);
    var _distance = vec3_distance(_sc0, _sc1);
    if(_distance < _sr0 + _sr1)
    {
        // collision did not happen
        return sd_collision_return(false);
    }
    else
    {
        // collision is happening
        var _penetration_depth = abs(_sr0 + _sr1 - _distance);
        var _penetration_normal = vec3_normal(_sc1, _sc0);
        return sd_collision_return(true, _sphere1, undefined, _penetration_depth, _penetration_normal);
    }
}

function sd_aabb_in_aabb(_aabb1, _aabb2)
{
    var _aabb1_center = sd_aabb_get_center(_aabb1);
    var _aabb1_radius = sd_aabb_get_radius(_aabb1);
    var _aabb2_center = sd_aabb_get_center(_aabb2);
    var _aabb2_radius = sd_aabb_get_radius(_aabb2);
    if (abs(_aabb1_center[0] - _aabb2_center[0]) > (_aabb1_radius[0] + _aabb2_radius[0]))
    {
        return sd_collision_return(false);
    }
    if (abs(_aabb1_center[1] - _aabb2_center[1]) > (_aabb1_radius[1] + _aabb2_radius[1]))
    {
        return sd_collision_return(false);
    }
    if (abs(_aabb1_center[2] - _aabb2_center[2]) > (_aabb1_radius[2] + _aabb2_radius[2]))
    {
        return sd_collision_return(false);
    }
    return sd_collision_return(true, _aabb2);
}

function sd_capsule_in_tri(_capsule, _tri)
{
    var _tip = sd_capsule_get_tip(_capsule);
    var _base = sd_capsule_get_base(_capsule);
    var _radius = sd_capsule_get_radius(_capsule);
    
    var _p0 = sd_tri_get_point(_tri, 0);
    var _p1 = sd_tri_get_point(_tri, 1);
    var _p2 = sd_tri_get_point(_tri, 2);
    var _tn = sd_tri_get_normal(_tri);
    
    var _cn = sd_capsule_get_normal(_capsule);
    var _a = sd_capsule_get_point_a(_capsule);
    var _b = sd_capsule_get_point_b(_capsule);
    
    var _t = vec3_dot(_tn, vec3_scale(vec3_subtract(_p0, _base), 1 / abs(vec3_dot(_tn, _cn))));
    // t = dot(N, (p0 - base) / abs(dot(N, CapsuleNormal)));
    var _line_plane_intersection = vec3_add(_base, vec3_scale(_cn, _t));
    
    var _plane = sd_plane_from_tri(_tri);
    var _reference_point = sd_closest_point_tri(_line_plane_intersection, _tri);
     
    // The center of the best sphere candidate:
    var center = sd_closest_point_line(_a, _b, _reference_point);
    
    // Determine whether line_plane_intersection is inside all triangle edges: 
    var _c0 = vec3_cross(vec3_subtract(_line_plane_intersection, _p0), vec3_subtract(_p1, _p0)); 
    var _c1 = vec3_cross(vec3_subtract(_line_plane_intersection, _p1), vec3_subtract(_p2, _p1)); 
    var _c2 = vec3_cross(vec3_subtract(_line_plane_intersection, _p2), vec3_subtract(_p0, _p2));
    var _inside = vec3_dot(_c0, _tn) <= 0 && vec3_dot(_c1, _tn) <= 0 && vec3_dot(_c2, _tn) <= 0;
    
    if(_inside)
    {
        _reference_point = _line_plane_intersection;
    }
    else
    {
        // Edge 1:
        var _point1 = sd_closest_point_line(_p0, _p1, _line_plane_intersection);
        var _v1 = vec3_subtract(_line_plane_intersection, _point1);
        var _distsq = vec3_dot(_v1, _v1);
        var _best_dist = _distsq;
        _reference_point = _point1;
        
        // Edge 2:
        var _point2 = sd_closest_point_line(_p1, _p2, _line_plane_intersection);
        var _v2 = vec3_subtract(_line_plane_intersection, _point2);
        _distsq = vec3_dot(_v2, _v2);
        if(_distsq < _best_dist)
        {
          _reference_point = _point2;
          _best_dist = _distsq;
        }
        
        // Edge 3:
        var _point3 = sd_closest_point_line(_p2, _p0, _line_plane_intersection);
        var _v3 = vec3_subtract(_line_plane_intersection, _point3);
        _distsq = vec3_dot(_v3, _v3);
        if(_distsq < _best_dist)
        {
          _reference_point = _point3;
          _best_dist = _distsq;
        }
    }
    var _closest_point_line = sd_closest_point_line(_a, _b, _reference_point);
    return sd_sphere_in_tri(sd_sphere(_closest_point_line, _radius), _tri);
}