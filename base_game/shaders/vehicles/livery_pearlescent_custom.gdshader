// Contains code by CptPotato and Calinou (MIT license)
shader_type spatial;
uniform sampler2D main_texture : hint_albedo;
uniform sampler2D mask : hint_albedo;
uniform vec4 primary_color : hint_color;
uniform vec4 secondary_color : hint_color;
uniform float brightness : hint_range(0.05, 1) = 1.0f;
uniform vec4 emission : hint_color = vec4(0);

varying float paint_mask;
varying float livery_mask;


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
	
	vec4 tex_point = texture_point_smooth(main_texture, UV, tex_size);
	vec3 details_color = tex_point.rgb;
	paint_mask = tex_point.a;
	
	ALBEDO.rgb = mix(secondary_color.rgb, details_color, paint_mask) * brightness;
	EMISSION = emission.rgb;
	
	livery_mask = texture_point_smooth(mask, UV, tex_size).r;
	livery_mask *= 0.75;
	livery_mask += 0.25;
}


void light() {
	float light_strength = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * brightness;
	DIFFUSE_LIGHT += ATTENUATION * mix(primary_color.rgb * livery_mask
			* light_strength, ALBEDO * LIGHT_COLOR * light_strength,
			paint_mask);
}
