extends VBoxContainer


var controls: PlayerControls
var current_option: int = 0
var just_opened: bool = false

onready var vehicle: VehicleBody = get_node("../../../../../..")


func _ready():
	controls = vehicle.controls


func _physics_process(_delta):
	if visible and controls != null:
		if Input.is_action_just_pressed(controls.ui_up):
			if current_option == 0:
				current_option = get_child_count() - 1
			else:
				current_option -= 1
			update_selection()
		
		if Input.is_action_just_pressed(controls.ui_down):
			current_option = (current_option + 1) % get_child_count()
			update_selection()
		
		if Input.is_action_just_released(controls.ui_accept):
			match current_option:
				0:
					get_tree().paused = false
					open(false)
				1:
					if  not vehicle.gameplay_manager.get_node("Timer").is_stopped():
						get_tree().paused = false
						open(false)
						var i: InputEvent = ProjectSettings.get_setting(
								"input/" + controls.respawn).events[0]
						var s: String = "You can also respawn with "
						if i.is_class("InputEventJoypadButton"):
							s += "SELECT"
						else:
							s += i.as_text()
						get_node("../../Info").text = s
						get_node("../../AnimationPlayer").play("show_info")
						get_viewport().stop()
						vehicle.gameplay_manager.respawn(vehicle)
					else:
						get_node("../../Info").text = \
								"You cannot respawn before the game starts"
						get_node("../../AnimationPlayer").play("show_info")
				2:
					get_tree().paused = false
					vehicle.gameplay_manager.get_parent().queue_free()
					get_node("/root/RootControl").active(true)
		
		if just_opened:
			just_opened = false
		else:
			if Input.is_action_just_pressed(controls.pause):
				get_tree().paused = false
				open(false)


func open(b: bool):
	visible = b
	get_parent().visible = b
	if b:
		current_option = 0
		just_opened = true
		update_selection()
	else:
		vehicle.pause_looping_audio()


func update_selection():
	for n in get_children():
		n.modulate = Color.white
	get_child(current_option).modulate = Color("fd5602")
