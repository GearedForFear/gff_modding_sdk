class_name Pickup
extends Area


var shooter: CombatVehicle
var spawner: CombatVehicle
var reward: int
var speed_divisor: float = 20.0


func _physics_process(_delta):
	if shooter == null:
		set_physics_process(false)
		return
	if shooter.replacement != null:
		shooter = shooter.replacement
	if speed_divisor < 0.15:
		global_transform.origin = shooter.global_transform.origin
	transform.origin += global_transform.origin.direction_to(\
			shooter.global_transform.origin).normalized() / speed_divisor
	speed_divisor *= 0.99


func start(new_global_transform: Transform, new_shooter: CombatVehicle, \
		new_spawner: CombatVehicle, new_reward: int):
	global_transform = new_global_transform
	shooter = new_shooter
	spawner = new_spawner
	reward = new_reward
	collision_mask = 1
	set_physics_process(true)
	show()
	reset_physics_interpolation()
	speed_divisor = 20.0


func collect(body: PhysicsBody):
	pass


func make_available():
	pass


func _on_Area_body_entered(body: PhysicsBody):
	if body != spawner\
			and body.scoreboard_record.score != ScoreboardRecord.MAX_INT:
		collect(body)
		collision_mask = 0
		set_physics_process(false)
		hide()
		$AudioStreamPlayer3D.play()


func _on_AudioStreamPlayer3D_finished():
	make_available()
