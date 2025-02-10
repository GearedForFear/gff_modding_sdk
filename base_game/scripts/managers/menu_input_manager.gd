extends Node


var can_cancel: bool = true


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept_1") or \
			Input.is_action_just_pressed("ui_accept_2") or \
			Input.is_action_just_pressed("ui_accept_3") or \
			Input.is_action_just_pressed("ui_accept_4") or \
			Input.is_action_just_pressed("ui_accept_5") or \
			Input.is_action_just_pressed("ui_accept_6"):
		var input: InputEventAction = InputEventAction.new()
		input.action = "ui_accept"
		input.pressed = true
		Input.parse_input_event(input)
		yield(get_tree(), "idle_frame")
		input.pressed = false
		Input.parse_input_event(input)
	
	if (Input.is_action_just_pressed("ui_cancel_1") or \
			Input.is_action_just_pressed("ui_cancel_2") or \
			Input.is_action_just_pressed("ui_cancel_3") or \
			Input.is_action_just_pressed("ui_cancel_4") or \
			Input.is_action_just_pressed("ui_cancel_5") or \
			Input.is_action_just_pressed("ui_cancel_6")) and \
			get_parent().get_node_or_null("RootSpatial") == null:
		var input: InputEventAction = InputEventAction.new()
		input.action = "ui_cancel"
		input.pressed = true
		Input.parse_input_event(input)
		yield(get_tree(), "idle_frame")
		input.pressed = false
		Input.parse_input_event(input)
	
	if Input.is_action_just_pressed("ui_up_1") or \
			Input.is_action_just_pressed("ui_up_2") or \
			Input.is_action_just_pressed("ui_up_3") or \
			Input.is_action_just_pressed("ui_up_4") or \
			Input.is_action_just_pressed("ui_up_5") or \
			Input.is_action_just_pressed("ui_up_6"):
		var input: InputEventAction = InputEventAction.new()
		input.action = "ui_up"
		input.pressed = true
		Input.parse_input_event(input)
		yield(get_tree(), "idle_frame")
		input.pressed = false
		Input.parse_input_event(input)
	
	if Input.is_action_just_pressed("ui_down_1") or \
			Input.is_action_just_pressed("ui_down_2") or \
			Input.is_action_just_pressed("ui_down_3") or \
			Input.is_action_just_pressed("ui_down_4") or \
			Input.is_action_just_pressed("ui_down_5") or \
			Input.is_action_just_pressed("ui_down_6"):
		var input: InputEventAction = InputEventAction.new()
		input.action = "ui_down"
		input.pressed = true
		Input.parse_input_event(input)
		yield(get_tree(), "idle_frame")
		input.pressed = false
		Input.parse_input_event(input)
	
	if Input.is_action_just_pressed("ui_left_1") or \
			Input.is_action_just_pressed("ui_left_2") or \
			Input.is_action_just_pressed("ui_left_3") or \
			Input.is_action_just_pressed("ui_left_4") or \
			Input.is_action_just_pressed("ui_left_5") or \
			Input.is_action_just_pressed("ui_left_6"):
		var input: InputEventAction = InputEventAction.new()
		input.action = "ui_left"
		input.pressed = true
		Input.parse_input_event(input)
		yield(get_tree(), "idle_frame")
		input.pressed = false
		Input.parse_input_event(input)
	
	if Input.is_action_just_pressed("ui_right_1") or \
			Input.is_action_just_pressed("ui_right_2") or \
			Input.is_action_just_pressed("ui_right_3") or \
			Input.is_action_just_pressed("ui_right_4") or \
			Input.is_action_just_pressed("ui_right_5") or \
			Input.is_action_just_pressed("ui_right_6"):
		var input: InputEventAction = InputEventAction.new()
		input.action = "ui_right"
		input.pressed = true
		Input.parse_input_event(input)
		yield(get_tree(), "idle_frame")
		input.pressed = false
		Input.parse_input_event(input)
	
	if get_parent().visible:
		if Input.is_action_just_pressed("ui_accept") \
				and get_node("../AspectRatioContainer/ArcadeEnd").visible:
			get_node("../AspectRatioContainer/ArcadeEnd").hide()
			var menu: Control = get_node("../AspectRatioContainer/MainMenu")
			menu.show()
			menu.get_node("Arcade").grab_focus()
			get_node("../ButtonPressAudio").play()
		
		if Input.is_action_just_pressed("ui_cancel") and can_cancel:
			can_cancel = false
			var sound: AudioStreamPlayer = get_node("../ReturnAudio")
			if get_node("../AspectRatioContainer/MainMenu").visible:
				get_tree().quit()
			elif get_node("../AspectRatioContainer/TrackMenu").visible:
				get_node("../AspectRatioContainer/TrackMenu").hide()
				var menu: Control = get_node("../AspectRatioContainer/MainMenu")
				menu.show()
				menu.get_node("SingleTrack").grab_focus()
				sound.play()
			elif get_node("../AspectRatioContainer/OptionsMenu").visible:
				get_node("../AspectRatioContainer/OptionsMenu").hide()
				var menu: Control = get_node("../AspectRatioContainer/MainMenu")
				menu.show()
				menu.get_node("Options").grab_focus()
				sound.play()
			elif get_node("../ResolutionMenu").visible:
				get_node("../ResolutionMenu").hide()
				var menu: Control = get_node("../AspectRatioContainer/OptionsMenu")
				menu.show()
				menu.get_node("Buttons/Resolution").grab_focus()
				sound.play()
			elif get_node("../FOVMenu").visible:
				get_node("../FOVMenu").hide()
				var menu: Control = get_node("../AspectRatioContainer/OptionsMenu")
				menu.show()
				menu.get_node("Buttons/FieldOfView").grab_focus()
				sound.play()
			elif get_node("../AspectRatioContainer/WindowModeMenu").visible:
				get_node("../AspectRatioContainer/WindowModeMenu").hide()
				var menu: Control = get_node("../AspectRatioContainer/OptionsMenu")
				menu.show()
				menu.get_node("Buttons/WindowMode").grab_focus()
				sound.play()
			elif get_node("../AspectRatioContainer/SoundMenu").visible:
				get_node("../AspectRatioContainer/SoundMenu").hide()
				var menu: Control = get_node("../AspectRatioContainer/OptionsMenu")
				menu.show()
				menu.get_node("Buttons/Sound").grab_focus()
				sound.play()
			elif get_node("../AspectRatioContainer/AdvancedMenu").visible:
				get_node("../AspectRatioContainer/AdvancedMenu").hide()
				var menu: Control = get_node("../AspectRatioContainer/OptionsMenu")
				menu.show()
				menu.get_node("Buttons/Advanced").grab_focus()
				sound.play()
			elif get_node("../AspectRatioContainer/ArcadeEnd").visible:
				get_node("../AspectRatioContainer/ArcadeEnd").hide()
				var menu: Control = get_node("../AspectRatioContainer/MainMenu")
				menu.show()
				menu.get_node("Arcade").grab_focus()
				sound.play()
		else:
			can_cancel = true
