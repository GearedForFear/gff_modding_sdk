extends Control


export var base_font_size: float = 9.0


func _ready():
	var f: DynamicFont = get_font("font")
	f.size = int(base_font_size * clamp(OS.window_size.y, 0, OS.window_size.x \
			* 9 / 16) / 360 / get_node("/root/RootControl/SettingsManager")\
			.split_screen_divisor)
	f.size /= get_node("/root/RootControl/SettingsManager").resolution

	if f.outline_size != 0:
		f.outline_size = int(clamp(OS.window_size.y, 0, OS.window_size.x * 9 \
				/ 16) / 360 / get_node("/root/RootControl/SettingsManager")\
				.split_screen_divisor)
		f.outline_size \
				/= get_node("/root/RootControl/SettingsManager").resolution
