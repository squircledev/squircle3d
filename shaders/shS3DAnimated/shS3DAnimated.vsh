attribute vec3 in_Position; // (x, y, z)
attribute vec3 in_Colour0; // position
attribute vec4 in_Colour1; // (r, g, b, a)
attribute vec3 in_Colour2; // normal
attribute vec3 in_Normal;
attribute vec2 in_TextureCoord; // (u, v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_InterpolationFactor;
uniform float u_OutlineSize;
uniform float u_SpriteUVs[4];

void main()
{
	vec3 pos_1 = in_Position;
	vec3 pos_2 = in_Colour0;
	vec3 normal_1 = in_Normal;
	vec3 normal_2 = in_Colour2;
	float _nx = mix(normal_1.x, normal_2.x, u_InterpolationFactor);
	float _ny = mix(normal_1.y, normal_2.y, u_InterpolationFactor);
	float _nz = mix(normal_1.z, normal_2.z, u_InterpolationFactor);
	float _x = mix(pos_1.x, pos_2.x, u_InterpolationFactor) + _nx * u_OutlineSize;
	float _y = mix(pos_1.y, pos_2.y, u_InterpolationFactor) + _ny * u_OutlineSize;
	float _z = mix(pos_1.z, pos_2.z, u_InterpolationFactor) + _nz * u_OutlineSize;
	
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(_x, _y, _z, 1.0);
	
	v_vColour = mix(in_Colour1, vec4(0.0, 0.0, 0.0, 1.0), _nz / 2.0);
	if(u_OutlineSize > 0.0)
	{
		v_vColour = vec4(0.0, 0.0, 0.0, 1.0);
	}
	
	v_vTexcoord = vec2(
		u_SpriteUVs[0] + in_TextureCoord.x * (u_SpriteUVs[2] - u_SpriteUVs[0]),
		u_SpriteUVs[1] + in_TextureCoord.y * (u_SpriteUVs[3] - u_SpriteUVs[1])
		);
}