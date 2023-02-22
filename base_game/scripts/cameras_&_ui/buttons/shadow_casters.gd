extends Button


export var shadow_casters: int = 0


func _pressed():
	get_node("/root/RootControl/SettingsManager").shadow_casters \
			= shadow_casters
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/ShadowCasters"))
	get_node("/root/RootControl/ButtonPressAudio").play()
