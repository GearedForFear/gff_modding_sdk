shader_type spatial;
render_mode vertex_lighting;
uniform vec4 albedo : hint_color;


void fragment() {
	ALBEDO = albedo.rgb;
	SPECULAR = 0.0;
}
