function string_split(_string, _delimiter)
{
    /// explode(delimiter,string)
    //
    //  Returns an array of strings parsed from a given 
    //  string of elements separated by a delimiter.
    //
    //      delimiter   delimiter character, string
    //      string      group of elements, string
    //
    /// GMLscripts.com/license
    var arr;
    var del = _delimiter;
    var str = _string + del;
    var len = string_length(del);
    var ind = 0;
    repeat (string_count(del, str)) {
        var pos = string_pos(del, str) - 1;
        arr[ind] = string_copy(str, 1, pos);
        str = string_delete(str, 1, pos + len);
        ind++;
    }
    return arr;
}

function sd_trace()
{
    var _r/*:string*/ = "";
    for(var i = 0; i < argument_count; i++)
    {
        _r += string(argument[i]);
    }
    show_debug_message(_r);
}

function sd_wrap(_val, _min, _max)
{
    if (_val mod 1 == 0)
    {
        while (_val > _max || _val < _min)
        {
            if (_val > _max)
                _val += _min - _max - 1;
            else if (_val < _min)
                _val += _max - _min + 1;
        }
        return(_val);
    }
    else
    {
        var vOld = _val + 1;
        while (_val != vOld)
        {
            vOld = _val;
            if (_val < _min)
                _val = _max - (_min - _val);
            else if (_val > _max)
                _val = _min + (_val - _max);
        }
        return(_val);
    }
}

function sd_percent_in_range(_value/*:number*/, _min/*:number*/, _max/*:number*/)
{
    return (_value - _min) / (_max - _min);
}

function sd_value_from_percent_in_range(_percent/*:number*/, _min/*:number*/, _max/*:number*/)
{
    return _min + _percent * (_max - _min);
}

function vec3_add(_vec3_1, _vec3_2)
{
    var _x = _vec3_1[0] + _vec3_2[0];
    var _y = _vec3_1[1] + _vec3_2[1];
    var _z = _vec3_1[2] + _vec3_2[2];
    
    return [_x, _y, _z];
}

function vec3_subtract(_vec3_1, _vec3_2)
{
    var _x = _vec3_1[0] - _vec3_2[0];
    var _y = _vec3_1[1] - _vec3_2[1];
    var _z = _vec3_1[2] - _vec3_2[2];
    
    return [_x, _y, _z];
}

function vec3_dot(_vec3_1, _vec3_2)
{
    return _vec3_1[0] * _vec3_2[0] + _vec3_1[1] * _vec3_2[1] + _vec3_1[2] * _vec3_2[2];
}

function vec3_cross(_vec3_1, _vec3_2)
{
    var _x = _vec3_1[1] * _vec3_2[2] - _vec3_1[2] * _vec3_2[1];
    var _y = _vec3_1[2] * _vec3_2[0] - _vec3_1[0] * _vec3_2[2];
    var _z = _vec3_1[0] * _vec3_2[1] - _vec3_1[1] * _vec3_2[0];
    
    return [_x, _y, _z];
}

function vec3_scale(_vec3, _scale)
{
    var _x = _vec3[0] * _scale;
    var _y = _vec3[1] * _scale;
    var _z = _vec3[2] * _scale;
    
    return [_x, _y, _z];
}

function vec3_normal(_vec3_1, _vec3_2)
{
    var _ab = vec3_subtract(_vec3_2, _vec3_1);
    return vec3_normalize(_ab);
}

function vec3_normalize(_vec3)
{
    var _magnitude = sqrt(_vec3[0]*_vec3[0] + _vec3[1]*_vec3[1] + _vec3[2]*_vec3[2]);
    return [_vec3[0] / _magnitude, _vec3[1] / _magnitude, _vec3[2] / _magnitude];
}

function vec3_distance(_vec3_1, _vec3_2)
{
    return point_distance_3d(_vec3_1[0], _vec3_1[1], _vec3_1[2], _vec3_2[0], _vec3_2[1], _vec3_2[2]);
}