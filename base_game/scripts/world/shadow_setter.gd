class_name ShadowSetter
extends MeshInstance


enum shadow_casters {NONE, EXTRA_LOW, LOW, DEFAULT, HIGH, EXTRA_HIGH, ULTIMATE}

export(shadow_casters) var required_setting: int = shadow_casters.DEFAULT


func _ready():
	if get_node("/root/RootControl/SettingsManager").shadow_casters \
			< required_setting:
		cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
