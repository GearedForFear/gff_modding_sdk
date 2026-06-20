shader_type spatial;
uniform vec4 primary_color : hint_color;
uniform vec4 secondary_color : hint_color;
uniform float brightness : hint_range(0.05, 1) = 1.0f;
uniform vec4 emission : hint_color;


void fragment() {
	ALBEDO = secondary_color.rgb * brightness;
	EMISSION = emission.rgb;
}


void light() {
	float light_strength = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * brightness;
	DIFFUSE_LIGHT += ATTENUATION * primary_color.rgb * light_strength;
}
