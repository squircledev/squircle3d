#region vectors

function sd_vec2(_x = 0, _y = 0)
{
    return [_x, _y];
}

function sd_vec3(_x = 0, _y = 0, _z = 0)
{
    return [_x, _y, _z];
}

#endregion

#region collision

enum SD_COLL
{
    CollisionHappened,
    ShapeCollidedWith,
    IntersectionPoint,
    PenetrationDepth,
    PenetrationNormal
}

function sd_collision_return(_collision_happen, _shape_collided_with = undefined, _intersection_point = undefined, _pen_depth = undefined, _pen_normal = undefined)
{
    return [_collision_happen, _shape_collided_with, _intersection_point, _pen_depth, _pen_normal];
}

function sd_barycentric_triangle(_point, _tri)
{
    var _va = sd_tri_get_point(_tri, 0);
    var _vb = sd_tri_get_point(_tri, 1);
    var _vc = sd_tri_get_point(_tri, 2);
    var _vec0 = sd_vec3_subtract(_vb, _va);
    var _vec1 = sd_vec3_subtract(_vc, _va);
    var _vec2 = sd_vec3_subtract(_point, _va);
    var _d00 = sd_vec3_dot(_vec0, _vec0);
    var _d01 = sd_vec3_dot(_vec0, _vec1);
    var _d11 = sd_vec3_dot(_vec1, _vec1);
    var _d20 = sd_vec3_dot(_vec2, _vec0);
    var _d21 = sd_vec3_dot(_vec2, _vec1);
    var _denom = _d00 * _d11 - _d01 * _d01;
    var _v = (_d11 * _d20 - _d01 * _d21) / _denom;
    var _w = (_d00 * _d21 - _d01 * _d20) / _denom;
    var _u = 1.0 - _v - _w;
    return [_u, _w, _v];
}

function sd_point_in_tri_3d(_point, _tri)
{
    var _uwv = sd_barycentric_triangle(_point, _tri);
    var _u = _uwv[0];
    var _w = _uwv[1];
    var _v = _uwv[2];
    return (_v >= 0) && (_w >= 0) && ((_v + _w) <= 1.0);
}

function sd_closest_point_line(_l0, _l1, _p)
{
    // float3 ClosestPointOnLineSegment(float3 A, float3 B, float3 Point)
    var _ab = sd_vec3_subtract(_l1, _l0);
    var _t = sd_vec3_dot(sd_vec3_subtract(_p, _l0), _ab) / sd_vec3_dot(_ab, _ab);
    return sd_vec3_add(_l0, sd_vec3_scale(_ab, min(max(_t, 0), 1))); // saturate(t) can be written as: min((max(t, 0), 1)
}

function sd_closest_point_tri(_point, _tri)
{
    /*
    Point ClosestPtPointTriangle(Point p, Point a, Point b, Point c)
    */
    var _a = sd_tri_get_point(_tri, 0);
    var _b = sd_tri_get_point(_tri, 1);
    var _c = sd_tri_get_point(_tri, 2);
    
    // Check if P in vertex region outside A
    var _ab = sd_vec3_subtract(_b, _a);
    var _ac = sd_vec3_subtract(_c, _a);
    var _ap = sd_vec3_subtract(_point, _a);
    var _d1 = sd_vec3_dot(_ab, _ap);
    var _d2 = sd_vec3_dot(_ac, _ap);
    if (_d1 <= 0 && _d2 <= 0)
    {
        return _a; // barycentric coordinates (1,0,0)
    }
    
    // Check if P in vertex region outside B
    var _bp = sd_vec3_subtract(_point, _b);
    var _d3 = sd_vec3_dot(_ab, _bp);
    var _d4 = sd_vec3_dot(_ac, _bp);
    if (_d3 >= 0 && _d4 <= _d3)
    {
        return _b; // barycentric coordinates (0,1,0)
    }
    
    // Check if P in edge region of AB, if so return projection of P onto AB
    var _vc = _d1 * _d4 - _d3 * _d2;
    if (_vc <= 0 && _d1 >= 0 && _d3 <= 0)
    {
        var _v = _d1 / (_d1 - _d3);
        return sd_vec3_add(_a, sd_vec3_scale(_ab, _v)); // barycentric coordinates (1-v,v,0)
    }
    
    // Check if P in vertex region outside C
    var _cp = sd_vec3_subtract(_point, _c);
    var _d5 = sd_vec3_dot(_ab, _cp);
    var _d6 = sd_vec3_dot(_ac, _cp);
    if (_d6 >= 0 && _d5 <= _d6)
    {
        return _c; // barycentric coordinates (0,0,1)
    }
    
    // Check if P in edge region of AC, if so return projection of P onto AC
    var _vb = _d5 * _d2 - _d1 * _d6;
    if (_vb <= 0 && _d2 >= 0 && _d6 <= 0)
    {
        var _w = _d2 / (_d2 - _d6);
        return sd_vec3_add(_a, sd_vec3_scale(_ac, _w)); // barycentric coordinates (1-w,0,w)
    }
    
    // Check if P in edge region of BC, if so return projection of P onto BC
    var _va = _d3 * _d6 - _d5 * _d4;
    if (_va <= 0 && (_d4 - _d3) >= 0 && (_d5 - _d6) >= 0) 
    {
        var _w = (_d4 - _d3) / ((_d4 - _d3) + (_d5 - _d6));
        return sd_vec3_add(_b, sd_vec3_scale(sd_vec3_subtract(_c, _b), _w)); // barycentric coordinates (0,1-w,w)
    }
    
    // P inside face region. Compute Q through its barycentric coordinates (u,v,w)
    var _denom = 1 / (_va + _vb + _vc);
    var _v = _vb * _denom;
    var _w = _vc * _denom;
    return sd_vec3_add(sd_vec3_add(_a, sd_vec3_scale(_ab, _v)), sd_vec3_scale(_ac, _w)); // = u*a + v*b + w*c, u = va * denom = 1.0f-v-w
}

function sd_sphere_coll_tri(_sphere, _tri)
{
    var _sc = sd_sphere_get_center(_sphere);
    var _sr = sd_sphere_get_radius(_sphere);
    var _p = sd_closest_point_tri(_sc, _tri);
    // Sphere and triangle intersect if the (squared) distance from sphere
    // center to point p is less than the (squared) sphere radius
    var _v = sd_vec3_subtract(_p, _sc);
    if(sd_vec3_dot(_v, _v) <= _sr * _sr)
    {
        var _pen_depth = sd_vec3_distance(_p, _sc) - _sr;
        return sd_collision_return(true, _tri, _p, _pen_depth);
    }
    else
    {
        return sd_collision_return(false);
    }
}

function sd_sphere_coll_tri_alt(_sc, _sr, _tri)
{
    /*
    float3 p0, p1, p2; // triangle corners
    float3 center; // sphere center
    float3 N = normalize(cross(p1 – p0, p2 – p0)); // plane normal
    float dist = dot(center – p0, N); // signed distance between sphere and plane
    if(!mesh.is_double_sided() && dist > 0)
      continue; // can pass through back side of triangle (optional)
    if(dist < -radius || dist > radius)
      continue; // no intersection
      
    float3 point0 = center – N * dist; // projected sphere center on triangle plane
 
    // Now determine whether point0 is inside all triangle edges: 
    float3 c0 = cross(point0 – p0, p1 – p0) 
    float3 c1 = cross(point0 – p1, p2 – p1) 
    float3 c2 = cross(point0 – p2, p0 – p2)
    bool inside = dot(c0, N) <= 0 && dot(c1, N) <= 0 && dot(c2, N) <= 0;

    float3 ClosestPointOnLineSegment(float3 A, float3 B, float3 Point)
    {
      float3 AB = B – A;
      float t = dot(Point – A, AB) / dot(AB, AB);
      return A + saturate(t) * AB; // saturate(t) can be written as: min((max(t, 0), 1)
    }
     
    float radiussq = radius * radius; // sphere radius squared
     
    // Edge 1:
    float3 point1 = ClosestPointOnLineSegment(p0, p1, center);
    float3 v1 = center – point1;
    float distsq1 = dot(v1, v1);
    bool intersects = distsq1 < radiussq;
     
    // Edge 2:
    float3 point2 = ClosestPointOnLineSegment(p1, p2, center);
    float3 v2 = center – point2;
    float distsq2 = dot(vec2, vec2);
    intersects |= distsq2 < radiussq;
     
    // Edge 3:
    float3 point3 = ClosestPointOnLineSegment(p2, p0, center);
    float3 v3 = center – point3;
    float distsq3 = dot(v3, v3);
    intersects |= distsq3 < radiussq;
    
    
    if(inside || intersects)
    {
      float3 best_point = point0;
      float3 intersection_vec;
     
      if(inside)
      {
        intersection_vec = center – point0;
      }
      else  
      {
        float3 d = center – point1;
        float best_distsq = dot(d, d);
        best_point = point1;
        intersection_vec = d;
     
        d = center – point2;
        float distsq = dot(d, d);
        if(distsq < best_distsq)
        {
          distsq = best_distsq;
          best_point = point2;
          intersection_vec = d;
        }
     
        d = center – point3;
        float distsq = dot(d, d);
        if(distsq < best_distsq)
        {
          distsq = best_distsq;
          best_point = point3; 
          intersection_vec = d;
        }
      }
     
      float3 len = length(intersection_vec);  // vector3 length calculation: 
      sqrt(dot(v, v))
      float3 penetration_normal = penetration_vec / len;  // normalize
      float penetration_depth = radius – len; // radius = sphere radius
      return true; // intersection success
    }
    */
    
    var _p0 = sd_tri_get_point(_tri, 0);
    var _p1 = sd_tri_get_point(_tri, 1);
    var _p2 = sd_tri_get_point(_tri, 2);
    
    var _normal = sd_tri_get_normal(_tri);
    var _dist = sd_vec3_dot(sd_vec3_subtract(_sc, _p0), _normal);
    
    if(_dist > 0)
    {
        return sd_collision_return(false);
    }
    if(_dist < -_sr || _dist > _sr)
    {
        return sd_collision_return(false);
    }
    
    var _point0 = sd_vec3_subtract(_sc, sd_vec3_scale(_normal, _dist)); // projected sphere center on triangle plane

    // Now determine whether point0 is inside all triangle edges: 
    var _c0 = sd_vec3_cross(sd_vec3_subtract(_point0, _p0), sd_vec3_subtract(_p1, _p0));
    var _c1 = sd_vec3_cross(sd_vec3_subtract(_point0, _p1), sd_vec3_subtract(_p2, _p1));
    var _c2 = sd_vec3_cross(sd_vec3_subtract(_point0, _p2), sd_vec3_subtract(_p0, _p2));
    var _inside = sd_vec3_dot(_c0, _normal) <= 0 && sd_vec3_dot(_c1, _normal) <= 0 && sd_vec3_dot(_c2, _normal) <= 0;
    
    var _r2 = _sr*_sr;
    
    var _intersects = false;
     
    // Edge 1:
    var _point1 = sd_closest_point_line(_p0, _p1, _sc);
    var _v1 = sd_vec3_subtract(_sc, _point1);
    var _distsq1 = sd_vec3_dot(_v1, _v1);
    _intersects = _distsq1 < _r2;
     
    // Edge 2:
    var _point2 = sd_closest_point_line(_p1, _p2, _sc);
    var _v2 = sd_vec3_subtract(_sc, _point2);
    var _distsq2 = sd_vec3_dot(_v2, _v2);
    _intersects |= _distsq2 < _r2;
     
    // Edge 3:
    var _point3 = sd_closest_point_line(_p2, _p0, _sc);
    var _v3 = sd_vec3_subtract(_sc, _point3);
    var _distsq3 = sd_vec3_dot(_v3, _v3);
    _intersects |= _distsq3 < _r2;
    
    if(_inside || _intersects)
    {
        var _best_point = _point0;
        var _intersection_vec;
        
        if(_inside)
        {
            _intersection_vec = sd_vec3_subtract(_sc, _point0);
        }
        else
        {
            var _d = sd_vec3_subtract(_sc, _point1);
            var _best_distsq = sd_vec3_dot(_d, _d);
            _best_point = _point1;
            _intersection_vec = _d;
            
            _d = sd_vec3_subtract(_sc, _point2);
            var _distsq = sd_vec3_dot(_d, _d);
            if(_distsq < _best_distsq)
            {
                _distsq = _best_distsq;
                _best_point = _point2;
                _intersection_vec = _d;
            }
            
            _d = sd_vec3_subtract(_sc, _point3);
            _distsq = sd_vec3_dot(_d, _d);
            if(_distsq < _best_distsq)
            {
                _distsq = _best_distsq;
                _best_point = _point3; 
                _intersection_vec = _d;
            }
        }
        var _len = sd_vec3_dot(_intersection_vec, _intersection_vec);  // length of vector
        var _penetration_normal = sd_vec3_scale(_intersection_vec, 1 / _len);  // normalize
        var _penetration_depth = _sr - _len; // radius = sphere radius
        return sd_collision_return(true, _tri, undefined, _penetration_depth, _penetration_normal); // intersection success
    }
    else
    {
        return sd_collision_return(false);
    }
}

function sd_sphere_coll_sphere(_sc0, _sr0, _sc1, _sr1)
{
    var _distance = sd_vec3_distance(_sc0, _sc1);
    if(_distance < _sr0 + _sr1)
    {
        // collision did not happen
        return sd_collision_return(false);
    }
    else
    {
        // collision is happening
        var _penetration_depth = abs(_sr0 + _sr1 - _distance);
        var _penetration_normal = sd_vec3_normal(_sc1, _sc0);
        return sd_collision_return(true, [_sc1, _sr1], undefined, _penetration_depth, _penetration_normal);
    }
}

#endregion

function in_range(_value, _min, _max, _inclusive = true)
{
    if(_inclusive)
    {
        return (_value >= _min) && (_value <= _max);
    }
    return (_value > _min) && (_value < _max);
}

function scrMath() {}

function wrap_value(_val, _min, _max)
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

function approach(_val, _target, _amnt)
{
    var _result = _val;
    if (_result < _target)
    {
        _result += _amnt;
        if (_result > _target)
            return _target;
    }
    else
    {
        _result -= _amnt;
        if (_result < _target)
            return _target;
    }
    return _result;
}

function percent_in_range(_value/*:number*/, _min/*:number*/, _max/*:number*/)
{
    return (_value - _min) / (_max - _min);
}

function value_from_percent_in_range(_percent/*:number*/, _min/*:number*/, _max/*:number*/)
{
    return _min + _percent * (_max - _min);
}

function round_to_multiple(_val, _multiple)
{
    var _amnt = _val / _multiple;
    _amnt = round(_amnt);
    return _amnt * _multiple;
}

function floor_to_multiple(_val, _multiple)
{
    var _amnt = _val / _multiple;
    _amnt = floor(_amnt);
    return _amnt * _multiple;
}

function ceil_to_multiple(_val, _multiple)
{
    var _amnt = _val / _multiple;
    _amnt = ceil(_amnt);
    return _amnt * _multiple;
}

function even_round(_val)
{
    var _v = round(_val);
    if(_v % 2 == 0)
    {
        return _v;
    }
    else
    {
        return _v - 1;
    }
}