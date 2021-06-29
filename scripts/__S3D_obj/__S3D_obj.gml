function __sd_obj() {}

function sd_obj_to_model(_filename)
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
        else
        {
            // werewollf_000000.obj
            var _x = 0;
            var _string = _filename_split[0] + "_" + string_replace_all(string_format(_x, 6, 0), " ", "0") + ".obj";
            while(file_exists(_string))
            {
                array_push(_files, _string);
                _x += 1;
                _string = _filename_split[0] + "_" + string_replace_all(string_format(_x, 6, 0), " ", "0") + ".obj";
            }
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
    
    sd_trace("Number of files found: ", array_length(_files));
    
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
                case("vt"):
                {
                    array_push(_uv_array[i], [real(_line_split[1]), real(_line_split[2])]);
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
    
    vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_custom(vertex_type_float3,vertex_usage_colour);
    vertex_format_add_color();
    vertex_format_add_custom(vertex_type_float3,vertex_usage_colour);
    vertex_format_add_normal();
    vertex_format_add_texcoord();
    var _format = vertex_format_end();
    
    for(var m = 0; m < array_length(_files); m++)
    {
        sd_trace("Model ", m);
        var _vbuff = vertex_create_buffer();
        vertex_begin(_vbuff, _format);
        var _next_m = m + 1;
        if(_next_m == array_length(_files))
        {
            _next_m = 0;
        }
        
        for(var i = 0; i < array_length(_face_array[m]); i++)
        {
            var _verts = _face_array[m][i];
            var _verts_2 = _face_array[_next_m][i];
            
            for(var j = 0; j < array_length(_verts); j++)
            {
                var _vert = _verts[j];
                var _vert_2 = _verts_2[j];
                var _v = _position_array[m][_vert[0] - 1];
                var _vt = _uv_array[m][_vert[1] - 1];
                var _vn = _normal_array[m][_vert[2] - 1];
                var _v2 = _position_array[_next_m][_vert[0] - 1];
                var _vn2 = _normal_array[_next_m][_vert[2] - 1];
                
                vertex_position_3d(_vbuff, _v[0], _v[1], _v[2]);
                vertex_float3(_vbuff, _v2[0], _v2[1], _v2[2]);
                vertex_color(_vbuff, c_white, 1);
                vertex_float3(_vbuff, _vn2[0], _vn2[1], _vn2[2]);
                vertex_normal(_vbuff, _vn[0], _vn[1], _vn[2]);
                vertex_texcoord(_vbuff, _vt[0], 1 - _vt[1]);
                
            }
        }
        vertex_end(_vbuff);
        array_push(_frames, _vbuff);
    }
    
    return _frames;
}