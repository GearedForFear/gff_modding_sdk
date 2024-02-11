extends ArcProjectile


func start(global_transform: Transform, damage: float, reward: int, \
		burn: float, shooter: CombatVehicle):
	$AudioStreamPlayer3D.play()
	.start(global_transform, damage, reward, burn, shooter)


func collide(var body: PhysicsBody):
	$AudioStreamPlayer3D.stop()
	impact_audio_playing = true
	if body.is_in_group("combat_vehicle"):
		$ImpactVehicle.play()
	else:
		$ImpactGround.play()


func make_available():
	pools.chainsaws_available.append(self)


func _on_ImpactVehicle_finished():
	impact_audio_playing = false
	try_make_available()


func _on_ImpactGround_finished():
	impact_audio_playing = false
	try_make_available()
