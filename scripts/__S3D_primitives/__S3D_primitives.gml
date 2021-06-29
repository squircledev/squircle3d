#region points

function sd_point(_x, _y, _z)
{
    return [_x, _y, _z];
}

#endregion

#region lines / rays / segments

// A line extends infinitely from p0 and p1
// A ray  extends infinitely from p1
// A segment does not

function sd_line(_p0, _p1)
{
    return [_p0, _p1];
}

function sd_ray(_p0, _p1)
{
    return [_p0, _p1];
}

function sd_segment(_p0, _p1)
{
    return [_p0, _p1];
}

#endregion

#region planes

enum SD_PLANE
{
    NORMAL,
    DISTANCE
}

function sd_plane(_normal, _point_on_plane) constructor
{
    return [_normal, vec3_dot(_normal, _point_on_plane)];
}

function sd_plane_from_tri(_tri)
{
    var _normal = sd_tri_get_normal(_tri);
    return new sd_plane(_normal, sd_tri_get_point(_tri, 0));
}

function sd_plane_get_normal(_plane)
{
    return _plane[SD_PLANE.NORMAL];
}

function sd_plane_get_distance(_plane)
{
    return _plane[SD_PLANE.DISTANCE];
}

#endregion

#region triangles

enum SD_TRI
{
    POINT0,
    POINT1,
    POINT2,
    NORMAL,
    AABB
}

function sd_tri(_p0, _p1, _p2, _normal)
{
    var _tri = [_p0, _p1, _p2, _normal, undefined];
    var _min = sd_tri_get_min(_tri);
    var _max = sd_tri_get_max(_tri);
    _tri[4] = sd_aabb_from_minmax(_min, _max);
    return _tri;
}

function sd_tri_get_point(_tri, _index)
{
    return _tri[_index];
}

function sd_tri_get_normal(_tri)
{
    return _tri[SD_TRI.NORMAL];
}

function sd_tri_get_aabb(_tri)
{
    return _tri[SD_TRI.AABB];
}

function sd_tri_get_min(_tri)
{
    var _a = sd_tri_get_point(_tri, 0);
    var _b = sd_tri_get_point(_tri, 1);
    var _c = sd_tri_get_point(_tri, 2);
    return [min(_a[0], _b[0], _c[0]), min(_a[1], _b[1], _c[1]), min(_a[2], _b[2], _c[2])];
}

function sd_tri_get_max(_tri)
{
    var _a = sd_tri_get_point(_tri, 0);
    var _b = sd_tri_get_point(_tri, 1);
    var _c = sd_tri_get_point(_tri, 2);
    return [max(_a[0], _b[0], _c[0]), max(_a[1], _b[1], _c[1]), max(_a[2], _b[2], _c[2])];
}

#endregion

#region spheres

enum SD_SPHERE
{
    CENTER,
    RADIUS,
    AABB
}

function sd_sphere(_center, _radius)
{
    var _aabb = sd_aabb(_center, [_radius, _radius, _radius]);
    return [_center, _radius, _aabb];
}

function sd_sphere_get_center(_sphere)
{
    return _sphere[SD_SPHERE.CENTER];
}

function sd_sphere_get_radius(_sphere)
{
    return _sphere[SD_SPHERE.RADIUS];
}

function sd_sphere_get_aabb(_sphere)
{
    return _sphere[SD_SPHERE.AABB];
}

#endregion

#region capsules

function sd_capsule(_point_a, _point_b, _radius)
{
    return [_point_a, _point_b, _radius];
}

function sd_capsule_get_point(_capsule, _index)
{
    return _capsule[_index];   
}

#endregion