extends MeshInstance


func _ready():
	if get_node("/root/RootControl/SettingsManager").shadow_amount == 0:
		cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
