extends ArcProjectile


func start(global_transform: Transform, damage: float, reward: int, \
		burn: float, shooter: CombatVehicle,
		new_projectile_values: ProjectileValues):
	$AudioStreamPlayer3D.play()
	.start(global_transform, damage, reward, burn, shooter, new_projectile_values)


func collide(var body: PhysicsBody):
	$AudioStreamPlayer3D.stop()
	impact_audio_playing = true
	if body.is_in_group("combat_vehicle"):
		$ImpactVehicle.play()
	else:
		$ImpactGround.play()


func make_available():
	get_node("../..").CHAINSAWS_AVAILABLE.append(self)


func _on_ImpactVehicle_finished():
	impact_audio_playing = false
	try_make_available()


func _on_ImpactGround_finished():
	impact_audio_playing = false
	try_make_available()
