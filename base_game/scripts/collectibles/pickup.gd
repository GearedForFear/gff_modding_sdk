class_name Pickup
extends Area


var shooter: CombatVehicle
var spawner: CombatVehicle
var type: int
var amount: int
var speed_divisor: float = 20.0


func _physics_process(_delta):
	if shooter == null:
		set_physics_process(false)
		return
	if shooter.replacement != null:
		shooter = shooter.replacement
	if speed_divisor < 0.15:
		global_translation = shooter.global_translation
	global_translation += global_translation.direction_to(\
			shooter.global_translation).normalized() / speed_divisor
	speed_divisor *= 0.99


func start():
	$CollisionShape.disabled = false
	set_physics_process(true)
	show()
	reset_physics_interpolation()
	speed_divisor = 20.0


func collect(body: PhysicsBody):
	match type:
		GlobalEnums.PickupTypes.MONEY:
			body.reward(amount)
		GlobalEnums.PickupTypes.AMMO:
			if body.is_in_group("ammo_vehicle"):
				body.change_ammo(amount)
		GlobalEnums.PickupTypes.LIGHT_SHIELD:
			body.change_light_shield_remaining(amount)


func make_available():
	Pools.PICKUPS_AVAILABLE.append(self)


func _on_Area_body_entered(body: PhysicsBody):
	if body != spawner\
			and body.scoreboard_record.score != ScoreboardRecord.MAX_INT:
		collect(body)
		$CollisionShape.disabled = true
		set_physics_process(false)
		hide()
		$AudioStreamPlayer3D.play()


func _on_AudioStreamPlayer3D_finished():
	make_available()
