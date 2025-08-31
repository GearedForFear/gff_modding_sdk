shader_type spatial;
render_mode unshaded;
uniform vec4 albedo : hint_color;




// Billboard mode
void vertex() {
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],
			CAMERA_MATRIX[1], CAMERA_MATRIX[2], WORLD_MATRIX[3]);
}




void fragment() {
	ALBEDO = albedo.rgb;
}
