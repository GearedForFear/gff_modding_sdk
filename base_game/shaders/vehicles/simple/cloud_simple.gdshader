shader_type spatial;
uniform sampler2D skin_texture_0 : hint_albedo;
uniform vec4 primary_color : hint_color;
uniform vec4 secondary_color : hint_color;
uniform float brightness : hint_range(0.05, 1) = 1.0f;
uniform vec4 emission : hint_color;

varying float aspect_ratio;
varying vec2 uv_offset;


void vertex() {
	aspect_ratio = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y * 0.5625;
	uv_offset = normalize(MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xy * 0.5;
}


void fragment() {
	vec2 noise_uv = SCREEN_UV;
	noise_uv.x *= aspect_ratio;
	noise_uv += uv_offset;
	
	vec3 paint_color = mix(primary_color.rgb, secondary_color.rgb,
			texture(skin_texture_0, noise_uv).r);
	ALBEDO = paint_color.rgb * brightness;
	EMISSION = emission.rgb;
}
