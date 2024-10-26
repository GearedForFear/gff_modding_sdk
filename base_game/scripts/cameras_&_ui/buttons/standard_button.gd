extends Button


export var selection: String = "../../GraphicsButtons/WindowModes"


func _ready():
	if name == "Reflections" and OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES2:
		disabled = true


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	root_control.switch_buttons(get_parent(), get_node(selection))
	root_control.get_node("ButtonPressAudio").play()


func _on_MaxRigidBodies_focus_entered():
	get_node("../../Warning").text = "WARNING:\nVery performance-intensive"
	get_node("../../Warning").show()


func _on_MaxRigidBodies_focus_exited():
	if get_parent().visible:
		get_node("../../Warning").hide()
