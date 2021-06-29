function __S3D_cam() {}

function S3DCamera(_fov, _aspect, _znear, _zfar) constructor
{
    camera = camera_create();
    proj_mat = matrix_build_projection_perspective_fov(_fov, _aspect,_znear, _zfar);
    camera_set_proj_mat(camera, proj_mat);
    x = 0;
    y = 0;
    z = 0;
    xto = 0;
    yto = 0;
    zto = 0;
    
    static SetView = function(_view)
    {
        view_enabled = true;//Enable the use of views
        view_set_visible(_view, true);//Make this view visible
        view_set_camera(_view, camera);
    }
    
    static SetViewMat = function(_view)
    {
        camera_set_view_mat(view_camera[_view], matrix_build_lookat(x,y,z, xto,yto,zto, 0,0,1));
    }
    
    static GetPosition = function()
    {
        return [x, y, z];
    }
    
    static SetPosition = function(_x, _y, _z)
    {
        x = _x;
        y = _y;
        z = _z;
    }
    
    static GetLookAt = function()
    {
        return [xto, yto, zto];
    }
    
    static SetLookAt = function(_xto, _yto, _zto)
    {
        xto = _xto;
        yto = _yto;
        zto = _zto;
    }
    
    
}