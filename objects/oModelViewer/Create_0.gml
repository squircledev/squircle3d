sd_init();
vbuff = sd_obj_to_model("dog.obj");
cam = new S3DCamera(40, 16/9, 1, 32000);
cam.SetView(0);
cam.SetPosition(0, 10, -10);
cam.SetLookAt(0, 0, -1);
cam.SetViewMat(0);
frame = 0;
rotation = 0;
grav = 0.1;

model = {
    xrot: 0,
    yrot: 0,
    zrot: 0
}

zoom = 10;
z_height = -10;