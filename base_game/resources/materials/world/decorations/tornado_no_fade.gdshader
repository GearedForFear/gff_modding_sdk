shader_type spatial;
render_mode async_visible,depth_draw_opaque,cull_disabled;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;


void fragment() {
	ALBEDO = albedo.rgb * texture(texture_albedo, UV).rgb;
	SPECULAR = 0.0;
}
