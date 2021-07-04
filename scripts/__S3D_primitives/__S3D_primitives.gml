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
    var _normal = vec3_normal(_p0, _p1);
    return [_p0, _p1, _normal];
}

function sd_ray(_p0, _p1)
{
    var _normal = vec3_normal(_p0, _p1);
    return [_p0, _p1, _normal];
}

function sd_segment(_p0, _p1)
{
    var _normal = vec3_normal(_p0, _p1);
    return [_p0, _p1, _normal];
}

#endregion

#region planes

enum SD_PLANE
{
    NORMAL,
    DISTANCE
}

function sd_plane(_normal, _point_on_plane)
{
    return [_normal, vec3_dot(_normal, _point_on_plane)];
}

function sd_plane_from_tri(_tri)
{
    var _normal = sd_tri_get_normal(_tri);
    return sd_plane(_normal, sd_tri_get_point(_tri, 0));
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
    _tri[SD_TRI.AABB] = sd_aabb_from_minmax(_min, _max);
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

enum SD_CAPSULE
{
    Tip,
    Base,
    PointA,
    PointB,
    Normal,
    Radius,
    AABB
}

function sd_capsule(_tip, _base, _radius)
{
    var _cn = vec3_normal(_base, _tip);
    var _line_end_offset = vec3_scale(_cn, _radius);
    var _a = vec3_add(_base, _line_end_offset); 
    var _b = vec3_subtract(_tip, _line_end_offset);
    var _min = [0, 0, 0];
    var _max = [0, 0, 0];
    _min[0] = min(_a[0] - _radius, _b[0] - _radius);
    _min[1] = min(_a[1] - _radius, _b[1] - _radius);
    _min[2] = min(_a[2] - _radius, _b[2] - _radius);
    _max[0] = max(_a[0] + _radius, _b[0] + _radius);
    _max[1] = max(_a[1] + _radius, _b[1] + _radius);
    _max[2] = max(_a[2] + _radius, _b[2] + _radius);
    var _aabb = sd_aabb_from_minmax(_min, _max);
    return [_tip, _base, _a, _b, _cn, _radius, _aabb];
}

function sd_capsule_get_tip(_capsule)
{
    return _capsule[SD_CAPSULE.Tip];
}

function sd_capsule_get_base(_capsule)
{
    return _capsule[SD_CAPSULE.Base];
}

function sd_capsule_get_point_a(_capsule)
{
    return _capsule[SD_CAPSULE.PointA];
}

function sd_capsule_get_point_b(_capsule)
{
    return _capsule[SD_CAPSULE.PointB];
}

function sd_capsule_get_normal(_capsule)
{
    return _capsule[SD_CAPSULE.Normal];
}

function sd_capsule_get_radius(_capsule)
{
    return _capsule[SD_CAPSULE.Radius];
}

function sd_capsule_get_aabb(_capsule)
{
    return _capsule[SD_CAPSULE.AABB];
}

#endregion