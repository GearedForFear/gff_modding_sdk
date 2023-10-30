shader_type spatial;
render_mode async_visible,cull_back,unshaded;
uniform sampler2D texture_albedo : hint_albedo;
uniform float dithering : hint_range(0, 1, 1);




void fragment() {
	ALBEDO = texture(texture_albedo,UV).rgb;
	ALPHA = float(int(SCREEN_UV.x * VIEWPORT_SIZE.x + SCREEN_UV.y * VIEWPORT_SIZE.y + dithering) % 2);
	ALPHA_SCISSOR = 0.5;
}
