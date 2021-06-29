sd_init();
vbuff = sd_obj_to_model("werewollf.obj");
floor_model = sd_obj_to_model("floor.obj");
floor_collmesh = sd_obj_to_collmesh("floor.obj", 8);
cam = new S3DCamera(40, 16/9, 1, 32000);
cam.SetView(0);
cam.SetPosition(0, 10, -10);
cam.SetLookAt(0, 0, -1);
cam.SetViewMat(0);
frame = 0;
rotation = 0;
grav = 0.1;

player = {
    x: 0,
    y: 0,
    z: -10,
    xspd: 0,
    yspd: 0,
    zspd: 0
}