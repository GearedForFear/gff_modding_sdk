extends Button


export var max_rigid_bodies: int = 100

onready var root_control: Control = get_node("/root/RootControl")
onready var config: ConfigFile = root_control.config


func _pressed():
	root_control.get_node("SettingsManager").max_rigid_bodies = max_rigid_bodies
	config.set_value("graphics", "max_rigid_bodies", max_rigid_bodies)
	config.save("user://config.cfg")
	root_control.switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/MaxRigidBodies"))
	root_control.get_node("ButtonPressAudio").play()
