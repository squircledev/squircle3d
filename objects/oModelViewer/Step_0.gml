var _hax = keyboard_check(vk_right) - keyboard_check(vk_left);
var _vax = keyboard_check(vk_down) - keyboard_check(vk_up);

zoom += _hax * 0.25;
z_height += _vax * 0.25;

cam.SetPosition(0, zoom, z_height);
cam.SetViewMat(0);

// model.xrot += 0.1;
// model.yrot += 0.25;
model.zrot += 0.3;