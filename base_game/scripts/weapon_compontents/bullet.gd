extends StraightProjectile


const NORMAL_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/bullet.material")
const ACID_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/acid_bullet.material")
const RICOCHET_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/ricochet_bullet.material")

var spawn_time: int = 0


func set_type(var sniper: bool, var impact_type: int):
	if sniper and speed != 2.0:
		speed = 2.0
		$CollisionShape.translation = Vector3(0, 0, 1)
		$CollisionShape.scale = Vector3(1, 2, 1)
	else:
		speed = 1.0
		$CollisionShape.translation = Vector3(0, 0, 0.5)
		$CollisionShape.scale = Vector3.ONE
	match impact_type:
		ImpactTypes.NORMAL:
			$CollisionShape/MeshInstance.material_override = NORMAL_MATERIAL
		ImpactTypes.ACID:
			$CollisionShape/MeshInstance.material_override = ACID_MATERIAL
		ImpactTypes.RICOCHET:
			$CollisionShape/MeshInstance.material_override = RICOCHET_MATERIAL
			spawn_time = Engine.get_physics_frames()
	
	if (impact_type != ImpactTypes.ACID):
		acid_duration = 0
	bounce = impact_type == ImpactTypes.RICOCHET


func collide(var body: PhysicsBody):
	if bounce:
		rotation.x += PI + 0.001 * (Engine.get_physics_frames() - spawn_time)
	impact_audio(body)


func impact_audio(var body: PhysicsBody):
	if body.is_in_group("combat_vehicle"):
		impact_audio_playing = true
		if body.alive == false:
			$ImpactAudioLight.play()
		elif damage < 20:
			$ImpactAudioMedium.play()
		else:
			$ImpactAudioHeavy.play()
			if shooter.controls != null:
				GlobalAudio.play("SniperImpact")


func make_available():
	get_node("../..").bullets_available.append(self)


func play_audio_lmg():
	$ShotAudioLMG.play()
	$ShotAudioLMG.set_as_toplevel(true)
	$ShotAudioLMG.global_transform = global_transform
	shot_audio_playing = true


func play_audio_shotgun():
	$ShotAudioShotgun.play()
	$ShotAudioShotgun.set_as_toplevel(true)
	$ShotAudioShotgun.global_transform = global_transform
	shot_audio_playing = true


func play_audio_sniper():
	$ShotAudioSniper.play()
	$ShotAudioSniper.set_as_toplevel(true)
	$ShotAudioSniper.global_transform = global_transform
	shot_audio_playing = true


func _on_ShotAudioLMG_finished():
	shot_audio_playing = false
	try_make_available()


func _on_ShotAudioShotgun_finished():
	shot_audio_playing = false
	try_make_available()


func _on_ShotAudioSniper_finished():
	shot_audio_playing = false
	try_make_available()


func _on_ImpactAudioLight_finished():
	impact_audio_playing = false
	try_make_available()


func _on_ImpactAudioMedium_finished():
	impact_audio_playing = false
	try_make_available()


func _on_ImpactAudioHeavy_finished():
	impact_audio_playing = false
	try_make_available()
