shader_type spatial;
render_mode cull_disabled;
uniform sampler2D main_texture : hint_albedo;
uniform sampler2D noise_texture : hint_albedo;
uniform vec4 color : hint_color;
uniform bool move;

varying float time_offset;


void vertex() {
	time_offset = TIME;
	time_offset *= VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
	time_offset *= 0.4;
}


void fragment() {
	ALBEDO = texture(main_texture, UV).rgb;
	ALBEDO *= color.rgb;
	SPECULAR = 0.0;
	
	vec2 dithering_uv = SCREEN_UV;
	if (move) {
		float dithering_offset = time_offset;
		if (!FRONT_FACING) {
			dithering_offset *= -1.0;
		}
		dithering_uv.x += dithering_offset;
	}
	
	ALPHA = -VERTEX.z;
	ALPHA *= texture(noise_texture, dithering_uv).r;
	ALPHA_SCISSOR = 16.0;
}
