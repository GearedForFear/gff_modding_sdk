extends StraightProjectile


const MAX_PULL_DISTANCE: float = 50.0


func _physics_process(_delta):
	if global_translation.distance_to(shooter.global_translation) \
			> MAX_PULL_DISTANCE:
		hide_line()
		shooter.saws.erase(self)


func collide(var body: PhysicsBody):
	if body.is_in_group("combat_vehicle"):
		impact_audio_playing = true
		if body.alive:
			$ImpactAudioDamage.play()
		else:
			$ImpactAudioCorpse.play()


func make_available():
	get_node("../..").BUZZSAWS_AVAILABLE.append(self)


func try_make_available():
	if timer_finished:
		hide_line()
		shooter.saws.erase(self)
		if not shot_audio_playing and not impact_audio_playing:
			set_process(false)
			make_available()


func play_audio_shot():
	$ShotAudio.play()
	$ShotAudio.set_as_toplevel(true)
	$ShotAudio.global_transform = global_transform
	shot_audio_playing = true


func magnet(var position: Vector3) -> Vector3:
	var line: MeshInstance = $Line
	if not line.visible:
		line.show()
		line.reset_physics_interpolation()
	line.global_transform.basis.y = position - $SawMesh.global_translation
	line.global_translation = lerp(position, $SawMesh.global_translation, 0.5)
	return $SawMesh.global_translation


func hide_line():
	$Line.hide()


func _on_ShotAudio_finished():
	shot_audio_playing = false
	try_make_available()


func _on_ImpactAudioDamage_finished():
	impact_audio_playing = false
	try_make_available()


func _on_ImpactAudioCorpse_finished():
	impact_audio_playing = false
	try_make_available()
