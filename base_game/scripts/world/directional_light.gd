extends DirectionalLight


func _ready():
	directional_shadow_max_distance \
			= get_node("/root/RootControl/SettingsManager").shadow_distance
