attribute vec3 in_Position; // (x, y, z)
attribute vec3 in_Colour0; // position
attribute vec4 in_Colour1; // (r, g, b, a)
attribute vec3 in_Normal;
attribute vec2 in_TextureCoord; // (u, v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	vec3 pos_1 = in_Position;
	vec3 pos_2 = in_Colour0;
	float _x = in_Position.x + in_Normal.x * 0.0;
	float _y = in_Position.y + in_Normal.y * 2.0;
	float _z = in_Position.z + in_Normal.z * 2.0;
	vec4 object_space_pos = vec4(_x, _y, _z, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

	v_vColour = vec4(0.0, 0.0, 0.0, 1.0);
	v_vTexcoord = in_TextureCoord;
}