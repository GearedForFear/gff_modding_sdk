shader_type canvas_item;
uniform sampler2D Gradient;




void fragment() {
	float gradient_uv = 1.0 - abs((UV.y - 0.5) * 2.0);
	float alpha = texture(Gradient, vec2(gradient_uv).xy).a;
	COLOR.a = alpha;
}
