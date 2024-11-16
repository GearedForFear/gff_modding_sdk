shader_type spatial;
render_mode async_visible,cull_disabled,unshaded;




void fragment() {
	ALPHA = COLOR.a;
	ALPHA_SCISSOR = 
			float(((int(FRAGCOORD.x / 4.0) % 7
			+ int(FRAGCOORD.y / 4.0) % 5
			+ int(FRAGCOORD.x) % 3
			+ int(FRAGCOORD.y)) % 4)) / 7.0
			+ float(int(FRAGCOORD.x) % 11
			+ int(FRAGCOORD.y) % 7) / 199.0
			+ float(int(FRAGCOORD.x) % 5
			+ int(FRAGCOORD.y) % 3) / 97.0
			+ float(int(FRAGCOORD.x) % 2
			+ int(FRAGCOORD.y) % 2) / 7.0 + 0.01;
}
