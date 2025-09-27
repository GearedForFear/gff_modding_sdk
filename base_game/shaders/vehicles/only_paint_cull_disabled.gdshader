shader_type spatial;
render_mode specular_disabled, cull_disabled;
uniform vec4 paint_color : hint_color;
uniform float brightness : hint_range(0.05f, 1) = 1.0f;


void fragment() {
	ALBEDO.rgb = paint_color.rgb * brightness;
}
