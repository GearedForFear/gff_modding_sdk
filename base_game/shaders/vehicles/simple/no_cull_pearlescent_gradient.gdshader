shader_type spatial;
uniform sampler2D skin_texture_0 : hint_albedo;
uniform vec4 primary_color : hint_color;
uniform float brightness : hint_range(0.05, 1) = 1.0f;
uniform float gloss : hint_range(0, 1) = 0.0f;
uniform vec4 emission : hint_color;

varying float gloss_final;


void fragment() {
	gloss_final = gloss * brightness;
	
	ALBEDO.rgb = primary_color.rgb * brightness;
	METALLIC = gloss_final / 4.0;
	SPECULAR = (1.0 + gloss_final) / 2.0;
	ROUGHNESS = 1.0 - gloss_final;
	EMISSION = emission.rgb;
}


void light() {
	float light_strength = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * brightness;
	DIFFUSE_LIGHT += ATTENUATION * texture(skin_texture_0,
			vec2(light_strength)).rgb;
	DIFFUSE_LIGHT += tan(ATTENUATION * light_strength * gloss_final * 1.55)
			/ 16.0;
}
