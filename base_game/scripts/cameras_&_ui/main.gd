extends Control


var track: Spatial
var resources_loaded: bool = false
var new_track_instantiated: bool = false

onready var always_loaded: Array = ResourceLoader.load(\
		"res://resources/custom/always_loaded.tres", "Resource").array
onready var thread: Thread = Thread.new()


func _ready():
	var directory: Directory = Directory.new()
	if directory.open("user://mods") == OK and directory.list_dir_begin() == OK:
		var next_mod: String = directory.get_next()
		while next_mod != "":
			if ProjectSettings.load_resource_pack("user://mods/" + next_mod):
				var mod_scene: Node = load("res://scenes/mod.tscn").instance()
				add_child(mod_scene)
				mod_scene.modify()
			next_mod = directory.get_next()
	
	VisualServer.set_default_clear_color(Color.black)
	if thread.start(self, "prepare") != OK:
		push_error("Thread did not start!")
	$BlackBar/MainButtons/OnePlayer.grab_focus()


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
	
	if Input.is_action_just_pressed("ui_cancel_1") or \
			Input.is_action_just_pressed("ui_cancel_2") or \
			Input.is_action_just_pressed("ui_cancel_3") or \
			Input.is_action_just_pressed("ui_cancel_4") or \
			Input.is_action_just_pressed("ui_cancel_5") or \
			Input.is_action_just_pressed("ui_cancel_6"):
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
	
	if Input.is_action_just_released("ui_cancel"):
		if $BlackBar/MainButtons.visible:
			get_tree().quit()
		elif $BlackBar/SettingsButtons.visible:
			$CurrentSettings.hide()
			switch_buttons($BlackBar/SettingsButtons, $BlackBar/MainButtons)
		elif $BlackBar/GraphicsButtons.visible:
			switch_buttons($BlackBar/GraphicsButtons, $BlackBar/SettingsButtons)
		elif $BlackBar/WindowModesButtons.visible:
			switch_buttons($BlackBar/WindowModesButtons, \
					$BlackBar/GraphicsButtons)
		elif $BlackBar/ResolutionButtons.visible:
			switch_buttons($BlackBar/ResolutionButtons, \
					$BlackBar/GraphicsButtons)
		elif $BlackBar/MSAAButtons.visible:
			switch_buttons($BlackBar/MSAAButtons, $BlackBar/GraphicsButtons)
		elif $BlackBar/ViewDistanceButtons.visible:
			switch_buttons($BlackBar/ViewDistanceButtons, \
					$BlackBar/GraphicsButtons)
		elif $BlackBar/RearViewDistanceButtons.visible:
			switch_buttons($BlackBar/RearViewDistanceButtons, \
					$BlackBar/GraphicsButtons)
		elif $BlackBar/FieldOfViewButtons.visible:
			switch_buttons($BlackBar/FieldOfViewButtons, \
					$BlackBar/GraphicsButtons)
		elif $BlackBar/ShadowAmountButtons.visible:
			switch_buttons($BlackBar/ShadowAmountButtons, \
					$BlackBar/GraphicsButtons)
		elif $BlackBar/MaxRigidBodiesButtons.visible:
			switch_buttons($BlackBar/MaxRigidBodiesButtons, \
					$BlackBar/GraphicsButtons)


func prepare():
	if not resources_loaded:
		var resources: Array = Array()
		for n in always_loaded:
			resources.append(ResourceLoader.load(n, "PackedScene"))
		always_loaded.clear()
		always_loaded.append_array(resources)
		resources_loaded = true
	track = ResourceLoader.load("res://scenes/world/tracks/figure_8.tscn", \
			"PackedScene").instance()
	var spawns: Array = Array()
	spawns.append(track.get_node("StartSpawns/SpawnPoint7/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint8/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint9/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint10/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint11/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint12/SpawnPosition"))
	instantiate_vehicles(spawns, 0)
	new_track_instantiated = true


func play(player_amount: int):
	$BlackBar/MainButtons.hide()
	while not new_track_instantiated:
		yield(get_tree(), "idle_frame")
	if thread.is_active():
		thread.wait_to_finish()
	
	var viewpoint_container: PlayerContainer
	var screen1: Control
	var screen2: Control
	var screen3: Control
	var screen4: Control
	var screen5: Control
	var screen6: Control
	var controller_select: PackedScene = ResourceLoader.load(\
			"res://scenes/cameras_&_ui/controller_select.tscn", "PackedScene")
	var spawns: Array = Array()
	
	match player_amount:
		1:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 1
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			add_child(track)
			
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint2/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint3/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint4/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint5/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		2:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(1, 2)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			screen1.get_node("BlackBar").next = screen2.get_node("BlackBar")
			
			add_child(track)
			
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint3/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint4/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint5/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		3:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(2, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			screen3 = controller_select.instance()
			viewpoint_container.add_child(screen3)
			viewpoint_container.show()
			
			screen1.get_node("BlackBar").next = screen2.get_node("BlackBar")
			screen2.get_node("BlackBar").next = screen3.get_node("BlackBar")
			
			add_child(track)
			
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint4/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint5/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		4:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(2, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(2, 1)
			screen3 = controller_select.instance()
			viewpoint_container.add_child(screen3)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			screen4 = controller_select.instance()
			viewpoint_container.add_child(screen4)
			viewpoint_container.show()
			
			screen1.get_node("BlackBar").next = screen2.get_node("BlackBar")
			screen2.get_node("BlackBar").next = screen3.get_node("BlackBar")
			screen3.get_node("BlackBar").next = screen4.get_node("BlackBar")
			
			add_child(track)
			
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint5/Viewport/SpawnPosition"))
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		5:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 3
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(3, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 2)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			screen3 = controller_select.instance()
			viewpoint_container.add_child(screen3)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(2, 1)
			screen4 = controller_select.instance()
			viewpoint_container.add_child(screen4)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint5")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			screen5 = controller_select.instance()
			viewpoint_container.add_child(screen5)
			viewpoint_container.show()
			
			screen1.get_node("BlackBar").next = screen2.get_node("BlackBar")
			screen2.get_node("BlackBar").next = screen3.get_node("BlackBar")
			screen3.get_node("BlackBar").next = screen4.get_node("BlackBar")
			screen4.get_node("BlackBar").next = screen5.get_node("BlackBar")
			
			add_child(track)
			
			spawns.append(track.get_node(\
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		6:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 3
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(3, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 2)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			screen3 = controller_select.instance()
			viewpoint_container.add_child(screen3)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(3, 1)
			screen4 = controller_select.instance()
			viewpoint_container.add_child(screen4)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint5")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 1)
			screen5 = controller_select.instance()
			viewpoint_container.add_child(screen5)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint6")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			screen6 = controller_select.instance()
			viewpoint_container.add_child(screen6)
			viewpoint_container.show()
			
			screen1.get_node("BlackBar").next = screen2.get_node("BlackBar")
			screen2.get_node("BlackBar").next = screen3.get_node("BlackBar")
			screen3.get_node("BlackBar").next = screen4.get_node("BlackBar")
			screen4.get_node("BlackBar").next = screen5.get_node("BlackBar")
			screen5.get_node("BlackBar").next = screen6.get_node("BlackBar")
			
			add_child(track)
	
	active(false)
	instantiate_vehicles(spawns, 0)


func active(var b: bool):
	if b and thread.start(self, "prepare"):
		push_error("Thread did not start!")
	$BlackBar/MainButtons/OnePlayer.grab_focus()
	visible = b
	$BlackBar/MainButtons.visible = b
	set_process(b)
	for n in $BlackBar/MainButtons.get_children():
		n.disabled = not b
	if(b):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func instantiate_vehicles(var spawns: Array, var first_vehicle: int):
	var next_vehicle: int = first_vehicle
	for n in spawns:
		var vehicle: Spatial
		match next_vehicle:
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
						"res://scenes/vehicles/warm_welcome.tscn", \
						"PackedScene").instance()
			3:
				vehicle = ResourceLoader.load(\
						"res://scenes/vehicles/turbulence.tscn", \
						"PackedScene").instance()
			4:
				vehicle = ResourceLoader.load(\
						"res://scenes/vehicles/eternal_bond.tscn", \
						"PackedScene").instance()
			5:
				vehicle = ResourceLoader.load(\
						"res://scenes/vehicles/restless.tscn", \
						"PackedScene").instance()
		next_vehicle = (next_vehicle + 1) % 6
		vehicle.get_node("Body").track = track
		n.add_child(vehicle)


func switch_buttons(var from: BoxContainer, var to: BoxContainer):
	from.hide()
	to.show()
	if to.get_child(0).is_class("Button"):
		to.get_child(0).grab_focus()
	else:
		to.get_child(0).get_child(0).grab_focus()


func _on_OnePlayer_pressed():
	play(1)


func _on_TwoPlayers_pressed():
	play(2)


func _on_ThreePlayers_pressed():
	play(3)


func _on_FourPlayers_pressed():
	play(4)


func _on_FivePlayers_pressed():
	play(5)


func _on_SixPlayers_pressed():
	play(6)


func _on_Settings_pressed():
	$CurrentSettings.show()
	switch_buttons($BlackBar/MainButtons, $BlackBar/SettingsButtons)


func _on_Graphics_pressed():
	switch_buttons($BlackBar/SettingsButtons, $BlackBar/GraphicsButtons)


func _on_WindowModes_pressed():
	switch_buttons($BlackBar/GraphicsButtons, $BlackBar/WindowModesButtons)


func _on_Resolution_pressed():
	switch_buttons($BlackBar/GraphicsButtons, $BlackBar/ResolutionButtons)


func _on_MSAA_pressed():
	switch_buttons($BlackBar/GraphicsButtons, $BlackBar/MSAAButtons)


func _on_ToggleVsync_pressed():
	OS.vsync_enabled = !OS.vsync_enabled


func _on_ViewDistance_pressed():
	switch_buttons($BlackBar/GraphicsButtons, $BlackBar/ViewDistanceButtons)


func _on_RearViewDistance_pressed():
	switch_buttons($BlackBar/GraphicsButtons, $BlackBar/RearViewDistanceButtons)


func _on_FieldOfView_pressed():
	switch_buttons($BlackBar/GraphicsButtons, $BlackBar/FieldOfViewButtons)


func _on_ShadowAmount_pressed():
	switch_buttons($BlackBar/GraphicsButtons, $BlackBar/ShadowAmountButtons)


func _on_MaxRigidBodies_pressed():
	switch_buttons($BlackBar/GraphicsButtons, $BlackBar/MaxRigidBodiesButtons)


func _on_Default_pressed():
	OS.window_borderless = false
	OS.window_fullscreen = false
	switch_buttons($BlackBar/WindowModesButtons, $BlackBar/GraphicsButtons)


func _on_Borderless_pressed():
	OS.window_borderless = true
	OS.window_fullscreen = false
	switch_buttons($BlackBar/WindowModesButtons, $BlackBar/GraphicsButtons)


func _on_Fullscreen_pressed():
	OS.window_borderless = false
	OS.window_fullscreen = true
	switch_buttons($BlackBar/WindowModesButtons, $BlackBar/GraphicsButtons)


func _on_Resolution1_pressed():
	get_node("/root/RootControl/SettingsManager").resolution = 1
	switch_buttons($BlackBar/ResolutionButtons, $BlackBar/GraphicsButtons)


func _on_Resolution2_pressed():
	get_node("/root/RootControl/SettingsManager").resolution = 2
	switch_buttons($BlackBar/ResolutionButtons, $BlackBar/GraphicsButtons)


func _on_Resolution3_pressed():
	get_node("/root/RootControl/SettingsManager").resolution = 3
	switch_buttons($BlackBar/ResolutionButtons, $BlackBar/GraphicsButtons)


func _on_Resolution4_pressed():
	get_node("/root/RootControl/SettingsManager").resolution = 4
	switch_buttons($BlackBar/ResolutionButtons, $BlackBar/GraphicsButtons)


func _on_Resolution5_pressed():
	get_node("/root/RootControl/SettingsManager").resolution = 5
	switch_buttons($BlackBar/ResolutionButtons, $BlackBar/GraphicsButtons)


func _on_Resolution6_pressed():
	get_node("/root/RootControl/SettingsManager").resolution = 6
	switch_buttons($BlackBar/ResolutionButtons, $BlackBar/GraphicsButtons)


func _on_MSAAOff_pressed():
	get_node("/root/RootControl/SettingsManager").msaa = 0
	switch_buttons($BlackBar/MSAAButtons, $BlackBar/GraphicsButtons)


func _on_2x_pressed():
	get_node("/root/RootControl/SettingsManager").msaa = 1
	switch_buttons($BlackBar/MSAAButtons, $BlackBar/GraphicsButtons)


func _on_4x_pressed():
	get_node("/root/RootControl/SettingsManager").msaa = 2
	switch_buttons($BlackBar/MSAAButtons, $BlackBar/GraphicsButtons)


func _on_8x_pressed():
	get_node("/root/RootControl/SettingsManager").msaa = 3
	switch_buttons($BlackBar/MSAAButtons, $BlackBar/GraphicsButtons)


func _on_16x_pressed():
	get_node("/root/RootControl/SettingsManager").msaa = 4
	switch_buttons($BlackBar/MSAAButtons, $BlackBar/GraphicsButtons)


func _on_View100_pressed():
	get_node("/root/RootControl/SettingsManager").view_distance = 100.0
	switch_buttons($BlackBar/ViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_View200_pressed():
	get_node("/root/RootControl/SettingsManager").view_distance = 200.0
	switch_buttons($BlackBar/ViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_View350_pressed():
	get_node("/root/RootControl/SettingsManager").view_distance = 350.0
	switch_buttons($BlackBar/ViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_View500_pressed():
	get_node("/root/RootControl/SettingsManager").view_distance = 500.0
	switch_buttons($BlackBar/ViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_View750_pressed():
	get_node("/root/RootControl/SettingsManager").view_distance = 750.0
	switch_buttons($BlackBar/ViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_View1000_pressed():
	get_node("/root/RootControl/SettingsManager").view_distance = 1000.0
	switch_buttons($BlackBar/ViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_View2000_pressed():
	get_node("/root/RootControl/SettingsManager").view_distance = 2000.0
	switch_buttons($BlackBar/ViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_Rear25_pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance = 25.0
	switch_buttons($BlackBar/RearViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_Rear50_pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance = 50.0
	switch_buttons($BlackBar/RearViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_Rear100_pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance = 100.0
	switch_buttons($BlackBar/RearViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_Rear200_pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance = 200.0
	switch_buttons($BlackBar/RearViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_Rear350_pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance = 350.0
	switch_buttons($BlackBar/RearViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_Rear500_pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance = 500.0
	switch_buttons($BlackBar/RearViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_Rear750_pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance = 750.0
	switch_buttons($BlackBar/RearViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_Rear1000_pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance = 1000.0
	switch_buttons($BlackBar/RearViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_Rear2000_pressed():
	get_node("/root/RootControl/SettingsManager").rear_view_distance = 2000.0
	switch_buttons($BlackBar/RearViewDistanceButtons, $BlackBar/GraphicsButtons)


func _on_FOV45_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 45.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV50_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 50.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV55_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 55.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV60_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 60.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV65_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 65.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV70_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 70.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV75_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 75.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV80_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 80.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV85_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 85.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV90_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 90.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV95_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 95.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV100_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 100.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV105_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 105.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV110_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 110.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV115_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 115.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV120_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 120.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV125_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 125.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV130_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 130.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV135_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 135.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV140_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 140.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_FOV145_pressed():
	get_node("/root/RootControl/SettingsManager").field_of_view = 145.0
	switch_buttons($BlackBar/FieldOfViewButtons, $BlackBar/GraphicsButtons)


func _on_ShadowAmountNone_pressed():
	get_node("/root/RootControl/SettingsManager").shadow_amount = 0
	switch_buttons($BlackBar/ShadowAmountButtons, $BlackBar/GraphicsButtons)


func _on_ShadowAmountExtraLow_pressed():
	get_node("/root/RootControl/SettingsManager").shadow_amount = 1
	switch_buttons($BlackBar/ShadowAmountButtons, $BlackBar/GraphicsButtons)


func _on_ShadowAmountLow_pressed():
	get_node("/root/RootControl/SettingsManager").shadow_amount = 2
	switch_buttons($BlackBar/ShadowAmountButtons, $BlackBar/GraphicsButtons)


func _on_ShadowAmountDefault_pressed():
	get_node("/root/RootControl/SettingsManager").shadow_amount = 3
	switch_buttons($BlackBar/ShadowAmountButtons, $BlackBar/GraphicsButtons)


func _on_ShadowAmountHigh_pressed():
	get_node("/root/RootControl/SettingsManager").shadow_amount = 4
	switch_buttons($BlackBar/ShadowAmountButtons, $BlackBar/GraphicsButtons)


func _on_ShadowAmountUltimate_pressed():
	get_node("/root/RootControl/SettingsManager").shadow_amount = 5
	switch_buttons($BlackBar/ShadowAmountButtons, $BlackBar/GraphicsButtons)


func _on_RigidLowest_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 0
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)


func _on_Rigid50_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 50
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)


func _on_Rigid100_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 100
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)


func _on_Rigid200_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 200
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)


func _on_Rigid350_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 350
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)


func _on_Rigid500_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 500
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)


func _on_Rigid750_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 750
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)


func _on_Rigid1000_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 1000
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)


func _on_Rigid4000_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 4000
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)


func _on_Rigid10000_pressed():
	get_node("/root/RootControl/SettingsManager").max_rigid_bodies = 10000
	switch_buttons($BlackBar/MaxRigidBodiesButtons, $BlackBar/GraphicsButtons)
