shader_type spatial;
render_mode unshaded, blend_add;


void fragment() {
	ALBEDO = texture(SCREEN_TEXTURE, UV).rgb;
}
