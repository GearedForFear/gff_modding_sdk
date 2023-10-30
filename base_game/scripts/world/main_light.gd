extends DirectionalLight


func _ready():
	var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
	directional_shadow_max_distance = settings_manager.shadow_distance \
			* OS.window_size.y * 10000 / OS.window_size.x \
			/ pow(settings_manager.field_of_view, 2)
