shader_type spatial;
uniform sampler2D texture_albedo : hint_albedo;
uniform float roughness : hint_range(0, 1) = 1.0f;


void fragment() {
	ALBEDO = texture(texture_albedo, UV).rgb;
	SPECULAR = 0.0;
	ROUGHNESS = roughness;
}
