extends DirectionalLight


func _ready():
	var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
	var split_screen_stretch: int
	match get_node("/root/RootControl").player_amount:
		1,4,5:
			split_screen_stretch = 2
		2,3:
			split_screen_stretch = 1
		6:
			split_screen_stretch = 3
	directional_shadow_max_distance = settings_manager.shadow_distance \
			* OS.window_size.y * 5000 / OS.window_size.x \
			/ pow(settings_manager.field_of_view, 2) * split_screen_stretch
