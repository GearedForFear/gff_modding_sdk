extends VBoxContainer


var controls: PlayerControls
var current_option: int = 0
var just_opened: bool = false

onready var vehicle: CombatVehicle = get_node("../../../../..")


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
						var s: String = tr("RESPAWN_INFO") + " "
						if i.is_class("InputEventJoypadButton"):
							s += "SELECT"
						else:
							s += i.as_text()
						var string_ending: String = tr("RESPAWN_INFO_2")
						if string_ending != "-":
							s += " " + string_ending
						
						get_node("../Info").text = s
						get_node("../AnimationPlayer").play("show_info")
						get_viewport().stop()
						vehicle.gameplay_manager.respawn(vehicle)
					else:
						get_node("../Info").text = tr("RESPAWN_INFO_3")
						get_node("../AnimationPlayer").play("show_info")
				2:
					get_tree().paused = false
					Global.gameplay_manager.get_parent().queue_free()
					get_node("/root/RootControl").active(true)
		
		if just_opened:
			just_opened = false
		else:
			if Input.is_action_just_pressed(controls.pause):
				get_tree().paused = false
				open(false)


func open(b: bool):
	visible = b
	get_node("../../../PauseBackground").visible = b
	get_node("../RearMirror").visible = not b
	get_node("/root/RootControl/MaterialManager").set_movement(not b)
	get_node("/root/RootControl/DeletionManager").delete = b
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
