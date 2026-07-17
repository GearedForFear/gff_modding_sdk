shader_type spatial;
render_mode unshaded;
uniform vec4 albedo : hint_color;


void fragment() {
	ALBEDO = albedo.rgb;
}
