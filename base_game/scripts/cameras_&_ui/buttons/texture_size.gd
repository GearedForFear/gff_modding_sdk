extends Button


export var shadow_distance: float = 125.0
export var max_texture_size: int = 4096

onready var root_control: Control = get_node("/root/RootControl")
onready var config: ConfigFile = root_control.config


func _ready():
	if max_texture_size >= 16384 and OS.has_feature("32"):
		disabled = true


func _pressed():
	root_control.get_node("SettingsManager").shadow_distance = shadow_distance
	root_control.get_node("SettingsManager").max_texture_size = max_texture_size
	ProjectSettings.set_setting("rendering/quality/directional_shadow/size", \
			max_texture_size)
	config.set_value("graphics", "shadow_distance", shadow_distance)
	config.set_value("graphics", "max_texture_size", max_texture_size)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/TextureSize"))
	root_control.get_node("ButtonPressAudio").play()
