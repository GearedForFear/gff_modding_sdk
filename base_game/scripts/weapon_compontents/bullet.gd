extends StraightProjectile


const NORMAL_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/bullet.material")
const ACID_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/acid_bullet.material")
const RICOCHET_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/ricochet_bullet.material")
const SNIPER_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/sniper_bullet.material")

enum bullet_types {NORMAL, ACID, RICOCHET}

var spawn_time: int = 0


func set_type(var sniper: bool, var bullet_type: int):
	if sniper:
		if speed != 2.0:
			speed = 2.0
			$MeshInstance.hide()
			$CollisionShape.disabled = true
			$SniperMesh.show()
			$SniperCollision.disabled = false
		match bullet_type:
			bullet_types.NORMAL:
				$SniperMesh.material_override = SNIPER_MATERIAL
	else:
		if speed != 1.0:
			speed = 1.0
			$MeshInstance.show()
			$CollisionShape.disabled = false
			$SniperMesh.hide()
			$SniperCollision.disabled = true
		match bullet_type:
			bullet_types.NORMAL:
				$MeshInstance.material_override = NORMAL_MATERIAL
			bullet_types.ACID:
				$MeshInstance.material_override = ACID_MATERIAL
			bullet_types.RICOCHET:
				$MeshInstance.material_override = RICOCHET_MATERIAL
				spawn_time = Engine.get_physics_frames()
	
	if (bullet_type != bullet_types.ACID):
		acid_duration = 0
	bounce = bullet_type == bullet_types.RICOCHET


func impact_audio(var body: PhysicsBody):
	if body.is_in_group("combat_vehicle"):
		impact_audio_playing = true
		if body.alive == false:
			$ImpactAudioLight.play()
		elif damage < 20:
			$ImpactAudioMedium.play()
		else:
			$ImpactAudioHeavy.play()


func collide(var _body: PhysicsBody):
	if bounce:
		rotation.x += PI + 0.001 * (Engine.get_physics_frames() - spawn_time)


func make_available():
	pools.bullets_available.append(self)


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
