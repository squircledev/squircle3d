// draw_clear_alpha(c_black, 1.0);
sd_matrix_set_world(matrix_build(player.x, player.y, player.z, 0, 0, 0, 1, 1, 1));
sd_shader_animated_set();
sd_model_anim_submit(vbuff, frame, sprite_get_texture(sprRed, 0), 0.075);
sd_matrix_set_world(matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));
sd_model_static_submit(floor_model, sprite_get_texture(sprRiki, 0), 0);
sd_shader_reset();
sd_matrix_set_world(sd_matrix_identity());