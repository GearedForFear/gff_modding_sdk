// Contains code by CptPotato and Calinou (MIT license)
shader_type spatial;
render_mode specular_disabled;
const vec3 Emission = vec3(1, 0.141176f, 0);
uniform sampler2D texture_albedo : hint_albedo;
uniform sampler2D noise : hint_albedo;
uniform vec4 paint_color_1 : hint_color;
uniform vec4 paint_color_2 : hint_color;
uniform float brightness : hint_range(0.05f, 1) = 1.0f;
uniform float emission_energy : hint_range(0, 2.0f);


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


void vertex() {
	// Alpha channel for aspect ratio
	// 1.0 in case of 16/9
	COLOR.a = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y * 0.5625;
	
	UV2 = normalize(MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xy * 0.5;
}


void fragment() {
	vec2 tex_size = 1.0f / vec2(textureSize(texture_albedo, 0)); // size of one pixel of the texture
	
	vec4 albedo_tex = texture_point_smooth(texture_albedo, UV, tex_size);
	
	vec2 uv = SCREEN_UV;
	uv.x *= COLOR.a;
	uv += UV2;
	vec3 paint_color = mix(paint_color_1.rgb, paint_color_2.rgb,
			texture(noise, uv).r);
	ALBEDO.rgb = mix(paint_color, albedo_tex.rgb, albedo_tex.a)
			* brightness;
	EMISSION = Emission * emission_energy;
}
