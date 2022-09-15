extends Node


var players: Array
var pursuers: Array
var heist_target: CombatVehicle
var waypoint: int = 0

onready var waypoints: Array = $NonPlayerPath.get_children()


func _process(_delta):
	if pursuers.size() == 12 and $Timer.is_stopped():
		if get_node("../TargetStartSpawn/SpawnPoint/Viewport/SpawnPosition")\
				.get_child_count() == 0:
			var target_spawn \
					= load("res://scenes/vehicles/fungibber.tscn").instance()
			heist_target = target_spawn.get_node("Body")
			heist_target.track = get_parent()
			heist_target.alive = true
			get_node("../TargetStartSpawn/SpawnPoint/Viewport/SpawnPosition")\
					.add_child(target_spawn)
		$Timer.wait_time *= 60.0 \
				/ ProjectSettings.get_setting("physics/common/physics_fps")
		$Timer.start()
		heist_target.get_node("../StuckTimer").start()
		for n in pursuers:
			n.target = heist_target
			n.alive = true
			if n.controls == null:
				n.get_node("../StuckTimer").start()
	
	if not $Timer.is_stopped():
		for n in players:
			var ui: Control = n.get_node(\
					"CameraBase/Camera/AspectRatioContainer/Control")
			ui.get_node("TimerBackground/TimeLeft").text = \
					String(int(get_node("Timer").time_left))
			var bar: ProgressBar = ui.get_node("ResourcesBackground/AmmoBar")
			bar.value = n.ammo
			if n.ammo == 100:
				bar.modulate = Color(1, 1, 1, 0.5)
			else:
				bar.modulate = Color(1, 1, 1, 1)
			bar = ui.get_node("ResourcesBackground/HealthBar")
			bar.value = n.health
			if n.health == n.base_health:
				bar.modulate = Color(1, 1, 1, 0.5)
			else:
				bar.modulate = Color(1, 1, 1, 1)
			
			var scoreboard: ColorRect = ui.get_node("ScoresBackground")
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


func respawn(vehicle: CombatVehicle):
	vehicle.global_transform = waypoints[waypoint].get_node(\
			"RespawnPoints/RespawnPoint0").global_transform
	vehicle.reset_physics_interpolation()
	vehicle.linear_velocity = Vector3.ZERO
	for n in waypoints[waypoint].get_node("RespawnPoints").get_children():
		if n.get_overlapping_bodies().size() == 0:
			vehicle.global_transform = n.global_transform
			vehicle.reset_physics_interpolation()
			break


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
	get_parent().queue_free()
	get_node("../..").active(true)
