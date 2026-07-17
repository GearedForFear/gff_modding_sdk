shader_type spatial;
uniform vec4 albedo : hint_color;
uniform float metallic : hint_range(0, 1) = 0.0f;
uniform float specular : hint_range(0, 1) = 0.5f;
uniform float roughness : hint_range(0, 1) = 1.0f;


void fragment() {
	ALBEDO = albedo.rgb;
	METALLIC = metallic;
	SPECULAR = specular;
	ROUGHNESS = roughness;
}
