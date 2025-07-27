shader_type spatial;
render_mode vertex_lighting;
const vec3 Colors[8] = {vec3(0.06, 0.02, 0.0), vec3(0.33, 0.55, 0.15),
		vec3(0.05), vec3(0.4, 0.22, 0.1), vec3(0.06),
		vec3(0.0, 0.05, 0.4), vec3(0.54, 0.58, 0.6),
		vec3(0.07, 0.027, 0.0)};


void vertex() {
	lowp int uv_position = int(UV.x * 2.0) * 4 + int(UV.y * 4.0);
	
	COLOR.rgb = Colors[uv_position];
	
	if (uv_position == 5) {
		// UV2.x for METALLIC
		// UV2.y for ROUGHNESS
		UV2 = vec2(0.5, 0.0);
	} else {
		UV2 = vec2(0.0, 1.0);
	}
}




void fragment() {
	ALBEDO = COLOR.rgb;
	METALLIC = UV2.x;
	ROUGHNESS = UV2.y;
	SPECULAR = 0.0;
}
