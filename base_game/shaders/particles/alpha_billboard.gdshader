shader_type spatial;
uniform sampler2D texture_albedo : hint_albedo;
uniform float light_factor : hint_range(0, 0.318f) = 0.318f;


void vertex() {
	mat4 mat_world = mat4(normalize(CAMERA_MATRIX[0])*length(WORLD_MATRIX[0]),normalize(CAMERA_MATRIX[1])*length(WORLD_MATRIX[0]),normalize(CAMERA_MATRIX[2])*length(WORLD_MATRIX[2]),WORLD_MATRIX[3]);
	mat_world = mat_world * mat4( vec4(cos(INSTANCE_CUSTOM.x),-sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0),vec4(0.0, 0.0, 1.0, 0.0),vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat_world;
}




void fragment() {
	vec4 color = texture(texture_albedo,UV);
	color *= COLOR;
	ALBEDO = color.rgb;
	ALPHA = color.a;
}




void light() {
    DIFFUSE_LIGHT += ATTENUATION * LIGHT_COLOR * light_factor;
}
