shader_type spatial;
render_mode unshaded;

const float FRAME_RATE = 1024.0;
const float SPEED_DIVISOR = FRAME_RATE * -32.0;
const float RESOLUTION_Y = 128.0;
const float BLUR = 3.0;

varying vec2 movement_offset;
varying vec2 resolution;
varying vec2 pixel_centre_offset;


void vertex() {
	movement_offset = vec2(0.0);
	movement_offset.y = float(int(TIME * FRAME_RATE) % int(SPEED_DIVISOR));
	movement_offset.y /= SPEED_DIVISOR;
	
	resolution = vec2(RESOLUTION_Y);
	float aspect_ratio = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
	resolution.x *= aspect_ratio;
	
	pixel_centre_offset = 0.5 / resolution;
}


void fragment() {
	vec2 uv = SCREEN_UV;
	uv += movement_offset;
	uv *= resolution;
	uv.x = float(int(uv.x));
	uv.y = float(int(uv.y));
	uv /= resolution;
	uv -= movement_offset;
	uv += pixel_centre_offset;
	ALBEDO = textureLod(SCREEN_TEXTURE, uv, BLUR).rgb;
}
