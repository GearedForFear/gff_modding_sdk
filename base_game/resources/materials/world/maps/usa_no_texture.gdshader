shader_type spatial;
render_mode vertex_lighting;
const vec3 Colors[4] = {vec3(0.8, 0.38, 0.2), vec3(0.85, 0.52, 0.26),
		vec3(0.53, 0.26, 0.12), vec3(0.05)};


void vertex() {
	COLOR.rgb = Colors[int(UV.x * 2.0) * 2 + int(UV.y * 2.0)];
}




void fragment() {
	ALBEDO = COLOR.rgb;
	SPECULAR = 0.0;
}
