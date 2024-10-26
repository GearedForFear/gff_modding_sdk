shader_type spatial;
render_mode async_visible,unshaded;
uniform sampler2D texture_albedo : hint_albedo;


void vertex() {
	mat4 mat_world = mat4(normalize(CAMERA_MATRIX[0])*length(WORLD_MATRIX[0]),normalize(CAMERA_MATRIX[1])*length(WORLD_MATRIX[0]),normalize(CAMERA_MATRIX[2])*length(WORLD_MATRIX[2]),WORLD_MATRIX[3]);
	mat_world = mat_world * mat4( vec4(cos(INSTANCE_CUSTOM.x),-sin(INSTANCE_CUSTOM.x), 0.0, 0.0), vec4(sin(INSTANCE_CUSTOM.x), cos(INSTANCE_CUSTOM.x), 0.0, 0.0),vec4(0.0, 0.0, 1.0, 0.0),vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat_world;
}




void fragment() {
	ALBEDO = COLOR.rgb;
	ALPHA = texture(texture_albedo, UV).a;
	ALPHA_SCISSOR = 
			float(((int(FRAGCOORD.x / 4.0) % 7
			+ int(FRAGCOORD.y / 4.0) % 5
			+ int(FRAGCOORD.x) % 3
			+ int(FRAGCOORD.y)) % 4)) / 7.0
			+ float(int(FRAGCOORD.x) % 11
			+ int(FRAGCOORD.y) % 7) / 199.0
			+ float(int(FRAGCOORD.x) % 5
			+ int(FRAGCOORD.y) % 3) / 97.0
			+ float(int(FRAGCOORD.x) % 2
			+ int(FRAGCOORD.y) % 2) / 7.0 + 0.01;
}
