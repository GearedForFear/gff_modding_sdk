class_name GameplayManager
extends Node


var pursuers: Array
var score_ui: Array
var invisible_1: Array
var invisible_2: Array
var waypoint: int = 0

onready var heist_target: CombatVehicle = get_node(\
		"../TargetStartSpawn/RootSpatial/Body")
onready var waypoints: Array = $NonPlayerPath.get_children()


func _ready():
	get_node("/root/RootControl/DeletionManager").delete = true
	Global.gameplay_manager = self
	get_node("/root/FrontContainer/Loading").show()


func _process(_delta):
	if get_node("/root/RootControl/DeletionManager").to_be_deleted.empty():
		get_node("/root/FrontContainer/Loading").hide()
		if pursuers.size() == 12:
			$Timer.start()
			var track_data: TrackData = get_parent().data
			MusicPlayer.get_this().set_playlist(track_data.get_music(),
					track_data.music_timer)
			heist_target.alive = true
			heist_target.get_node("../StuckTimer").start()
			
			var scoreboards_already_exists: bool = \
					pursuers[0].scoreboard_record != null
			var scoreboard_head: ScoreboardRecord
			if scoreboards_already_exists:
				scoreboard_head = pursuers[0].scoreboard_record.find_first().prev
			else:
				scoreboard_head = ScoreboardRecord.new(0)
			
			for n in pursuers:
				n.target = heist_target
				n.alive = true
				var scoreboard_record: ScoreboardRecord
				if scoreboards_already_exists:
					scoreboard_record = n.scoreboard_record
				else:
					scoreboard_record = ScoreboardRecord.new(1)
					scoreboard_head.append(scoreboard_record, 1)
					n.scoreboard_record = scoreboard_record
				score_ui.append(n.get_node("ScoreLabel"))
				if n.get_vehicle_name() == "Eternal Bond":
					n.front_half.get_node("Body").scoreboard_record = scoreboard_record
					n.back_half.get_node("Body").scoreboard_record = scoreboard_record
				
				if n.controls == null:
					n.get_node("../StuckTimer").start()
					scoreboard_record.name = n.get_vehicle_name()
				else:
					match n.get_node("../../../..").name:
						"SpawnPoint1":
							scoreboard_record.name = "Player 1"
						"SpawnPoint2":
							scoreboard_record.name = "Player 2"
						"SpawnPoint3":
							scoreboard_record.name = "Player 3"
						"SpawnPoint4":
							scoreboard_record.name = "Player 4"
						"SpawnPoint5":
							scoreboard_record.name = "Player 5"
						"SpawnPoint6":
							scoreboard_record.name = "Player 6"
					var new_score_ui: ColorRect = n.get_node(\
							"CameraBase/Camera/AspectRatioContainer/Control/Scores")
					new_score_ui.scoreboard_record = scoreboard_record
					score_ui.append(new_score_ui)
			
			if not scoreboards_already_exists:
				scoreboard_head.append(ScoreboardRecord.new(13), 1)
			
			heist_target.scoreboard_record = scoreboard_head
			get_node("/root/RootControl/DeletionManager").delete = false
			update_scores()
			set_process(false)


func _physics_process(_delta):
	if heist_target != null:
		heist_target.target = waypoints[waypoint]
	while not invisible_2.empty():
		invisible_2.pop_back().visible = true
	while not invisible_1.empty():
		invisible_2.append(invisible_1.pop_back())


func update_scores():
	for n in score_ui:
		n.update_scores()


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
	if a.scoreboard_record.score > b.scoreboard_record.score:
		return true
	return false


func _on_Timer_timeout():
	var pursuer_data: Array = Array()
	for n in pursuers:
		var data = VehicleData.new()
		data.scene_resource = n.scene_resource
		data.controls = n.controls
		if n.controls == null:
			data.spawn = 6
		else:
			data.spawn = n.get_node("../../../..").get_position_in_parent()
		data.scoreboard_record = n.scoreboard_record
		pursuer_data.append(data)
	get_node("../..").play_next(pursuer_data)
