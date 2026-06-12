extends StraightProjectile


const NORMAL_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/bullet.material")
const ACID_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/acid_bullet.material")
const RICOCHET_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/ricochet_bullet.material")

const SHOT_LMG: AudioStreamSample = \
		preload("res://resources/sounds/weapon_components/gun_machinegun_auto_heavy_shot_00_last_with_tail_01.wav")
const SHOT_SHOTGUN: AudioStreamSample = \
		preload("res://resources/sounds/weapon_components/gun_shotgun_sawed_off_shot_04.wav")
const SHOT_SNIPER: AudioStreamSample = \
		preload("res://resources/sounds/weapon_components/gun_rifle_sniper_shot_03.wav")
const IMPACT_LIGHT: AudioStreamSample = \
		preload("res://resources/sounds/destruction/bullet_impact_metal_light_07.wav")
const IMPACT_MEDIUM: AudioStreamSample = \
		preload("res://resources/sounds/destruction/bullet_impact_metal_heavy_01.wav")
const IMPACT_HEAVY: AudioStreamSample = \
		preload("res://resources/sounds/destruction/bullet_impact_metal_heavy_02.wav")

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
		var impact_audio: AudioStreamPlayer3D = $ImpactAudio
		if body.alive == false:
			impact_audio.stream = IMPACT_LIGHT
		elif damage < 20:
			impact_audio.stream = IMPACT_MEDIUM
		else:
			impact_audio.stream = IMPACT_HEAVY
			if shooter.controls != null:
				GlobalAudio.play("SniperImpact")
		impact_audio.play()


func make_available():
	get_node("../..").BULLETS_AVAILABLE.append(self)


func try_deflect(body: PhysicsBody) -> bool:
	$CollisionShape/MeshInstance.material_override = RICOCHET_MATERIAL
	.try_deflect(body)
	return true


func play_audio_lmg():
	var shot_audio: AudioStreamPlayer3D = $ShotAudio
	shot_audio.stream = SHOT_LMG
	shot_audio.unit_size = 1.0
	play_shot_audio(shot_audio)


func play_audio_shotgun():
	var shot_audio: AudioStreamPlayer3D = $ShotAudio
	shot_audio.stream = SHOT_SHOTGUN
	shot_audio.unit_size = 1.0
	play_shot_audio(shot_audio)


func play_audio_sniper():
	var shot_audio: AudioStreamPlayer3D = $ShotAudio
	shot_audio.stream = SHOT_SNIPER
	shot_audio.unit_size = 1.4
	play_shot_audio(shot_audio)


func play_shot_audio(shot_audio: AudioStreamPlayer3D):
	shot_audio.play()
	shot_audio.set_as_toplevel(true)
	shot_audio.global_transform = global_transform
	shot_audio_playing = true


func _on_ShotAudio_finished():
	shot_audio_playing = false
	try_make_available()


func _on_ImpactAudio_finished():
	impact_audio_playing = false
	try_make_available()
