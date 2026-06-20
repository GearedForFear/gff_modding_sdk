shader_type spatial;
uniform vec4 primary_color : hint_color;
uniform float brightness : hint_range(0.05, 1) = 1.0f;
uniform float gloss : hint_range(0, 1) = 0.0f;
uniform vec4 emission : hint_color;


void fragment() {
	float gloss_final = gloss * brightness;
	
	ALBEDO.rgb = primary_color.rgb * brightness;
	METALLIC = gloss_final / 4.0;
	SPECULAR = (1.0 + gloss_final) / 2.0;
	ROUGHNESS = 1.0 - gloss_final;
	EMISSION = emission.rgb;
}
