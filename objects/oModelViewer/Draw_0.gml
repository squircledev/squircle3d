sd_matrix_set_world(matrix_build(0, 0, 0, model.xrot, model.yrot, model.zrot, 1, 1, 1));
sd_shader_animated_set();
sd_model_anim_submit(vbuff, 0, sprite_get_texture(sprRedDog, 0), 0.075);
sd_shader_reset();
sd_matrix_set_world(sd_matrix_identity());