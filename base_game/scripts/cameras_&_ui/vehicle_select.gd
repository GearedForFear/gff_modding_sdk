extends ColorRect


enum category_names {NITRO, ROCKET, SWITCH, BURST, OVERCHARGE}

var control_setup: int
var controls: PlayerControls
var categories: Array
var current_category: int = 0
var current_vehicle: int = 0

onready var unlocked: Array = [get_node("Nitro/SuicideDoor"), \
		get_node("Rocket/WarmWelcome"), get_node("Switch/Restless")]


func _ready():
	categories.append_array(get_children())
	
	current_category = (current_category + 1) % categories.size()
	for n in categories:
		n.hide()
	categories[current_category].show()
	if current_vehicle > categories[current_category].get_child_count() - 2:
		current_vehicle = categories[current_category].get_child_count() - 2
	update_selection()


func _process(_delta):
	if Input.is_action_just_pressed(controls.ui_right):
		current_category = (current_category + 1) % categories.size()
		for n in categories:
			n.hide()
		categories[current_category].show()
		if current_vehicle > categories[current_category].get_child_count() - 2:
			current_vehicle = categories[current_category].get_child_count() - 2
		update_selection()
	
	if Input.is_action_just_pressed(controls.ui_left):
		current_category -= 1
		if current_category == -1:
			current_category = categories.size() - 1
		for n in categories:
			n.hide()
		categories[current_category].show()
		if current_vehicle > categories[current_category].get_child_count() - 2:
			current_vehicle = categories[current_category].get_child_count() - 2
		update_selection()
	
	if Input.is_action_just_pressed(controls.ui_down):
		current_vehicle = (current_vehicle + 1) \
				% (categories[current_category].get_child_count() - 1)
		update_selection()
	
	if Input.is_action_just_pressed(controls.ui_up):
		current_vehicle -= 1
		if current_vehicle == -1:
			current_vehicle = categories[current_category].get_child_count() - 2
		update_selection()
	
	if Input.is_action_just_pressed(controls.ui_accept):
		get_node("/root/RootControl").new_track_instantiated = false
		var vehicle: Spatial
		match current_category:
			category_names.NITRO:
				match current_vehicle:
					0:
						vehicle = ResourceLoader.load(\
								"res://scenes/vehicles/chains_awe.tscn", \
								"PackedScene").instance()
					1:
						vehicle = ResourceLoader.load(\
								"res://scenes/vehicles/suicide_door.tscn", \
								"PackedScene").instance()
					4:
						vehicle = ResourceLoader.load(\
								"res://scenes/vehicles/fungibber.tscn", \
								"PackedScene").instance()
					_:
						return
			category_names.ROCKET:
				match current_vehicle:
					0:
						vehicle = ResourceLoader.load(\
								"res://scenes/vehicles/warm_welcome.tscn", \
								"PackedScene").instance()
					1:
						vehicle = ResourceLoader.load(\
								"res://scenes/vehicles/turbulence.tscn", \
								"PackedScene").instance()
					2:
						vehicle = ResourceLoader.load(\
								"res://scenes/vehicles/eternal_bond.tscn", \
								"PackedScene").instance()
					_:
						return
			category_names.SWITCH:
				match current_vehicle:
					0:
						vehicle = ResourceLoader.load(\
								"res://scenes/vehicles/restless.tscn", \
								"PackedScene").instance()
					_:
						return
			category_names.BURST:
				return
			category_names.OVERCHARGE:
				return
		vehicle.get_node("Body").controls = controls
		vehicle.get_node("Body").track = get_node("../../../..")
		get_node("../../Viewport/SpawnPosition").add_child(vehicle)
		get_parent().queue_free()
	
	if Input.is_action_just_pressed(controls.ui_cancel):
		get_node("/root/RootControl").track.queue_free()
		get_node("/root/RootControl").new_track_instantiated = false
		get_node("/root/RootControl").active(true)


func update_selection():
	for n in categories[current_category].get_children():
		if n.name != "Category":
			n.modulate = Color("fd5602")
	var selection: Label = categories[current_category]\
			.get_child(current_vehicle + 1)
	if unlocked.has(selection):
		selection.modulate = Color("ffe600")
	else:
		selection.modulate = Color("960000")
	get_node("../PageNumber").text = "Page " + String(current_category + 1) \
			+ "/5"
