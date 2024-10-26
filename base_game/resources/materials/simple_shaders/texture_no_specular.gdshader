shader_type spatial;
render_mode async_visible,depth_draw_opaque;
uniform sampler2D texture_albedo : hint_albedo;


void fragment() {
	ALBEDO = texture(texture_albedo, UV).rgb;
	SPECULAR = 0.0;
}
