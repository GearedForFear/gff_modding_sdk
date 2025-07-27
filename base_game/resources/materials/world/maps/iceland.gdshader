shader_type spatial;
uniform sampler2D texture_albedo : hint_albedo;


void vertex() {
	if (UV.x < 0.5 || UV.y < 0.25 || UV.y > 0.5) {
		// UV2.x for METALLIC
		// UV2.y for ROUGHNESS
		UV2 = vec2(0.0, 1.0);
	} else {
		UV2 = vec2(0.5, 0.0);
	}
}




void fragment() {
	ALBEDO = texture(texture_albedo, UV).rgb;
	METALLIC = UV2.x;
	ROUGHNESS = UV2.y;
	SPECULAR = 0.0;
}
