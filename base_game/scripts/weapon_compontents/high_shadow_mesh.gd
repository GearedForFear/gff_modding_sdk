extends MeshInstance


func _ready():
	if get_node("/root/RootControl/SettingsManager").shadow_casters >= 4:
		cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_ON
