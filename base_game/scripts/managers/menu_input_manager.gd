extends Node


const ALL_CONTROLS := [
		preload("res://resources/custom/player_controls/player_1.tres"),
		preload("res://resources/custom/player_controls/player_2.tres"),
		preload("res://resources/custom/player_controls/player_3.tres"),
		preload("res://resources/custom/player_controls/player_4.tres"),
		preload("res://resources/custom/player_controls/player_5.tres"),
		preload("res://resources/custom/player_controls/player_6.tres")]

var hold_left: float = 0.0
var hold_right: float = 0.0


func _process(delta):
	if Input.is_action_just_pressed("ui_accept_1") or \
			Input.is_action_just_pressed("ui_accept_2") or \
			Input.is_action_just_pressed("ui_accept_3") or \
			Input.is_action_just_pressed("ui_accept_4") or \
			Input.is_action_just_pressed("ui_accept_5") or \
			Input.is_action_just_pressed("ui_accept_6"):
		press("ui_accept")
	
	if (Input.is_action_just_pressed("ui_cancel_1") or \
			Input.is_action_just_pressed("ui_cancel_2") or \
			Input.is_action_just_pressed("ui_cancel_3") or \
			Input.is_action_just_pressed("ui_cancel_4") or \
			Input.is_action_just_pressed("ui_cancel_5") or \
			Input.is_action_just_pressed("ui_cancel_6")) and \
			get_parent().get_node_or_null("RootSpatial") == null:
		press("ui_cancel")
	
	if Input.is_action_just_pressed("ui_up_1") or \
			Input.is_action_just_pressed("ui_up_2") or \
			Input.is_action_just_pressed("ui_up_3") or \
			Input.is_action_just_pressed("ui_up_4") or \
			Input.is_action_just_pressed("ui_up_5") or \
			Input.is_action_just_pressed("ui_up_6"):
		press("ui_up")
	
	if Input.is_action_just_pressed("ui_down_1") or \
			Input.is_action_just_pressed("ui_down_2") or \
			Input.is_action_just_pressed("ui_down_3") or \
			Input.is_action_just_pressed("ui_down_4") or \
			Input.is_action_just_pressed("ui_down_5") or \
			Input.is_action_just_pressed("ui_down_6"):
		press("ui_down")
	
	if Input.is_action_just_pressed("ui_left_1") or \
			Input.is_action_just_pressed("ui_left_2") or \
			Input.is_action_just_pressed("ui_left_3") or \
			Input.is_action_just_pressed("ui_left_4") or \
			Input.is_action_just_pressed("ui_left_5") or \
			Input.is_action_just_pressed("ui_left_6"):
		hold_left = 0.001
		press("ui_left")
	
	if Input.is_action_just_pressed("ui_right_1") or \
			Input.is_action_just_pressed("ui_right_2") or \
			Input.is_action_just_pressed("ui_right_3") or \
			Input.is_action_just_pressed("ui_right_4") or \
			Input.is_action_just_pressed("ui_right_5") or \
			Input.is_action_just_pressed("ui_right_6"):
		hold_right = 0.001
		press("ui_right")
	
	if hold_left != 0.0:
		if Input.is_action_just_released("ui_left_1") or \
				Input.is_action_just_released("ui_left_2") or \
				Input.is_action_just_released("ui_left_3") or \
				Input.is_action_just_released("ui_left_4") or \
				Input.is_action_just_released("ui_left_5") or \
				Input.is_action_just_released("ui_left_6"):
			hold_left = 0.0
		else:
			hold_left += delta
			if hold_left > 0.2:
				hold_left -= 0.04
				press("ui_left")
	
	if hold_right != 0.0:
		if Input.is_action_just_released("ui_right_1") or \
				Input.is_action_just_released("ui_right_2") or \
				Input.is_action_just_released("ui_right_3") or \
				Input.is_action_just_released("ui_right_4") or \
				Input.is_action_just_released("ui_right_5") or \
				Input.is_action_just_released("ui_right_6"):
			hold_right = 0.0
		else:
			hold_right += delta
			if hold_right > 0.2:
				hold_right -= 0.04
				press("ui_right")
	
	if Input.is_action_just_pressed("ui_cancel") and MenuManager.escape():
		GlobalAudio.play("EscapeAudio")


func press(action: String):
	var input: InputEventAction = InputEventAction.new()
	input.action = action
	input.pressed = true
	Input.parse_input_event(input)
	yield(get_tree(), "idle_frame")
	input.pressed = false
	Input.parse_input_event(input)
