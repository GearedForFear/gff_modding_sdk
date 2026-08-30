shader_type spatial;
uniform sampler2D main_texture : hint_albedo;


void fragment() {
	vec4 texture_values = texture(main_texture, UV);
	ALBEDO = texture_values.rgb;
	if (texture_values.a == 0.0) {
		METALLIC = 0.5;
	}
	SPECULAR = 0.0;
	ROUGHNESS = texture_values.a;
}
