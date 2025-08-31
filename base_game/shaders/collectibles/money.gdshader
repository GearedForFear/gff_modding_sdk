shader_type spatial;
render_mode unshaded;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;




// Billboard mode
void vertex() {
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],
			CAMERA_MATRIX[1], CAMERA_MATRIX[2], WORLD_MATRIX[3]);
}




void fragment() {
	vec4 albedo_tex = texture(texture_albedo,UV);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA = albedo_tex.a
			- float(int(FRAGCOORD.x) % 4) / 16.0
			- float(int(FRAGCOORD.y) % 4) / 8.0
			- float(int(FRAGCOORD.x) % 2) / 4.0
			- float(int(FRAGCOORD.y) % 2) / 2.0;
	ALPHA_SCISSOR = 0.001;
}
