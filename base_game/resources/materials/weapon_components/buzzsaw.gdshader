shader_type spatial;
render_mode specular_disabled;
uniform bool rotate;
uniform sampler2D texture_albedo : hint_albedo;




void vertex() {
	if (rotate){
		float time = TIME * 15.0;
		float cos_time = cos(time);
		float sin_time = sin(time);
		VERTEX *= transpose(mat3(
			vec3(cos_time,0.0,sin_time),
			vec3(0.0,1.0,0.0),
			vec3(-sin_time,0.0,cos_time)
		));
	}
}




void fragment() {
	ALBEDO = texture(texture_albedo,UV).rgb;
}
