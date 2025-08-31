shader_type spatial;
uniform sampler2D texture_albedo : hint_albedo;


void fragment() {
	ALBEDO = texture(texture_albedo,UV).rgb;
	METALLIC = 0.5;
	ROUGHNESS = 0.0;
	SPECULAR = 1.0;
}




void light() {
	const float ONE_DIVIDED_BY_PI = 0.318;
    DIFFUSE_LIGHT += ATTENUATION * LIGHT_COLOR * ONE_DIVIDED_BY_PI;
}
