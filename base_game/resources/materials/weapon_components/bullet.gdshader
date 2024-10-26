shader_type spatial;
render_mode cull_front,unshaded;
uniform vec4 ColorUniform : hint_color;




void vertex() {
	COLOR.a = VERTEX.y + 1.0;
}




void fragment() {
	ALBEDO = ColorUniform.rgb;
	ALPHA = COLOR.a
			- float(int(FRAGCOORD.x) % 4) / 32.0
			- float(int(FRAGCOORD.y) % 4) / 16.0
			- float(int(FRAGCOORD.x) % 2) / 8.0
			- float(int(FRAGCOORD.y) % 2) / 4.0;
	ALPHA_SCISSOR = 0.5;
}
