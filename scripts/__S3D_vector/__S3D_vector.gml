function sd_vec3_add(_vec3_1, _vec3_2)
{
    var _x = _vec3_1[0] + _vec3_2[0];
    var _y = _vec3_1[1] + _vec3_2[1];
    var _z = _vec3_1[2] + _vec3_2[2];
    
    return [_x, _y, _z];
}

function sd_vec3_subtract(_vec3_1, _vec3_2)
{
    var _x = _vec3_1[0] - _vec3_2[0];
    var _y = _vec3_1[1] - _vec3_2[1];
    var _z = _vec3_1[2] - _vec3_2[2];
    
    return [_x, _y, _z];
}

function sd_vec3_dot(_vec3_1, _vec3_2)
{
    return _vec3_1[0] * _vec3_2[0] + _vec3_1[1] * _vec3_2[1] + _vec3_1[2] * _vec3_2[2];
}

function sd_vec3_cross(_vec3_1, _vec3_2)
{
    var _x = _vec3_1[1] * _vec3_2[2] - _vec3_1[2] * _vec3_2[1];
    var _y = _vec3_1[2] * _vec3_2[0] - _vec3_1[0] * _vec3_2[2];
    var _z = _vec3_1[0] * _vec3_2[1] - _vec3_1[1] * _vec3_2[0];
    
    return [_x, _y, _z];
}

function sd_vec3_scale(_vec3, _scale)
{
    var _x = _vec3[0] * _scale;
    var _y = _vec3[1] * _scale;
    var _z = _vec3[2] * _scale;
    
    return [_x, _y, _z];
}

function sd_vec3_normal(_vec3_1, _vec3_2)
{
    var _ab = vec3_subtract(_vec3_2, _vec3_1);
    return vec3_normalize(_ab);
}

function sd_vec3_normalize(_vec3)
{
    var _magnitude = sqrt(_vec3[0]*_vec3[0] + _vec3[1]*_vec3[1] + _vec3[2]*_vec3[2]);
    return [_vec3[0] / _magnitude, _vec3[1] / _magnitude, _vec3[2] / _magnitude];
}

function sd_vec3_distance(_vec3_1, _vec3_2)
{
    return point_distance_3d(_vec3_1[0], _vec3_1[1], _vec3_1[2], _vec3_2[0], _vec3_2[1], _vec3_2[2]);
}