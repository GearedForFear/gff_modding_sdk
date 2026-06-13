shader_type spatial;
render_mode unshaded;
uniform vec4 base_color : hint_color;
uniform sampler2D main_texture : hint_albedo;




// Billboard mode
void vertex() {
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],
			CAMERA_MATRIX[1], CAMERA_MATRIX[2], WORLD_MATRIX[3]);
}




void fragment() {
	ALPHA = texture(main_texture,UV).a;
	ALPHA *= abs(sin(SCREEN_UV.y * 256.0));
	ALPHA_SCISSOR = 0.15;
	
	ALBEDO = base_color.rgb * ALPHA * 4.0;
}
