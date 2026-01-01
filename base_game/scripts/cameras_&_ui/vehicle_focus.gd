extends Control


const ROWS: int = 5
const COLUMNS: int = 5

export(int, 1, 6) var number = 1
export var preview_location: NodePath
export var stats: NodePath

var player_controls: PlayerControls
var up: String = "ui_up"
var down: String = "ui_down"
var left: String = "ui_left"
var right: String = "ui_right"
var accept: String = "ui_accept"

onready var vehicle_name: String = get_parent().vehicle_name


func _process(_delta):
	if Input.is_action_just_pressed(up):
		move_vertical(-1)
	if Input.is_action_just_pressed(down):
		move_vertical(1)
	if Input.is_action_just_pressed(left):
		move_horizontal(-1)
	if Input.is_action_just_pressed(right):
		move_horizontal(1)
	if Input.is_action_just_pressed(accept):
		select()


func move_vertical(direction: int):
	var parent: ViewportContainer = get_parent()
	var parent_position: int = parent.get_position_in_parent()
	var hbox: HBoxContainer = parent.get_parent()
	var hbox_position: int = hbox.get_position_in_parent()
	var vbox: VBoxContainer = hbox.get_parent()
	
	while true:
		hbox_position = (hbox_position + direction) % ROWS
		if hbox_position == -1:
			hbox_position = ROWS - 1
		hbox = vbox.get_child(hbox_position)
		var new_parent: Control = hbox.get_child(parent_position)
		if new_parent.name.begins_with("SelectSlot"):
			parent.remove_child(self)
			new_parent.add_child(self)
			update_focus(new_parent)
			break


func move_horizontal(direction: int):
	var parent: ViewportContainer = get_parent()
	var parent_position: int = parent.get_position_in_parent()
	var hbox: HBoxContainer = parent.get_parent()
	
	while true:
		parent_position = (parent_position + direction) % COLUMNS
		if parent_position == -1:
			parent_position = COLUMNS - 1
		var new_parent: Control = hbox.get_child(parent_position)
		if new_parent.name.begins_with("SelectSlot"):
			parent.remove_child(self)
			new_parent.add_child(self)
			update_focus(new_parent)
			break


func select():
	var menu_root: AspectRatioContainer = get_node("../../../../../..")
	menu_root.selected_vehicle[number - 1] = vehicle_name
	menu_root.controls[number - 1] = player_controls
	menu_root.select()


func update_focus(select_slot: SelectSlot):
	vehicle_name = select_slot.vehicle_name
	var path: String = "res://scenes/vehicles/preview/" + vehicle_name \
			+ "_preview.tscn"
	var preview_vehicle: VehicleBody = \
			ResourceLoader.load(path, "PackedScene").instance()
	var vehicle_parent: Spatial = get_node(preview_location)
	for n in vehicle_parent.get_children():
		n.queue_free()
	vehicle_parent.add_child(preview_vehicle)
	
	if stats != "":
		var stats_label: Label = get_node(stats)
		stats_label.update_text(preview_vehicle)


func set_player_controls(controls_array: Array):
	player_controls = controls_array[number - 1]
	if player_controls != null:
		up = player_controls.ui_up
		down = player_controls.ui_down
		left = player_controls.ui_left
		right = player_controls.ui_right
		accept = player_controls.ui_accept
