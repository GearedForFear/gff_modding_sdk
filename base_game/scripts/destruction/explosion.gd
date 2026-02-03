extends Area


var damage: float
var reward: int
var burn: float
var shooter: CombatVehicle


func start(new_global_transform: Transform, new_damage: float, new_reward: int, \
		new_burn: float, new_shooter: CombatVehicle):
	global_transform = new_global_transform
	damage = new_damage
	reward = new_reward
	burn = new_burn
	shooter = new_shooter
	$MeshInstance.rotation = Vector3(randf(), randf(), randf())
	$MeshInstance2.rotation = Vector3(randf(), randf(), randf())
	collision_layer = 8
	collision_mask = 3
	set_physics_process(true)
	set_process(true)
	show()
	reset_physics_interpolation()
	$OmniLight.global_translation = global_translation + Vector3(0, 0.2, 0)
	$AudioStreamPlayer3D.play()
	$Lifetime.start()
	$CollisionShape.disabled = true
	yield(get_tree(), "physics_frame")
	$CollisionShape.disabled = false


func _on_Lifetime_timeout():
	set_physics_process(false)
	hide()
	collision_layer = 0
	collision_mask = 0


func _on_Area_body_entered(body: PhysicsBody):
	if body.is_in_group("combat_vehicle"):
		body.apply_central_impulse((body.global_transform.origin \
				- global_transform.origin).normalized() * 5000)
		if body != shooter:
			var payout: int = body.damage(damage, reward, burn, shooter)
			if payout > 0:
				get_node("../..").get_money().start(global_transform, shooter, body, payout)


func _on_Area_area_entered(area):
	if area.is_in_group("destructible"):
		area.destroy(shooter, global_transform.origin, 40.0)


func _on_AudioStreamPlayer3D_finished():
	set_process(false)
	get_node("../..").explosions_available.append(self)
