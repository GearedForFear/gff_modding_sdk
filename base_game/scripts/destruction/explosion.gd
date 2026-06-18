extends Area


var damage: float
var reward: int
var burn: float
var projectile_values: ProjectileValues
var shooter: CombatVehicle


func start(new_global_transform: Transform, new_shooter: CombatVehicle,
		new_projectile_values: ProjectileValues):
	global_transform = new_global_transform
	shooter = new_shooter
	projectile_values = new_projectile_values
	$MeshInstance.rotation = Vector3(randf(), randf(), randf())
	$MeshInstance2.rotation = Vector3(randf(), randf(), randf())
	show()
	monitoring = true
	reset_physics_interpolation()
	$OmniLight.global_translation = global_translation + Vector3(0, 0.2, 0)
	$AudioStreamPlayer3D.play()
	$Lifetime.start()
	$CollisionShape.disabled = true
	yield(get_tree(), "physics_frame")
	$CollisionShape.disabled = false


func _on_Lifetime_timeout():
	hide()
	monitoring = false


func _on_Area_body_entered(body: PhysicsBody):
	if body.is_in_group("combat_vehicle"):
		body.apply_central_impulse((body.global_transform.origin \
				- global_transform.origin).normalized() * 5000)
		if body != shooter:
			var payout: int = body.damage(projectile_values.damage, projectile_values.reward, projectile_values.burn, shooter)
			if payout > 0:
				get_node("../..").get_money().start(global_transform, shooter,
						body, payout)


func _on_Area_area_entered(area: Area):
	area.destroy(shooter, global_transform.origin, 10.0)


func _on_AudioStreamPlayer3D_finished():
	get_node("../..").EXPLOSIONS_AVAILABLE.append(self)
