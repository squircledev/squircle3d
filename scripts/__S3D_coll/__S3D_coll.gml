function __S3D_coll() {}

function S3DCollMesh(_minimum, _maximum, _partition_amount) constructor
{
    partition_amount = _partition_amount;
    tris = array_create(partition_amount, 0);
    for(var i = 0; i < array_length(tris); i++)
    {
        tris[i] = array_create(partition_amount, 0);
        for(var j = 0; j < array_length(tris[i]); j++)
        {
            tris[i][j] = array_create(partition_amount, 0);
            for(var k = 0; k < array_length(tris[i][j]); k++)
            {
                tris[i][j][k] = [];
            }
        }
    }
    minimum = _minimum;
    maximum = _maximum;
    
    
    static TriAdd = function(_tri)
    {
        s3d_trace("Adding tri: ", _tri);
        var _min = sd_tri_get_min(_tri);
        var _max = sd_tri_get_max(_tri);
        
        var _x_low =  min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_min[0], minimum[0], maximum[0])));
        var _x_high = min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_max[0], minimum[0], maximum[0])));
        var _y_low =  min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_min[1], minimum[1], maximum[1])));
        var _y_high = min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_max[1], minimum[1], maximum[1])));
        var _z_low =  min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_min[2], minimum[2], maximum[2])));
        var _z_high = min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_max[2], minimum[2], maximum[2])));
        
        var _x_min = min(_x_low, _x_high);
        var _x_max = max(_x_low, _x_high);
        var _y_min = min(_y_low, _y_high);
        var _y_max = max(_y_low, _y_high);
        var _z_min = min(_z_low, _z_high);
        var _z_max = max(_z_low, _z_high);
        
        for(var i = _x_min; i <= _x_max; i++)
        {
            for(var j = _y_min; j <= _y_max; j++)
            {
                for(var k = _z_min; k <= _z_max; k++)
                {
                    array_push(tris[i][j][k], _tri);
                }
            }
        }
    }
    
    static CheckSegmentCollInsane = function(_r0, _r1)
    {
        if(_r0[0] == _r1[0] && _r0[1] == _r1[1] && _r0[2] == _r1[2])
        {
            return [false];
        }
        s3d_trace("Collision check start");
        s3d_trace(_r0);
        s3d_trace(_r1);
        var _x1 = min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_r0[0], minimum[0], maximum[0])));
        var _y1 = min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_r0[1], minimum[1], maximum[1])));
        var _z1 = min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_r0[2], minimum[2], maximum[2])));
        var _x2 = min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_r1[0], minimum[0], maximum[0])));
        var _y2 = min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_r1[1], minimum[1], maximum[1])));
        var _z2 = min(partition_amount - 1, floor(partition_amount * s3d_percent_in_range(_r1[2], minimum[2], maximum[2])));
        
        var _x_min = min(_x1, _x2);
        var _x_max = max(_x1, _x2);
        var _y_min = min(_y1, _y2);
        var _y_max = max(_y1, _y2);
        var _z_min = min(_z1, _z2);
        var _z_max = max(_z1, _z2);
        
        s3d_trace(_x_min);
        s3d_trace(_x_max);
        s3d_trace(_y_min);
        s3d_trace(_y_max);
        s3d_trace(_z_min);
        s3d_trace(_z_max);

        for(var i = 0; i < partition_amount; i++)
        for(var j = 0; j < partition_amount; j++)
        {
            for(var k = 0; k < partition_amount; k++)
            {
                if(in_range(i, _x_min, _x_max) and in_range(j, _y_min, _y_max) and in_range(k, _z_min, _z_max))
                {
                    s3d_trace("was in range");
                    s3d_trace(i, ", ", j, ", ", k);
                    for(var l = 0; l < array_length(tris[i][j][k]); l++)
                    {
                        var _tri = tris[i][j][k][l];
                        var _coll = sd_seg_in_tri(_r0, _r1, _tri);
                        if(_coll[0] == true)
                        {
                            s3d_trace("Collision found!!!");
                            return _coll;
                        }
                    }
                }
            }
        }
        return [false];
    }
    
    static CheckSphereColl = function(_sphere)
    {
        var _sc = sd_sphere_get_center(_sphere);
        var _sr = sd_sphere_get_radius(_sphere);
        s3d_trace("Collision check sphere -> collmesh start");
        var _x1 = floor(partition_amount * s3d_percent_in_range(_sc[0] - _sr, minimum[0], maximum[0]));
        var _y1 = floor(partition_amount * s3d_percent_in_range(_sc[1] - _sr, minimum[1], maximum[1]));
        var _z1 = floor(partition_amount * s3d_percent_in_range(_sc[2] - _sr, minimum[2], maximum[2]));
        var _x2 = floor(partition_amount * s3d_percent_in_range(_sc[0] + _sr, minimum[0], maximum[0]));
        var _y2 = floor(partition_amount * s3d_percent_in_range(_sc[1] + _sr, minimum[1], maximum[1]));
        var _z2 = floor(partition_amount * s3d_percent_in_range(_sc[2] + _sr, minimum[2], maximum[2]));
        
        var _x_min = min(_x1, _x2);
        var _x_max = max(_x1, _x2);
        var _y_min = min(_y1, _y2);
        var _y_max = max(_y1, _y2);
        var _z_min = min(_z1, _z2);
        var _z_max = max(_z1, _z2);
        
        if(_x_min > partition_amount - 1 or _x_max < 0 or _y_min > partition_amount - 1 or _y_max < 0 or _z_min > partition_amount - 1 or _z_max < 0)
        {
            s3d_trace("Bailing, out of the range");
            return sd_collision_return(false);
        }
        
        s3d_trace("Minimum: ", _x_min, ", ", _y_min, ", ", _z_min);
        s3d_trace("Maximum: ", _x_max, ", ", _y_max, ", ", _z_max);
        
        var _tri_count = 0;
        
        _x_min = clamp(_x_min, 0, partition_amount - 1);
        _x_max = clamp(_x_max, 0, partition_amount - 1);
        _y_min = clamp(_y_min, 0, partition_amount - 1);
        _y_max = clamp(_y_max, 0, partition_amount - 1);
        _z_min = clamp(_z_min, 0, partition_amount - 1);
        _z_max = clamp(_z_max, 0, partition_amount - 1);

        for(var i = _x_min; i <= _x_max; i++)
        {
            for(var j = _y_min; j <= _y_max; j++)
            {
                for(var k = _z_min; k <= _z_max; k++)
                {
                    var _tris = array_length(tris[i][j][k]);
                    _tri_count += _tris;
                    for(var l = 0; l < _tris; l++)
                    {
                        var _tri = tris[i][j][k][l];
                        var _coll = sd_sphere_in_aabb(_sphere, sd_tri_get_aabb(_tri));
                        if(_coll[0] == true)
                        {
                            _coll = sd_sphere_coll_tri(_sphere, _tri);
                            if(_coll[0] == true)
                            {
                                return _coll;
                            }
                        }
                    }
                }
            }
        }
        
        s3d_trace("Tri count: ", _tri_count);
        return sd_collision_return(false);
    }
}

function s3d_obj_to_collmesh(_filename, _partition_size)
{
    var _files = [];
    var _model_count = 0;
    var _position_array = [];
    var _normal_array = [];
    var _uv_array = [];
    var _face_array = [];
    var _frames = [];
    
    // filename sanity check
    var _filename_split = string_split(_filename, ".");
    if(_filename_split[array_length(_filename_split) - 1] == "obj")
    {
        // yes, this is an obj labeled file
        if(file_exists(_filename))
        {
            // yes, this exists as well
            _files = [_filename];
        }
    }
    else
    {
        show_error("Not an .obj", true);
    }
    
    if(array_length(_files) <= 0)
    {
        show_error("No files found", true);
    }
    
    s3d_trace("Number of files found: ", array_length(_files));
    
    for(var i = 0; i < array_length(_files); i++)
    {
        _position_array[i] = [];
        _normal_array[i] = [];
        _uv_array[i] = [];
        _face_array[i] = [];
        var _file = file_text_open_read(_files[i]);
        while(file_text_eof(_file) == false)
        {
            var _line = file_text_readln(_file);
            var _line_split = string_split(_line, " ");
            var _cmd = _line_split[0];
            
            switch(_cmd)
            {
                case("v"):
                {
                    array_push(_position_array[i], [real(_line_split[1]), real(_line_split[2]), real(_line_split[3])]);
                
                    break;
                }
                case("vn"):
                {
                    array_push(_normal_array[i], [real(_line_split[1]), real(_line_split[2]), real(_line_split[3])]);
                    break;
                }
                case("f"):
                {
                    var _vert_count = array_length(_line_split) - 1;
                    var _face = [];
                    for(var j = 0; j < _vert_count; j++)
                    {
                        var _face_verts = string_split(_line_split[j+1], "/");
                        array_push(_face, [real(_face_verts[0]), real(_face_verts[1]), real(_face_verts[2])]);
                    }
                    array_push(_face_array[i], _face);
                    break;
                }
                default:
                {
                    // idk lol
                }
            }
        }
        file_text_close(_file);
    }
    
    var _min = [99999, 99999, 99999];
    var _max = [-99999, -99999, -99999];
    var _tris = [];
    
    for(var m = 0; m < array_length(_files); m++)
    {
        s3d_trace("Model ", m);
        
        for(var i = 0; i < array_length(_face_array[m]); i++)
        {
            var _tri = [];
            var _verts = _face_array[m][i];
            
            for(var j = 0; j < array_length(_verts); j++)
            {
                var _vert = _verts[j];
                var _v = _position_array[m][_vert[0] - 1];
                var _vn = _normal_array[m][_vert[2] - 1];
                
                array_push(_tri, [_v[0], _v[1], _v[2]]);
                _min[0] = min(_v[0], _min[0]);
                _min[1] = min(_v[1], _min[1]);
                _min[2] = min(_v[2], _min[2]);
                _max[0] = max(_v[0], _max[0]);
                _max[1] = max(_v[1], _max[1]);
                _max[2] = max(_v[2], _max[2]);
            }
            
            /*
            So for a triangle p1, p2, p3, if the vector A = p2 - p1 and the vector B = p3 - p1
            then the normal N = A x B and can be calculated by:

            Nx = Ay * Bz - Az * By
            Ny = Az * Bx - Ax * Bz
            Nz = Ax * By - Ay * Bx
            */
            
            var _a = vec3_subtract(_tri[1], _tri[0]);
            var _b = vec3_subtract(_tri[2], _tri[0]);
            
            var _normal = vec3_normalize(vec3_cross(_a, _b));
            var _nx = _normal[0];
            var _ny = _normal[1];
            var _nz = _normal[2];
            
            if(abs(_nx) > 1 or abs(_ny) > 1 or abs(_nz) > 1)
            {
                s3d_trace("Tri: ", [_tri[0], _tri[1], _tri[2]]);
                s3d_trace("Bad normals: ", [_nx, _ny, _nz]);
                show_error("Your math fucked up bitch", true);
            }
            
            var __tri = sd_tri(_tri[0], _tri[1], _tri[2], [_nx, _ny, _nz]);
            
            array_push(_tris, __tri);
        }
    }
    
    var _collmesh = new S3DCollMesh(_min, _max, _partition_size);
    for(var i = 0; i < array_length(_tris); i++)
    {
        _collmesh.TriAdd(_tris[i]);
    }
    
    return _collmesh;
}