function __sd_aabb() {}

function sd_aabb(_center_point, _radius_vec3)
{
    return [_center_point, _radius_vec3];
}

function sd_aabb_from_minmax(_min, _max)
{
    var _center = [value_from_percent_in_range(0.5, _min[0], _max[0]), value_from_percent_in_range(0.5, _min[1], _max[1]), value_from_percent_in_range(0.5, _min[2], _max[2])];
    var _radius = [_max[0] - _center[0], _max[1] - _center[1], _max[2] - _center[2]];
    return sd_aabb(_center, _radius);
}

function sd_aabb_get_center(_aabb)
{
    return _aabb[0];
}

function sd_aabb_get_radius(_aabb)
{
    return _aabb[1];
}

function sd_aabb_get_min(_aabb)
{
    var _c = sd_aabb_get_center(_aabb);
    var _r = sd_aabb_get_radius(_aabb);
    return [_c[0] - _r[0], _c[1] - _r[1], _c[2] - _r[2]]; 
}

function sd_aabb_get_max(_aabb)
{
    var _c = sd_aabb_get_center(_aabb);
    var _r = sd_aabb_get_radius(_aabb);
    return [_c[0] + _r[0], _c[1] + _r[1], _c[2] + _r[2]]; 
}

function sd_aabb_closest_point_point(_point, _aabb)
{
    var _q = sd_point(undefined, undefined, undefined);
    var _aabb_min = sd_aabb_get_min(_aabb);
    var _aabb_max = sd_aabb_get_max(_aabb);
    for(var i = 0; i < 3; i++)
    {
        var _v = _point[i];
        if(_v < _aabb_min[i])
        {
            _v = _aabb_min[i];
        }
        if(_v > _aabb_max[i])
        {
            _v = _aabb_max[i];
        }
        _q[i] = _v;
    }
    return _q;
}

function sd_aabb_sq_dist_point(_point, _aabb)
{
    var _sq_dist = 0;
    var _aabb_min = sd_aabb_get_min(_aabb);
    var _aabb_max = sd_aabb_get_max(_aabb);
    
    for(var i = 0; i < 3; i++)
    {
        var _v = _point[i];
        if(_v < _aabb_min[i])
        {
            _sq_dist += (_aabb_min[i] - _v) * (_aabb_min[i] - _v);
        }
        if(_v > _aabb_max[i])
        {
            _sq_dist += (_v - _aabb_max[i]) * (_v - _aabb_max[i]);
        }
    }
    return _sq_dist;
}