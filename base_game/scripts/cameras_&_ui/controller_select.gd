extends Label


const INPUTS_1: Resource \
		= preload("res://resources/custom/player_controls/player_1.tres")
const INPUTS_2: Resource \
		= preload("res://resources/custom/player_controls/player_2.tres")
const INPUTS_3: Resource \
		= preload("res://resources/custom/player_controls/player_3.tres")
const INPUTS_4: Resource \
		= preload("res://resources/custom/player_controls/player_4.tres")
const INPUTS_5: Resource \
		= preload("res://resources/custom/player_controls/player_5.tres")
const INPUTS_6: Resource \
		= preload("res://resources/custom/player_controls/player_6.tres")
const INPUTS := [INPUTS_1, INPUTS_2, INPUTS_3, INPUTS_4, INPUTS_5, INPUTS_6]
const ALREADY_USED := [false, false, false, false, false, false]
const SELECTED_CONTROLS := Array()
const VEHICLE_SELECT: PackedScene \
		= preload("res://scenes/cameras_&_ui/vehicle_select.tscn")


func _enter_tree():
	for n in 6:
		ALREADY_USED[n] = false
	SELECTED_CONTROLS.clear()
	update_label()


func _process(_delta):
	for n in 6:
		if not ALREADY_USED[n]:
			for input in to_array(INPUTS[n]):
				if Input.is_action_just_released(input):
					SELECTED_CONTROLS.append(INPUTS[n])
					ALREADY_USED[n] = true
					update_label()
					break
	
	if SELECTED_CONTROLS.size() == Global.root_control.player_amount:
		MenuManager.next_menu(SELECTED_CONTROLS)


func to_array(var controls: PlayerControls) -> Array:
	var return_value := Array()
	for n in [controls.accelerate,
			controls.reverse,
			controls.turn_left,
			controls.turn_right,
			controls.weapon_front,
			controls.weapon_back,
			controls.weapon_left,
			controls.weapon_right,
			controls.boost,
			controls.drift,
			controls.respawn,
			controls.ui_accept,
			controls.ui_cancel,
			controls.ui_up,
			controls.ui_down,
			controls.ui_left,
			controls.ui_right]:
		return_value.append(n)
	return return_value


func update_label():
	text = ""
	for n in SELECTED_CONTROLS.size():
		text += tr("PLAYER_READY_1") + " " + String(n + 1) + " " \
				+ tr("PLAYER_READY_2") + "\n"
	
	if SELECTED_CONTROLS.size() != 0:
		text += "\n"
	
	text += tr("SELECT_CONTROLS_1") + " " \
			+ String(SELECTED_CONTROLS.size() + 1) + " " \
			+ tr("SELECT_CONTROLS_2") + "\n"
