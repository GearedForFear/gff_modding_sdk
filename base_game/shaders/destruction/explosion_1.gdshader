shader_type spatial;
render_mode unshaded;
uniform bool rotate;
uniform sampler2D texture_albedo : hint_albedo;




void vertex() {
	if (rotate) {
		float time = TIME * 5.0;
		float cos_time = cos(time);
		float sin_time = sin(time);
		VERTEX *= transpose(mat3(
			vec3(1.0,0.0,0.0),
			vec3(0.0,cos_time,-sin_time),
			vec3(0.0,sin_time,cos_time)
		)) * transpose(mat3(
			vec3(cos_time,0.0,sin_time),
			vec3(0.0,1.0,0.0),
			vec3(-sin_time,0.0,cos_time)
		));
	}
}




void fragment() {
	ALBEDO = texture(texture_albedo,UV).rgb;
	ALPHA = float(int(FRAGCOORD.x + FRAGCOORD.y + 1.0) % 2);
	ALPHA_SCISSOR = 0.5;
}
