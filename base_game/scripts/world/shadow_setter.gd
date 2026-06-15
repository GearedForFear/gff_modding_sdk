class_name ShadowSetter
extends MeshInstance


enum ShadowCasters {EXTRA_LOW, LOW, DEFAULT, HIGH, EXTRA_HIGH, ULTIMATE}

export(ShadowCasters) var required_setting: int = ShadowCasters.DEFAULT


func _enter_tree():
	if SettingsManager.get_this().shadow_casters < required_setting:
		cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
