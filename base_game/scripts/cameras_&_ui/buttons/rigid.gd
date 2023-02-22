extends Button


export var max_rigid_bodies: int = 100


func _pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies \
			= max_rigid_bodies
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../GraphicsButtons/MaxRigidBodies"))
	get_node("/root/RootControl/ButtonPressAudio").play()
