extends ShadowSetter


export var fallback_2048: Material


func _ready():
	if get_node("/root/RootControl/SettingsManager").max_texture_size <= 2048:
		material_override = fallback_2048
