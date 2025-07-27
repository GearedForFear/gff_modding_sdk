shader_type spatial;
render_mode vertex_lighting;
const vec3 Color0 = vec3(0.89, 0.65, 0.48);
const vec3 Color1 = vec3(0.88, 0.71, 0.53);
const vec3 Color2 = vec3(0.73, 0.53, 0.37);
const vec3 Color3 = vec3(0.24);


void vertex() {
	lowp int uv_position = int(UV.x * 2.0) * 2 + int(UV.y * 2.0);
	
	if (uv_position == 0) {
		COLOR.rgb = Color0;
	} else if (uv_position == 1) {
		COLOR.rgb = Color1;
	} else if (uv_position == 2) {
		COLOR.rgb = Color2;
	} else {
		COLOR.rgb = Color3;
	}
}




void fragment() {
	ALBEDO = COLOR.rgb;
	SPECULAR = 0.0;
}
