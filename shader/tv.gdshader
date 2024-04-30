shader_type spatial;
render_mode unshaded;

uniform sampler2D tv_texture;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 r_displacement = vec2(0.002, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.002);
uniform vec2 b_displacement = vec2(-0.002, 0.0);

void fragment() {
	float r = textureLod(tv_texture, UV + r_displacement, 0.0).r;
	float g = textureLod(tv_texture, UV + g_displacement, 0.0).g;
	float b = textureLod(tv_texture, UV + b_displacement, 0.0).b;

	ALBEDO = vec3(r, g, b);
}