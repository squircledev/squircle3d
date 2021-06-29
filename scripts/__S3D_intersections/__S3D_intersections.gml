function __S3D_intersections() {}

function sd_point_in_tri(_point, _tri)
{
    var _uwv = sd_barycentric_triangle(_point, _tri);
    var _u = _uwv[0];
    var _w = _uwv[1];
    var _v = _uwv[2];
    return sd_collision_return((_v >= 0) && (_w >= 0) && ((_v + _w) <= 1.0), _tri);
}

function sd_seg_in_plane(_r0, _r1, _plane)
{
    var _ab = vec3_subtract(_r0, _r1);
    var _pn = sd_plane_get_normal(_plane);
    var _pd = sd_plane_get_distance(_plane);
    var _t = (_pd - vec3_dot(_pn, _r0)) / vec3_dot(_pn, _ab);
    if(_t >= 0 and _t <= 1)
    {
        var _q = vec3_add(_r0, vec3_scale(_ab, _t));
        return sd_collision_return(true, _plane, _q);
    }
    else
    {
        return sd_collision_return(false);
    }
}

function sd_seg_in_tri(_r0, _r1, _tri)
{
    // first: check if the ray collides with the plane of the triangle and return the point.
    // second: if it doesn't, no collision.
    // third: if it does, check if the point found is in the triangle.
    // if it is, yes collision found! if not, nope
    var _plane_coll = sd_seg_in_plane(_r0, _r1, sd_plane_from_tri(_tri));
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