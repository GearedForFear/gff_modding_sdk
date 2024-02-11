extends Area


var shooter: CombatVehicle
var spawner: CombatVehicle
var reward: int
var speed_divisor: float = 20.0
var move: bool = false

onready var pools: Node = get_node("../..")


func _physics_process(_delta):
	if move:
		if shooter.replacement != null:
			shooter = shooter.replacement
		if speed_divisor < 0.15:
			global_transform.origin = shooter.global_transform.origin
		transform.origin += global_transform.origin.direction_to(\
				shooter.global_transform.origin).normalized() / speed_divisor
		speed_divisor *= 0.99


func start(global_transform: Transform, shooter: CombatVehicle, \
		spawner: CombatVehicle, reward: int):
	self.global_transform = global_transform
	self.shooter = shooter
	self.spawner = spawner
	self.reward = reward
	collision_layer = 0
	collision_mask = 1
	set_physics_process(true)
	set_process(true)
	show()
	reset_physics_interpolation()
	speed_divisor = 20.0
	move = true


func _on_Area_body_entered(body):
	if body != spawner:
		body.reward(reward)
		set_physics_process(true)
		set_process(false)
		hide()
		move = false
		$AudioStreamPlayer3D.play()


func _on_AudioStreamPlayer3D_finished():
	pools.money_available.append(self)
	collision_layer = 0
	collision_mask = 0
