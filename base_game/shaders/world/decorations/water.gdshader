shader_type spatial;
uniform bool move = true;
uniform float wave_height : hint_range(2, 60) = 2.0f;
uniform vec4 albedo_0 : hint_color;
uniform vec4 albedo_1 : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform sampler2D noise : hint_albedo;


void vertex() {
	if (move) {
		VERTEX.y += texture(noise,UV + TIME * 0.04).r * wave_height;
	} else {
		VERTEX.y += 0.5
	}
}




void fragment() {
	float mix_weight = texture(texture_albedo, UV).r;
	ALBEDO = mix(albedo_0.rgb, albedo_1.rgb, mix_weight);
	METALLIC = 0.1;
	ROUGHNESS = 0.5;
	SPECULAR = 0.5;
}




void light() {
    DIFFUSE_LIGHT += ATTENUATION * LIGHT_COLOR * 0.04;
}
