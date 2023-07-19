extends DirectionalLight


func _ready():
	directional_shadow_normal_bias = OS.window_size.x / OS.window_size.y / 2
	directional_shadow_max_distance \
			= get_node("/root/RootControl/SettingsManager").shadow_distance
