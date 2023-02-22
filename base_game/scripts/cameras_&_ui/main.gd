extends Control


var track: Spatial
var resources_loaded: bool = false
var player_amount: int

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
	AudioServer.set_bus_volume_db(1, linear2db(0.5))
	AudioServer.set_bus_volume_db(2, linear2db(0.5))
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
			switch_buttons($BlackBar/SettingsButtons, \
					$BlackBar/MainButtons/Settings)
			$ReturnAudio.play()
		elif $BlackBar/GraphicsButtons.visible:
			$BlackBar/Warning.hide()
			switch_buttons($BlackBar/GraphicsButtons, \
					$BlackBar/SettingsButtons/Graphics)
			$ReturnAudio.play()
		elif $BlackBar/WindowModesButtons.visible:
			switch_buttons($BlackBar/WindowModesButtons, \
					$BlackBar/GraphicsButtons/WindowModes)
			$ReturnAudio.play()
		elif $BlackBar/ResolutionButtons.visible:
			switch_buttons($BlackBar/ResolutionButtons, \
					$BlackBar/GraphicsButtons/Resolution)
			$ReturnAudio.play()
		elif $BlackBar/MSAAButtons.visible:
			switch_buttons($BlackBar/MSAAButtons, \
					$BlackBar/GraphicsButtons/MSAA)
			$ReturnAudio.play()
		elif $BlackBar/ViewDistanceButtons.visible:
			switch_buttons($BlackBar/ViewDistanceButtons, \
					$BlackBar/GraphicsButtons/ViewDistance)
			$ReturnAudio.play()
		elif $BlackBar/RearViewDistanceButtons.visible:
			switch_buttons($BlackBar/RearViewDistanceButtons, \
					$BlackBar/GraphicsButtons/RearViewDistance)
			$ReturnAudio.play()
		elif $BlackBar/FieldOfViewButtons.visible:
			switch_buttons($BlackBar/FieldOfViewButtons, \
					$BlackBar/GraphicsButtons/FieldOfView)
			$ReturnAudio.play()
		elif $BlackBar/ShadowCastersButtons.visible:
			switch_buttons($BlackBar/ShadowCastersButtons, \
					$BlackBar/GraphicsButtons/ShadowCasters)
			$ReturnAudio.play()
		elif $BlackBar/ShadowDistanceButtons.visible:
			switch_buttons($BlackBar/ShadowDistanceButtons, \
					$BlackBar/GraphicsButtons/ShadowDistance)
			$ReturnAudio.play()
		elif $BlackBar/MaxRigidBodiesButtons.visible:
			switch_buttons($BlackBar/MaxRigidBodiesButtons, \
					$BlackBar/GraphicsButtons/MaxRigidBodies)
			$ReturnAudio.play()
		elif $BlackBar/SoundButtons.visible:
			switch_buttons($BlackBar/SoundButtons, \
					$BlackBar/SettingsButtons/Sound)
			$ReturnAudio.play()
		elif $BlackBar/EffectsVolumeButtons.visible:
			switch_buttons($BlackBar/EffectsVolumeButtons, \
					$BlackBar/SoundButtons/EffectsVolume)
			$ReturnAudio.play()
		elif $BlackBar/MusicVolumeButtons.visible:
			switch_buttons($BlackBar/MusicVolumeButtons, \
					$BlackBar/SoundButtons/MusicVolume)
			$ReturnAudio.play()


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
	instantiate_vehicles(spawns, 6)


func play():
	$BlackBar/MainButtons.hide()
	while thread.is_alive():
		yield(get_tree(), "idle_frame")
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
	instantiate_vehicles(spawns, 1)


func play_next(vehicle_data: Array):
	track.queue_free()
	yield(get_tree(), "idle_frame")
	track = ResourceLoader.load("res://scenes/world/tracks/figure_8.tscn", \
			"PackedScene").instance()
	
	var viewpoint_container: PlayerContainer
	
	var spawns: Array = Array()
	spawns.append(track.get_node("StartSpawns/SpawnPoint1/Viewport/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint2/Viewport/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint3/Viewport/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint4/Viewport/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint5/Viewport/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint7/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint8/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint9/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint10/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint11/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint12/SpawnPosition"))
	
	vehicle_data.sort_custom(VehicleData, "sort_ascending")
	for n in 12:
		var data: VehicleData = vehicle_data[n]
		var vehicle: Spatial = ResourceLoader.load(data.scene_resource).instance()
		vehicle.get_node("Body").track = track
		vehicle.get_node("Body").controls = data.controls
		vehicle.get_node("Body").score = data.score
		spawns[n].add_child(vehicle)
		data.free()
	
	match player_amount:
		1:
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.show()
			
			add_child(track)
		2:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.show()
			
			add_child(track)
		3:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(2, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			viewpoint_container.show()
			
			add_child(track)
		4:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(2, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(2, 1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			viewpoint_container.show()
			
			add_child(track)
		5:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 3
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(3, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(2, 1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint5")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			viewpoint_container.show()
			
			add_child(track)
		6:
			get_node("/root/RootControl/SettingsManager").split_screen_divisor \
					= 3
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(3, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(3, 1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint5")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint6")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			viewpoint_container.show()
			
			add_child(track)


func active(var b: bool):
	if b:
		thread = Thread.new()
		thread.start(self, "prepare")
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
			6:
				vehicle = ResourceLoader.load(\
						"res://scenes/vehicles/well_raised.tscn", \
						"PackedScene").instance()
		next_vehicle = (next_vehicle + 1) % 7
		vehicle.get_node("Body").track = track
		n.add_child(vehicle)


func switch_buttons(var from: BoxContainer, var to: Control):
	from.hide()
	to.grab_focus()
	if to.get_node("../..").is_class("ColorRect"):
		to.get_parent().show()
	else:
		to.get_node("../..").show()
