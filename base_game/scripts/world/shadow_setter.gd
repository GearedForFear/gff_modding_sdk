class_name ShadowSetter
extends MeshInstance


enum shadow_casters {EXTRA_LOW, LOW, DEFAULT, HIGH, EXTRA_HIGH, ULTIMATE}

export(shadow_casters) var required_setting: int = shadow_casters.DEFAULT

var base_cast_shadow: int = -1


func _enter_tree():
	update_shadow_casting()


func update_shadow_casting():
	if base_cast_shadow == -1:
		base_cast_shadow = cast_shadow
	if SettingsManager.get_this().shadow_casters < required_setting:
		cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	else:
		cast_shadow = base_cast_shadow
