shader_type spatial;
render_mode unshaded;
uniform vec4 base_color : hint_color;


void fragment() {
	ALPHA = 1.0 - normalize(NORMAL).z;
	ALPHA *= abs(sin(SCREEN_UV.y * 256.0));
	ALPHA_SCISSOR = 0.15;
	
	ALBEDO = base_color.rgb * ALPHA * 4.0;
}
