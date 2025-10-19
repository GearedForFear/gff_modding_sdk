// Contains code by CptPotato and Calinou (MIT license)
shader_type spatial;
render_mode specular_disabled;
uniform sampler2D texture_albedo_sharp : hint_albedo;
uniform sampler2D texture_albedo_blurry : hint_albedo;
uniform sampler2D gradient_texture : hint_albedo;
uniform float blur : hint_range(0, 1) = 0.0f;
uniform vec4 paint_color : hint_color;
uniform float brightness : hint_range(0.05f, 1) = 1.0f;


vec4 texture_point_smooth(sampler2D smp, vec2 uv, vec2 pixel_size) {
	vec2 ddx = dFdx(uv);
	vec2 ddy = dFdy(uv);
	vec2 lxy = sqrt(ddx * ddx + ddy * ddy);
	
	vec2 uv_pixels = uv / pixel_size;
	
	vec2 uv_pixels_floor = round(uv_pixels) - vec2(0.5f);
	vec2 uv_dxy_pixels = uv_pixels - uv_pixels_floor;
	
	uv_dxy_pixels = clamp((uv_dxy_pixels - vec2(0.5f)) * pixel_size / lxy
			+ vec2(0.5f), 0.0f, 1.0f);
	
	uv = uv_pixels_floor * pixel_size;
	
	return textureGrad(smp, uv + uv_dxy_pixels * pixel_size, ddx, ddy);
}


void fragment() {
	vec2 tex_size = 1.0f / vec2(textureSize(texture_albedo_sharp, 0)); // size of one pixel of the texture
	
	vec4 texture_sharp = texture_point_smooth(texture_albedo_sharp, UV,
			tex_size);
	vec4 texture_blurry = texture_point_smooth(texture_albedo_blurry, UV,
			tex_size);
	vec4 texture_combined = mix(texture_sharp.rgba, texture_blurry.rgba, blur);
	
	ALBEDO.rgb = mix(paint_color.rgb, texture_combined.rgb, texture_combined.a)
			* brightness;
	ROUGHNESS += texture_combined.a;
}


void light() {
	float light_strength = clamp(dot(NORMAL, LIGHT), 0.0, 1.0);
	DIFFUSE_LIGHT += ATTENUATION * mix(
			texture(gradient_texture, vec2(light_strength), 0).rgb,
			ALBEDO * LIGHT_COLOR * light_strength,
			ROUGHNESS - 1.0);
}
