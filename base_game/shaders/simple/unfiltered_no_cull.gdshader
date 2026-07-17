shader_type spatial;
render_mode cull_disabled;
uniform sampler2D main_texture : hint_albedo;
uniform float metallic : hint_range(0, 1) = 0.0f;
uniform float specular : hint_range(0, 1) = 0.5f;
uniform float roughness : hint_range(0, 1) = 1.0f;


void fragment() {
	ALBEDO = texture(main_texture, UV).rgb;
	METALLIC = metallic;
	SPECULAR = specular;
	ROUGHNESS = roughness;
}
