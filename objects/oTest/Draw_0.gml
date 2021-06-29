s3d_matrix_set_world(matrix_build(player.x, player.y, player.z, 0, 0, 0, 1, 1, 1));
s3d_shader_animated_set();
s3d_model_anim_submit(vbuff, frame, sprite_get_texture(sprRed, 0), 0.075);
s3d_matrix_set_world(matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));
s3d_model_static_submit(floor_model, sprite_get_texture(sprRiki, 0), 0);
s3d_shader_reset();
s3d_matrix_set_world(s3d_matrix_identity());