global.SD_IDENTITY_MATRIX = matrix_build_identity();

#region mat1

function sd_mat1(_fill = 0)
{
    return array_create(1, _fill);
}

#endregion

#region mat2

function sd_mat2(_fill = 0)
{
    return array_create(4, _fill);
}

function sd_mat2_get(_mat2, _x, _y)
{
    return _mat2[_x + _y * 2];
}

function sd_mat2_set(_mat2, _x, _y, _value)
{
    _mat2[_x + _y * 2] = _value;
}

function sd_mat2_det(_mat2)
{
    var _a = sd_mat2_get(_mat2, 0, 0);
    var _b = sd_mat2_get(_mat2, 1, 0);
    var _c = sd_mat2_get(_mat2, 0, 1);
    var _d = sd_mat2_get(_mat2, 1, 1);
    return _a * _d - _b * _c;
}

#endregion

#region mat3

function sd_mat3(_fill = 0)
{
    return array_create(9, _fill);
}

function sd_mat3_get(_mat3, _x, _y)
{
    return _mat3[_x + _y*3];
}

function sd_mat3_set(_mat3, _x, _y, _value)
{
    _mat3[_x + _y*3] = _value;
}

function sd_mat3_clip_mat2(_mat3, _x1, _x2, _y1, _y2)
{
    var _mat2 = sd_mat2();
    sd_mat2_set(_mat2, 0, 0, sd_mat3_get(_mat3, _x1, _y1));
    sd_mat2_set(_mat2, 1, 0, sd_mat3_get(_mat3, _x2, _y1));
    sd_mat2_set(_mat2, 0, 1, sd_mat3_get(_mat3, _x1, _y2));
    sd_mat2_set(_mat2, 1, 1, sd_mat3_get(_mat3, _x2, _y2));
    return _mat2;
}

function sd_mat3_det(_mat3)
{
    var _a = sd_mat3_get(_mat3, 0, 0);
    var _b = sd_mat3_get(_mat3, 1, 0);
    var _c = sd_mat3_get(_mat3, 2, 0);
    var _det1 = sd_mat2_det(sd_mat3_clip_mat2(_mat3, 1, 2, 1, 2));
    var _det2 = sd_mat2_det(sd_mat3_clip_mat2(_mat3, 0, 2, 1, 2));
    var _det3 = sd_mat2_det(sd_mat3_clip_mat2(_mat3, 0, 1, 1, 2));
    
    return _a * _det1 - _b * _det2 + _c * _det3;
}

#endregion

#region mat4

function sd_mat4(_fill = 0)
{
    return array_create(16, _fill);
}

function sd_mat4_get(_mat4, _x, _y)
{
    return _mat4[_x + _y*4];
}

function sd_mat4_set(_mat4, _x, _y, _value)
{
    _mat4[_x + _y*4] = _value;
}

function sd_mat4_clip_mat2(_mat4, _x1, _x2, _y1, _y2)
{
    var _mat2 = sd_mat2();
    sd_mat2_set(_mat2, 0, 0, sd_mat4_get(_mat4, _x1, _y1));
    sd_mat2_set(_mat2, 1, 0, sd_mat4_get(_mat4, _x2, _y1));
    sd_mat2_set(_mat2, 0, 1, sd_mat4_get(_mat4, _x1, _y2));
    sd_mat2_set(_mat2, 1, 1, sd_mat4_get(_mat4, _x2, _y2));
    return _mat2;
}

function sd_mat4_clip_mat3(_mat4, _x1, _x2, _x3, _y1, _y2, _y3)
{
    var _mat3 = sd_mat3();
    sd_mat3_set(_mat3, 0, 0, sd_mat4_get(_mat4, _x1, _y1));
    sd_mat3_set(_mat3, 1, 0, sd_mat4_get(_mat4, _x2, _y1));
    sd_mat3_set(_mat3, 2, 0, sd_mat4_get(_mat4, _x3, _y1));
    sd_mat3_set(_mat3, 0, 1, sd_mat4_get(_mat4, _x1, _y2));
    sd_mat3_set(_mat3, 1, 1, sd_mat4_get(_mat4, _x2, _y2));
    sd_mat3_set(_mat3, 2, 1, sd_mat4_get(_mat4, _x3, _y2));
    sd_mat3_set(_mat3, 0, 2, sd_mat4_get(_mat4, _x1, _y3));
    sd_mat3_set(_mat3, 1, 2, sd_mat4_get(_mat4, _x2, _y3));
    sd_mat3_set(_mat3, 2, 2, sd_mat4_get(_mat4, _x3, _y3));
    return _mat3;
}

function sd_mat4_det(_mat4)
{
    var _a = sd_mat4_get(_mat4, 0, 0);
    var _b = sd_mat4_get(_mat4, 1, 0);
    var _c = sd_mat4_get(_mat4, 2, 0);
    var _d = sd_mat4_get(_mat4, 3, 0);
    var _det1 = sd_mat3_det(sd_mat4_clip_mat3(_mat4, 1, 2, 3, 1, 2, 3));
    var _det2 = sd_mat3_det(sd_mat4_clip_mat3(_mat4, 0, 2, 3, 1, 2, 3));
    var _det3 = sd_mat3_det(sd_mat4_clip_mat3(_mat4, 0, 1, 3, 1, 2, 3));
    var _det4 = sd_mat3_det(sd_mat4_clip_mat3(_mat4, 0, 1, 2, 1, 2, 3));
    
    return _a * _det1 - _b * _det2 + _c * _det3 - _d * _det4;
}

function sd_mat4_identity()
{
    return global.SD_IDENTITY_MATRIX;
}

function sd_mat4_multiply(_mat4_1, _mat4_2)
{
    return matrix_multiply(_matrix_1, _matrix_2);
}

function sd_mat4_determinant(_mat4)
{
    
}

#endregion