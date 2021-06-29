frame = sd_wrap(frame + 0.25, 0, array_length(vbuff) - 1);
rotation += 0.3;

player.xspd = (keyboard_check(vk_right) - keyboard_check(vk_left)) * 0.05;
player.yspd = (keyboard_check(vk_down) - keyboard_check(vk_up)) * 0.05;
player.zspd += grav;

var _new_x = player.x + player.xspd;
var _new_y = player.y + player.yspd;
var _new_z = player.z + player.zspd;
var _move_normal = vec3_normal([player.x, player.y, player.z], [_new_x, _new_y, _new_z]);

var _coll = floor_collmesh.CheckSphereColl(sd_sphere([_new_x, _new_y, _new_z - 0.95], 1));

if(_coll[0] == true)
{
    player.zspd = 0;
    var _tri = _coll[1];
    var _normal = sd_tri_get_normal(_tri);
    if(_normal[2] > 0.25)
    {
        // it's a ceiling
    }
    else if(_normal[2] < -0.25)
    {
        // it's a floor
        var _closest_point = _coll[2];
        var _pen_depth = _coll[3];
        _coll = floor_collmesh.CheckSphereColl(sd_sphere([_new_x, _new_y, _new_z - 0.95], 1));
        while(_coll[0] == true)
        {
            _new_z -= 0.01;
            _coll = floor_collmesh.CheckSphereColl(sd_sphere([_new_x, _new_y, _new_z - 0.95], 1));
        }
    }
    else
    {
        // it's a wall
        var _new_x = player.x;
        var _new_y = player.y;
        var _new_z = player.z;
    }
    sd_trace("Normal: ", _normal);
}

player.x = _new_x;
player.y = _new_y;
player.z = _new_z;