global.sd_identity_matrix = matrix_build_identity();
global.sd_interp_uniform = shader_get_uniform(shS3DAnimated, "u_InterpolationFactor");
global.sd_outline_uniform = shader_get_uniform(shS3DAnimated, "u_OutlineSize");
global.sd_sprite_uvs_uniform = shader_get_uniform(shS3DAnimated, "u_SpriteUVs");

function sd_init()
{
    gpu_set_cullmode(cull_clockwise);
    gpu_set_ztestenable(true);
}

function sd_matrix_identity()
{
    return global.sd_identity_matrix;
}

function sd_matrix_set_world(_matrix)
{
    matrix_set(matrix_world, _matrix);
}

function sd_shader_animated_set()
{
    shader_set(shS3DAnimated);
}

function sd_shader_reset()
{
    shader_reset();
}

function sd_model_static_submit(_vbuff, _texture = -1, _outline_thickness = 0.1)
{
    gpu_set_cullmode(cull_clockwise);
    shader_set_uniform_f(global.sd_interp_uniform, 0);
    shader_set_uniform_f(global.sd_outline_uniform, 0.0);
    var _uvs = texture_get_uvs(_texture);
    shader_set_uniform_f_array(global.sd_sprite_uvs_uniform, [_uvs[0], _uvs[1], _uvs[2], _uvs[3]]);
    vertex_submit(_vbuff[0], pr_trianglelist, _texture);
    gpu_set_cullmode(cull_counterclockwise);
    shader_set_uniform_f(global.sd_outline_uniform, _outline_thickness);
    vertex_submit(_vbuff[0], pr_trianglelist, _texture);
}

function sd_model_anim_submit(_vbuff_array, _frame, _texture = -1, _outline_thickness = 0.1)
{
    gpu_set_cullmode(cull_clockwise);
    var _vbuff = _vbuff_array[floor(_frame)];
    shader_set_uniform_f(global.sd_interp_uniform, frac(_frame));
    shader_set_uniform_f(global.sd_outline_uniform, 0.0);
    var _uvs = texture_get_uvs(_texture);
    shader_set_uniform_f_array(global.sd_sprite_uvs_uniform, [_uvs[0], _uvs[1], _uvs[2], _uvs[3]]);
    vertex_submit(_vbuff, pr_trianglelist, _texture);
    gpu_set_cullmode(cull_counterclockwise);
    shader_set_uniform_f(global.sd_outline_uniform, _outline_thickness);
    vertex_submit(_vbuff, pr_trianglelist, _texture);
}

function S3DCollection() constructor
{
    models = [];
}

function S3DModel() constructor
{
    frames = [];
    
    static FrameAdd = function(_vbuff)
    {
        array_push(frames, _vbuff);
    }
    
    static Submit = function(_frame, _texture)
    {
        var _uni = shader_get_uniform(shS3DAnimated, "u_InterpolationFactor");
        shader_set(shS3DAnimated);
        shader_set_uniform_f(_uni, frac(_frame));
        vertex_submit(frames[floor(_frame)], pr_trianglelist, _texture);
    }
}