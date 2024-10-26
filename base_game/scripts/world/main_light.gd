extends DirectionalLight


func _ready():
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
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
	
	if root_control.player_amount == 1:
		match settings_manager.splits:
			0:
				shadow_enabled = false
			1:
				directional_shadow_mode = DirectionalLight.SHADOW_ORTHOGONAL
			2:
				directional_shadow_mode = DirectionalLight.SHADOW_PARALLEL_2_SPLITS
				directional_shadow_split_1 = 0.5
			4:
				directional_shadow_mode = DirectionalLight.SHADOW_PARALLEL_4_SPLITS
	else:
		match settings_manager.splits_multiplayer:
			0:
				shadow_enabled = false
			1:
				directional_shadow_mode = DirectionalLight.SHADOW_ORTHOGONAL
			2:
				directional_shadow_mode = DirectionalLight.SHADOW_PARALLEL_2_SPLITS
				directional_shadow_split_1 = 0.5
			4:
				directional_shadow_mode = DirectionalLight.SHADOW_PARALLEL_4_SPLITS
