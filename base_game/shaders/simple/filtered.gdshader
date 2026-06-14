// Contains code by CptPotato and Calinou (MIT license)
shader_type spatial;
uniform sampler2D main_texture : hint_albedo;
uniform float metallic : hint_range(0, 1) = 0.0f;
uniform float specular : hint_range(0, 1) = 0.5f;
uniform float roughness : hint_range(0, 1) = 1.0f;


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
	vec2 tex_size = 1.0f / vec2(textureSize(main_texture, 0)); // size of one pixel of the texture
	
	ALBEDO = texture_point_smooth(main_texture, UV, tex_size).rgb;
	METALLIC = metallic;
	SPECULAR = specular;
	ROUGHNESS = roughness;
}
