extends ColorRect


const Inputs1: Resource \
		= preload("res://resources/custom/player_controls/player_1.tres")
const Inputs2: Resource \
		= preload("res://resources/custom/player_controls/player_2.tres")
const Inputs3: Resource \
		= preload("res://resources/custom/player_controls/player_3.tres")
const Inputs4: Resource \
		= preload("res://resources/custom/player_controls/player_4.tres")
const Inputs5: Resource \
		= preload("res://resources/custom/player_controls/player_5.tres")
const Inputs6: Resource \
		= preload("res://resources/custom/player_controls/player_6.tres")
const Vehicle_select: PackedScene \
		= preload("res://scenes/cameras_&_ui/vehicle_select.tscn")

var active: bool = false
var next: ColorRect
var already_used: Array = Array()


func _process(_delta):
	if active:
		if not already_used.has(1):
			for n in to_array(Inputs1):
				if Input.is_action_just_released(n):
					var next_select: Control = Vehicle_select.instance()
					next_select.get_node("BlackBar").controls = load(\
							"res://resources/custom/player_controls/player_1.tres")
					next_select.get_node("BlackBar").anchor_left = anchor_left
					get_parent().get_parent().add_child(next_select)
					if next != null:
						already_used.append(1)
						next.already_used = already_used
						next.active = true
					get_parent().queue_free()
					return
		if not already_used.has(2):
			for n in to_array(Inputs2):
				if Input.is_action_pressed(n):
					var next_select: Control = Vehicle_select.instance()
					next_select.get_node("BlackBar").controls = load(\
							"res://resources/custom/player_controls/player_2.tres")
					next_select.get_node("BlackBar").anchor_left = anchor_left
					get_parent().get_parent().add_child(next_select)
					if next != null:
						already_used.append(2)
						next.already_used = already_used
						next.active = true
					get_parent().queue_free()
					return
		if not already_used.has(3):
			for n in to_array(Inputs3):
				if Input.is_action_just_released(n):
					var next_select: Control = Vehicle_select.instance()
					next_select.get_node("BlackBar").controls = load(\
							"res://resources/custom/player_controls/player_3.tres")
					next_select.get_node("BlackBar").anchor_left = anchor_left
					get_parent().get_parent().add_child(next_select)
					if next != null:
						already_used.append(3)
						next.already_used = already_used
						next.active = true
					get_parent().queue_free()
					return
		if not already_used.has(4):
			for n in to_array(Inputs4):
				if Input.is_action_just_released(n):
					var next_select: Control = Vehicle_select.instance()
					next_select.get_node("BlackBar").controls = load(\
							"res://resources/custom/player_controls/player_4.tres")
					next_select.get_node("BlackBar").anchor_left = anchor_left
					get_parent().get_parent().add_child(next_select)
					if next != null:
						already_used.append(4)
						next.already_used = already_used
						next.active = true
					get_parent().queue_free()
					return
		if not already_used.has(5):
			for n in to_array(Inputs5):
				if Input.is_action_just_released(n):
					var next_select: Control = Vehicle_select.instance()
					next_select.get_node("BlackBar").controls = load(\
							"res://resources/custom/player_controls/player_55.tres")
					next_select.get_node("BlackBar").anchor_left = anchor_left
					get_parent().get_parent().add_child(next_select)
					if next != null:
						already_used.append(5)
						next.already_used = already_used
						next.active = true
					get_parent().queue_free()
					return
		if not already_used.has(6):
			for n in to_array(Inputs6):
				if Input.is_action_just_released(n):
					var next_select: Control = Vehicle_select.instance()
					next_select.get_node("BlackBar").controls = load(\
							"res://resources/custom/player_controls/player_6.tres")
					next_select.get_node("BlackBar").anchor_left = anchor_left
					get_parent().get_parent().add_child(next_select)
					if next != null:
						already_used.append(6)
						next.already_used = already_used
						next.active = true
					get_parent().queue_free()
					return
		$VBoxContainer/ChooseInput.show()
		$VBoxContainer/Wait.hide()
	else:
		$VBoxContainer/ChooseInput.hide()
		$VBoxContainer/Wait.show()


func to_array(var controls: PlayerControls) -> Array:
	var a: Array = Array()
	a.append(controls.accelerate)
	a.append(controls.reverse)
	a.append(controls.turn_left)
	a.append(controls.turn_right)
	a.append(controls.weapon_front)
	a.append(controls.weapon_back)
	a.append(controls.weapon_left)
	a.append(controls.weapon_right)
	a.append(controls.boost)
	a.append(controls.drift)
	a.append(controls.respawn)
	a.append(controls.ui_accept)
	a.append(controls.ui_cancel)
	a.append(controls.ui_up)
	a.append(controls.ui_down)
	a.append(controls.ui_left)
	a.append(controls.ui_right)
	return a
