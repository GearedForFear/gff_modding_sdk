extends Button


export var shadow_distance: float = 200.0
export var shadow_quality: int = 4096

onready var root_control: Control = get_node("/root/RootControl")
onready var config: ConfigFile = root_control.config


func _pressed():
	root_control.get_node("SettingsManager").shadow_distance = shadow_distance
	ProjectSettings.set_setting("rendering/quality/directional_shadow/size", \
			shadow_quality)
	config.set_value("graphics", "shadow_distance", shadow_distance)
	config.set_value("graphics", "shadow_quality", shadow_quality)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/ShadowDistance"))
	root_control.get_node("ButtonPressAudio").play()
