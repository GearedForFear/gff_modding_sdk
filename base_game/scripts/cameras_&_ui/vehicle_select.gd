class_name VehicleSelect
extends ColorRect


enum category_names {NITRO, ROCKET, SWITCH, BURST, OVERCHARGE}

var controls: PlayerControls
var categories: Array
var current_category: int = 0
var current_vehicle: int = 0

onready var unlocked: Array = [get_node("Nitro/ChainsAwe"), \
		get_node("Nitro/SuicideDoor"), get_node("Nitro/GraveMistake"), \
		get_node("Rocket/WarmWelcome"), get_node("Rocket/Turbulence"), \
		get_node("Rocket/EternalBond"), get_node("Switch/Restless"), \
		get_node("Burst/WellRaised")]


func _ready():
	categories.append_array(get_children())


func _process(_delta):
	if Input.is_action_just_pressed(controls.ui_right):
		current_category = (current_category + 1) % categories.size()
		for n in categories:
			n.hide()
		categories[current_category].show()
		if current_vehicle > categories[current_category].get_child_count() - 2:
			current_vehicle = categories[current_category].get_child_count() - 2
		update_selection()
		get_node("../LeftRightAudio").play()
	
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
		get_node("../LeftRightAudio").play()
	
	if Input.is_action_just_pressed(controls.ui_down):
		current_vehicle = (current_vehicle + 1) \
				% (categories[current_category].get_child_count() - 1)
		update_selection()
		get_node("../UpDownAudio").play()
	
	if Input.is_action_just_pressed(controls.ui_up):
		current_vehicle -= 1
		if current_vehicle == -1:
			current_vehicle = categories[current_category].get_child_count() - 2
		update_selection()
		get_node("../UpDownAudio").play()
	
	if Input.is_action_just_pressed(controls.ui_accept):
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
					2:
						vehicle = ResourceLoader.load(\
								"res://scenes/vehicles/grave_mistake.tscn", \
								"PackedScene").instance()
					4:
						return#vehicle = ResourceLoader.load(\
								#"res://scenes/vehicles/fungibber.tscn", \
								#"PackedScene").instance()
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
				match current_vehicle:
					0:
						vehicle = ResourceLoader.load(\
								"res://scenes/vehicles/well_raised.tscn", \
								"PackedScene").instance()
					_:
						return
			category_names.OVERCHARGE:
				return
		vehicle.get_node("Body").controls = controls
		vehicle.get_node("Body").track = get_node("../../../..")
		get_node("../../Viewport").stop()
		get_node("../../Viewport/SpawnPosition").add_child(vehicle)
		get_parent().queue_free()
	
	if Input.is_action_just_pressed(controls.ui_cancel):
		get_node("/root/RootControl").track.queue_free()
		get_node("/root/RootControl").active(true)
		get_node("/root/RootControl/ReturnAudio").play()


func update_selection():
	for n in categories[current_category].get_children():
		if n.name != "Category":
			n.modulate = Color("fd5602")
	var selection: Label = categories[current_category]\
			.get_child(current_vehicle + 1)
	if unlocked.has(selection):
		selection.modulate = Color.white
	else:
		selection.modulate = Color("960000")
	get_node("../ViewportContainer/Viewport/Spatial").update_vehicle(\
			current_category, current_vehicle)
	get_node("../Name").text = selection.text
	get_node("../PageNumber").text = "Page " + String(current_category + 1) \
			+ "/5"
