shader_type spatial;
uniform vec4 primary_color : hint_color;
uniform vec4 secondary_color : hint_color;
uniform float brightness : hint_range(0.05, 1) = 1.0f;
uniform vec4 emission : hint_color;


void fragment() {
	ALBEDO.rgb = secondary_color.rgb * brightness;
	EMISSION = emission.rgb + primary_color.rgb * brightness;
}
