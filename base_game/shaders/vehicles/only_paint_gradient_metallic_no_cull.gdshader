// Contains code by CptPotato and Calinou (MIT license)
shader_type spatial;
render_mode specular_disabled, cull_disabled;
uniform sampler2D gradient_texture : hint_albedo;
uniform vec4 paint_color : hint_color;
uniform float brightness : hint_range(0.05f, 1) = 1.0f;


void fragment() {
	ALBEDO.rgb = paint_color.rgb * brightness;
	METALLIC = 0.2;
}


void light() {
	float light_strength = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	DIFFUSE_LIGHT += ATTENUATION * mix(
			texture(gradient_texture, vec2(light_strength), 0).rgb,
			ALBEDO * LIGHT_COLOR * light_strength,
			ROUGHNESS - 1.0);
}
