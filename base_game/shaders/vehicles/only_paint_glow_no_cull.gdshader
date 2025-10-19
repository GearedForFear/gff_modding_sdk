// Contains code by CptPotato and Calinou (MIT license)
shader_type spatial;
render_mode specular_disabled, cull_disabled;
const lowp float EmissionEnergyPaint = 0.3f;
uniform vec4 paint_color : hint_color;
uniform float brightness : hint_range(0.05f, 1) = 1.0f;


void fragment() {
	ALBEDO.rgb = paint_color.rgb * brightness;
	EMISSION = EmissionEnergyPaint * ALBEDO.rgb;
}
