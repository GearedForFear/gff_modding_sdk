extends Button


export var shadow_distance: int = 200
export var shadow_quality: int = 4096


func _pressed():
	get_node("/root/RootControl/SettingsManager").shadow_distance \
			= shadow_distance
	ProjectSettings.set_setting("rendering/quality/directional_shadow/size", \
			shadow_quality)
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/ShadowDistance"))
	get_node("/root/RootControl/ButtonPressAudio").play()
