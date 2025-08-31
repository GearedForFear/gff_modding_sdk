shader_type spatial;
render_mode vertex_lighting;
const vec3 Color0 = vec3(0.27, 0.17, 0.08);
const vec3 Color1 = vec3(0.55, 0.72, 0.35);
const vec3 Color2 = vec3(0.24);
const vec3 Color3 = vec3(0.58, 0.41, 0.22);
const vec3 Color4 = vec3(0.23);
const vec3 Color5 = vec3(0.03, 0.23, 0.64);
const vec3 Color6 = vec3(0.79, 0.81, 0.82);
const vec3 Color7 = vec3(0.3, 0.2, 0.11);


void vertex() {
	lowp int uv_position = int(UV.x * 2.0) * 4 + int(UV.y * 4.0);
	
	// UV2.x for METALLIC
	// UV2.y for ROUGHNESS
	UV2 = vec2(0.0, 1.0);
	
	if (uv_position == 0) {
		COLOR.rgb = Color0;
	} else if (uv_position == 1) {
		COLOR.rgb = Color1;
	} else if (uv_position == 2) {
		COLOR.rgb = Color2;
	} else if (uv_position == 3) {
		COLOR.rgb = Color3;
	} else if (uv_position == 4) {
		COLOR.rgb = Color4;
	} else if (uv_position == 5) {
		COLOR.rgb = Color5;
		UV2 = vec2(0.5, 0.0);
	} else if (uv_position == 6) {
		COLOR.rgb = Color6;
	} else {
		COLOR.rgb = Color7;
	}
}




void fragment() {
	ALBEDO = COLOR.rgb;
	METALLIC = UV2.x;
	ROUGHNESS = UV2.y;
	SPECULAR = 0.0;
}
