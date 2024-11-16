extends Node


var players: Array
var pursuers: Array
var invisible_1: Array
var invisible_2: Array
var waypoint: int = 0

onready var heist_target: CombatVehicle = get_node(\
		"../TargetStartSpawn/RootSpatial/Body")
onready var waypoints: Array = $NonPlayerPath.get_children()


func _ready():
	get_node("/root/RootControl/DeletionManager").delete = true


func _process(_delta):
	if pursuers.size() == 12 and $Timer.is_stopped() and \
			get_node("/root/RootControl/DeletionManager").to_be_deleted.empty():
		$Timer.start()
		heist_target.alive = true
		heist_target.get_node("../StuckTimer").start()
		for n in pursuers:
			n.target = heist_target
			n.alive = true
			if n.controls == null:
				n.get_node("../StuckTimer").start()
		get_node("/root/RootControl/DeletionManager").delete = false
	
	if not $Timer.is_stopped():
		for n in players:
			var ui: Control = n.get_node(\
					"CameraBase/Camera/AspectRatioContainer/Control")
			
			var scoreboard: ColorRect = ui.get_node("Scores")
			scoreboard.get_node("Placement1").text = "1st"
			scoreboard.get_node("Name1").text = pursuers[0].driver_name
			scoreboard.get_node("Score1").text = String(pursuers[0].score) + "€"
			var player_position: int = pursuers.find(n)
			var second_position_shown: int \
					= int(clamp(player_position - 1, 1, 9))
			scoreboard.get_node("Placement2").text = placement_to_string(\
					pursuers[second_position_shown].placement)
			scoreboard.get_node("Name2").text = pursuers[second_position_shown]\
					.driver_name
			scoreboard.get_node("Score2").text = String(\
					pursuers[second_position_shown].score) + "€"
			scoreboard.get_node("Placement3").text = placement_to_string(\
					pursuers[second_position_shown + 1].placement)
			scoreboard.get_node("Name3").text = \
					pursuers[second_position_shown + 1].driver_name
			scoreboard.get_node("Score3").text = String(\
					pursuers[second_position_shown + 1].score) + "€"
			scoreboard.get_node("Placement4").text = placement_to_string(\
					pursuers[second_position_shown + 2].placement)
			scoreboard.get_node("Name4").text = \
					pursuers[second_position_shown + 2].driver_name
			scoreboard.get_node("Score4").text = String(\
					pursuers[second_position_shown + 2].score) + "€"
			
			match player_position:
				0:
					scoreboard.get_node("Name1").modulate = Color("fd5602")
					scoreboard.get_node("Name2").modulate = Color.white
					scoreboard.get_node("Name3").modulate = Color.white
					scoreboard.get_node("Name4").modulate = Color.white
				1:
					scoreboard.get_node("Name1").modulate = Color.white
					scoreboard.get_node("Name2").modulate = Color("fd5602")
					scoreboard.get_node("Name3").modulate = Color.white
					scoreboard.get_node("Name4").modulate = Color.white
				2, 3, 4, 5, 6, 7, 8, 9, 10:
					scoreboard.get_node("Name1").modulate = Color.white
					scoreboard.get_node("Name2").modulate = Color.white
					scoreboard.get_node("Name3").modulate = Color("fd5602")
					scoreboard.get_node("Name4").modulate = Color.white
				11:
					scoreboard.get_node("Name1").modulate = Color.white
					scoreboard.get_node("Name2").modulate = Color.white
					scoreboard.get_node("Name3").modulate = Color.white
					scoreboard.get_node("Name4").modulate = Color("fd5602")


func _physics_process(_delta):
	pursuers.sort_custom(self, "compare_scores")
	for n in pursuers:
		n.placement = pursuers.find(n) + 1
	if heist_target != null:
		heist_target.target = waypoints[waypoint]
	while not invisible_2.empty():
		invisible_2.pop_back().visible = true
	while not invisible_1.empty():
		invisible_2.append(invisible_1.pop_back())


func respawn(vehicle: CombatVehicle):
	if not vehicle.master_body:
		vehicle.split(false)
	
	vehicle.global_transform = waypoints[waypoint].get_node(\
			"RespawnPoints/RespawnPoint0").global_transform
	vehicle.linear_velocity = Vector3.ZERO
	vehicle.angular_velocity = Vector3.ZERO
	vehicle.sleeping = false
	for n in waypoints[waypoint].get_node("RespawnPoints").get_children():
		if n.get_overlapping_bodies().size() == 0:
			vehicle.global_transform = n.global_transform
			break
	vehicle.reset_physics_interpolation()
	var mesh: MeshInstance = vehicle.get_node("BodyMesh")
	mesh.visible = false
	invisible_1.append(mesh)


func waypoint_entered(entered: Area, body: CombatVehicle):
	if waypoints[waypoint] == entered.get_parent():
		waypoint = (waypoint + 1) % waypoints.size()
		heist_target.target = waypoints[waypoint]
		body.get_node("../StuckTimer").start()


func compare_scores(a: CombatVehicle, b: CombatVehicle) -> bool:
	if a.score > b.score:
		return true
	return false


func placement_to_string(placement: int) -> String:
	match placement:
		1:
			return "1st"
		2:
			return "2nd"
		3:
			return "3rd"
		_:
			return String(placement) + "th"


func _on_Timer_timeout():
	var pursuer_data: Array = Array()
	for n in pursuers:
		var data = VehicleData.new()
		data.scene_resource = n.scene_resource
		data.driver_name = n.driver_name
		data.controls = n.controls
		if n.controls == null:
			data.spawn = 6
		else:
			data.spawn = n.get_node("../../../..").get_position_in_parent()
		data.score = n.score
		pursuer_data.append(data)
	get_node("../..").play_next(pursuer_data)
