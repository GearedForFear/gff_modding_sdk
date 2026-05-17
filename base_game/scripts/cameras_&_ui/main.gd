extends Control


var track: Spatial
var next_tracks := []
var player_amount: int = 1


func _init():
	Global.root_control = self
	AudioServer.set_bus_volume_db(0, linear2db(0.0))


func _ready():
	var directory: Directory = Directory.new()
	if directory.open("user://mods") == OK and directory.list_dir_begin() == OK:
		var next_mod: String = directory.get_next()
		while next_mod != "":
			if ProjectSettings.load_resource_pack("user://mods/" + next_mod):
				var mod_scene: Node = ResourceLoader.load(
						"res://scenes/mod.tscn", "PackedScene").instance()
				add_child(mod_scene)
				mod_scene.modify()
			next_mod = directory.get_next()
	VisualServer.set_default_clear_color(Color.black)
	LoadingManager.prepare()


func play(vehicles: Array, controls: Array):
	#$MaterialManager.set_movement(true)
	var vehicle_data_array := Array()
	for n in player_amount:
		var new_data := VehicleData.instantiate_simple(VehicleData.new(),
				vehicles[n], controls[n])
		vehicle_data_array.append(new_data)
	spawn_world(vehicle_data_array)
	#$BackgroundShader.hide()
	"""
	get_tree().physics_interpolation = settings_manager.transform_interpolation
			and rr != 29 and rr != 30 and rr != 59 and rr != 60
	
	var viewpoint_container: PlayerContainer
	var screen1: Control
	var screen2: Control
	var screen3: Control
	var screen4: Control
	var screen5: Control
	var screen6: Control
	var controller_select: PackedScene = ResourceLoader.load(
			"res://scenes/cameras_&_ui/controller_select.tscn", "PackedScene")
	var spawns: Array = Array()
	
	match player_amount:
		1:
			settings_manager.split_screen_divisor = 1
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			add_child(track)
			
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint2/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint3/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint4/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint5/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		2:
			settings_manager.split_screen_divisor = 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(1, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			screen1.get_node("BlackBar").next = screen2.get_node("BlackBar")
			
			add_child(track)
			
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint3/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint4/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint5/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		3:
			settings_manager.split_screen_divisor = 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(2, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 0)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
			screen3 = controller_select.instance()
			viewpoint_container.add_child(screen3)
			viewpoint_container.show()
			
			screen1.get_node("BlackBar").next = screen2.get_node("BlackBar")
			screen2.get_node("BlackBar").next = screen3.get_node("BlackBar")
			
			add_child(track)
			
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint4/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint5/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		4:
			settings_manager.split_screen_divisor = 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(2, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 0)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
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
			
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint5/Viewport/SpawnPosition"))
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		5:
			settings_manager.split_screen_divisor = 3
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(3, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 0)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 0)
			screen3 = controller_select.instance()
			viewpoint_container.add_child(screen3)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
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
			
			spawns.append(track.get_node(
					"StartSpawns/SpawnPoint6/Viewport/SpawnPosition"))
		6:
			settings_manager.split_screen_divisor = 3
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(3, 2)
			screen1 = controller_select.instance()
			screen1.get_node("BlackBar").active = true
			viewpoint_container.add_child(screen1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 0)
			screen2 = controller_select.instance()
			viewpoint_container.add_child(screen2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 0)
			screen3 = controller_select.instance()
			viewpoint_container.add_child(screen3)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
			screen4 = controller_select.instance()
			viewpoint_container.add_child(screen4)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint5")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			screen5 = controller_select.instance()
			viewpoint_container.add_child(screen5)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint6")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 1)
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
"""

func play_next(vehicle_data_array: Array):
	if next_tracks.empty():
		active(true)
		$AspectRatioContainer/ArcadeEnd.update_text(
				vehicle_data_array[0].scoreboard_record.find_first())
		DeletionManager.enable(true)
		$AspectRatioContainer/MainMenu.hide()
		return
	spawn_world(vehicle_data_array)
	
	"""
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
	
	vehicle_data.sort_custom(VehicleData, "sort_spawn")
	for n in 12:
		var data: VehicleData = vehicle_data[n]
		var vehicle: Spatial = ResourceLoader.load(data.scene_resource).instance()
		vehicle.get_node("Body").track = track
		vehicle.get_node("Body").controls = data.controls
		vehicle.get_node("Body").scoreboard_record = data.scoreboard_record
		spawns[n].add_child(vehicle)
		data.free()
	
	instantiate_target_vehicle()
	
	match player_amount:
		1:
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.show()
			
			add_child(track)
		2:
			settings_manager.split_screen_divisor = 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
			viewpoint_container.show()
			
			add_child(track)
		3:
			settings_manager.split_screen_divisor = 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 0)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(1, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
			viewpoint_container.show()
			
			add_child(track)
		4:
			settings_manager.split_screen_divisor = 2
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 0)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			viewpoint_container.show()
			
			add_child(track)
		5:
			settings_manager.split_screen_divisor = 3
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 0)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 0)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint5")
			viewpoint_container.size_divisor = Vector2(2, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			viewpoint_container.show()
			
			add_child(track)
		6:
			settings_manager.split_screen_divisor = 3
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint1")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint2")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 0)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint3")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 0)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint4")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(0, 1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint5")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(1, 1)
			viewpoint_container.show()
			
			viewpoint_container = track.get_node("StartSpawns/SpawnPoint6")
			viewpoint_container.size_divisor = Vector2(3, 2)
			viewpoint_container.screen_position = Vector2(2, 1)
			viewpoint_container.show()
			
			add_child(track)
"""


func spawn_world(vehicle_data_array: Array):
	DeletionManager.enable(true)
	if is_instance_valid(track):
		track.queue_free()
		yield(get_tree(), "idle_frame")
	var upcoming_track: String = "res://scenes/world/tracks/" \
			+ next_tracks.pop_front() + ".tscn"
	track = ResourceLoader.load(upcoming_track, "PackedScene").instance()
	spawn_vehicle(VehicleData.complete_resource_name("fungibber"),
			"TargetStartSpawn", null)
	add_child(track)
	next_tracks.remove(0)
	
	var spawns := Array()
	for n in player_amount:
		spawns.append(spawn_vehicle(vehicle_data_array[n].scene_resource,
				"StartSpawns/SpawnPoint" + String(n + 1)
				+ "/Viewport/SpawnPosition", vehicle_data_array[n].controls))
	var bots := ["chains_awe", "suicide_door", "grave_mistake",
			"metal_undertow", "warm_welcome", "turbulence", "eternal_bond",
			"missilodon", "restless", "well_raised", "no_match"]
	for n in 12 - player_amount:
		var viewport: String = "/Viewport"
		if n < 6:
			viewport = ""
		spawn_vehicle(VehicleData.complete_resource_name(bots[n]),
				"StartSpawns/SpawnPoint" + String(12 - n) + viewport
				+ "/SpawnPosition", null)
	MenuManager.go_to("GameplayView").set_views(spawns)
	"""
	if is_instance_valid(track):
		track.queue_free()
	track = ResourceLoader.load(path).instance()
	var spawns := Array()
	spawns.append(track.get_node("StartSpawns/SpawnPoint7/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint8/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint9/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint10/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint11/SpawnPosition"))
	spawns.append(track.get_node("StartSpawns/SpawnPoint12/SpawnPosition"))
	instantiate_vehicles(spawns, 6)
	#instantiate_target_vehicle()
	"""


func active(var b: bool):
	if b:
		if $MusicPlayer.is_on_vehicle_select == false:
			$MusicPlayer.start($MusicPlayer.MENU_MUSIC, null)
		else:
			$MusicPlayer.is_on_vehicle_select = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		var menu: Control = $AspectRatioContainer/MainMenu
		menu.show()
		menu.get_node("Arcade").grab_focus()
	else:
		for n in [$AspectRatioContainer, $ResolutionMenu, $FOVMenu, $MenuTimer]:
			remove_child(n)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	visible = b
	set_process(b)

"""
func instantiate_vehicles(var spawns: Array, var first_vehicle: int):
	var vehicle: Spatial
	var next_vehicle: int = first_vehicle
	var names: PoolStringArray = ["chains_awe", "suicide_door", "grave_mistake",
			"metal_undertow", "warm_welcome", "turbulence", "eternal_bond",
			"missilodon", "restless", "well_raised", "no_match"]
	for n in spawns:
		vehicle = ResourceLoader.load("res://scenes/vehicles/"
				+ names[next_vehicle] + ".tscn", "PackedScene").instance()
		next_vehicle = (next_vehicle + 1) % 11
		vehicle.get_node("Body").track = track
		n.add_child(vehicle)
"""

func spawn_vehicle(scene_resource: String, spawn_name: String,
		controls: PlayerControls) -> PlayerContainer:
	var vehicle: Spatial = ResourceLoader.load(scene_resource, "PackedScene")\
			.instance()
	var body: VehicleBody = vehicle.get_node("Body")
	body.track = track
	body.controls = controls
	var spawn = track.get_node(spawn_name)
	spawn.add_child(vehicle)
	return spawn
