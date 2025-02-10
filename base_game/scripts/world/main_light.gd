extends DirectionalLight


func _ready():
	var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
	settings_manager.to_update.append(self)
	apply_settings(settings_manager)


func apply_settings(settings_manager: Node):
	var root_control: Control = get_node_or_null("/root/RootControl")
	if root_control == null:
		return
	var split_screen_stretch: float
	match root_control.player_amount:
		1,4,5:
			split_screen_stretch = 1.0
		2,3:
			split_screen_stretch = 0.25
		6:
			split_screen_stretch = 2.25
	
	directional_shadow_max_distance = settings_manager.shadow_distance() \
			 * split_screen_stretch
	
	directional_shadow_fade_start = clamp(directional_shadow_max_distance / 360, 0.5, 0.9)
	
	var splits_setting: int
	if root_control.player_amount == 1:
		splits_setting = settings_manager.splits
	else:
		splits_setting = settings_manager.splits_multiplayer
	match splits_setting:
		0:
			shadow_enabled = false
		1:
			shadow_enabled = true
			directional_shadow_mode = DirectionalLight.SHADOW_ORTHOGONAL
		2:
			shadow_enabled = true
			directional_shadow_mode = DirectionalLight.SHADOW_PARALLEL_2_SPLITS
			directional_shadow_split_1 = 0.5
		4:
			shadow_enabled = true
			directional_shadow_mode = DirectionalLight.SHADOW_PARALLEL_3_SPLITS
			directional_shadow_split_1 = 0.1
		4:
			shadow_enabled = true
			directional_shadow_mode = DirectionalLight.SHADOW_PARALLEL_4_SPLITS
			directional_shadow_split_1 = 0.1
