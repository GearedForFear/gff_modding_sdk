shader_type canvas_item;


uniform vec4 albedo : hint_color;


void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR *= albedo;
	COLOR.rgb -= abs(UV.y - 0.5);
}
