shader_type spatial;
render_mode async_visible,depth_draw_opaque,cull_disabled;
const float DistanceFadeMin = 0.0;
const float DistanceFadeMax = 60.0;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;


void fragment() {
	ALBEDO = albedo.rgb * texture(texture_albedo, UV).rgb;
	SPECULAR = 0.0;
	{
		const vec3 magic = vec3(0.06711056f, 0.00583715f, 52.9829189f);
		float fade = clamp(smoothstep(DistanceFadeMin, DistanceFadeMax,
				length(VERTEX)), 0.0, 1.0);
		if (fade < 0.001 || fade < fract(magic.z * fract(
				dot(FRAGCOORD.xy, magic.xy)))) {
			discard;
		}
	}
}
