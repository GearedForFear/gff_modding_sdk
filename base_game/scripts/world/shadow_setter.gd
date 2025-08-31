class_name ShadowSetter
extends MeshInstance


enum shadow_casters {EXTRA_LOW, LOW, DEFAULT, HIGH, EXTRA_HIGH, ULTIMATE}

export(shadow_casters) var required_setting: int = shadow_casters.DEFAULT

var base_cast_shadow: int = -1


func _ready():
	if base_cast_shadow == -1:
		base_cast_shadow = cast_shadow
	if get_node("/root/RootControl/SettingsManager").shadow_casters \
			< required_setting:
		cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	else:
		cast_shadow = base_cast_shadow


func get_class() -> String:
	return "ShadowSetter"
