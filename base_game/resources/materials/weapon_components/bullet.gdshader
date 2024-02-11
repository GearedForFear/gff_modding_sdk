shader_type spatial;
render_mode cull_front,unshaded;
uniform vec4 ColorUniform : hint_color;
uniform float LengthFactor : hint_range(0.5, 1.0, 0.5);




void vertex() {
	COLOR.a = VERTEX.y * 0.5 + 1.0;
}




void fragment() {
	ALBEDO = ColorUniform.rgb;
	ALPHA = COLOR.a
			- float(int(SCREEN_UV.x * VIEWPORT_SIZE.x) % 4) / 32.0
			- float(int(SCREEN_UV.y * VIEWPORT_SIZE.y) % 4) / 16.0
			- float(int(SCREEN_UV.x * VIEWPORT_SIZE.x) % 2) / 8.0
			- float(int(SCREEN_UV.y * VIEWPORT_SIZE.y) % 2) / 4.0;
	ALPHA_SCISSOR=0.5;
}
