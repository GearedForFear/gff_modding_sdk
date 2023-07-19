extends Area


enum bullet_types {NORMAL, SNIPER, ACID, ACID_SNIPER}

export var speed: float = 1.0

var damage: float
var reward: int
var burn: float
var acid_duration: int = 0
var shooter: CombatVehicle

var timer_finished: bool = false
var shot_audio_playing: bool = false
var impact_audio_playing: bool = false
var bullet_type: int

onready var pools: Node = get_node("../..")

func _ready():
	$Lifetime.wait_time *= 60.0 \
			/ ProjectSettings.get_setting("physics/common/physics_fps")
	match $MeshInstance.get_active_material(0).get_shader_param("ColorUniform"):
		Color.yellow:
			if speed == 1.0:
				bullet_type = bullet_types.NORMAL
			else:
				bullet_type = bullet_types.SNIPER
		Color(0.384314, 1, 0):
			bullet_type = bullet_types.ACID


func _physics_process(_delta):
	translation += transform.basis.z * speed


func _process(_delta):
	if timer_finished and not shot_audio_playing and not impact_audio_playing:
		set_process(false)
		match bullet_type:
			bullet_types.NORMAL:
				pools.bullets_available.append(self)
			bullet_types.SNIPER:
				pools.sniper_bullets_available.append(self)
			bullet_types.ACID:
				pools.acid_bullets_available.append(self)


func start(global_transform: Transform, damage: float, reward: int, \
		burn: float, shooter: CombatVehicle):
	self.global_transform = global_transform
	self.damage = damage
	self.reward = reward
	self.burn = burn
	acid_duration = 0
	self.shooter = shooter
	collision_layer = 8
	collision_mask = 3
	set_physics_process(true)
	set_process(true)
	show()
	reset_physics_interpolation()
	$Lifetime.start()


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


func _on_Area_body_entered(body):
	if body != shooter:
		if body.is_in_group("combat_vehicle"):
			if body.alive == false:
				$ImpactAudioLight.play()
			elif damage < 20:
				$ImpactAudioMedium.play()
			else:
				$ImpactAudioHeavy.play()
			impact_audio_playing = true
			
			if acid_duration > 0:
				body.acid_duration += acid_duration
				body.acid_cause = shooter
			
			rotation.z = randi() / TAU
			pools.get_sparks().start(global_transform)
			
			var payout: int = body.damage(damage, reward, burn, shooter)
			if payout > 0:
				pools.get_money().start(global_transform, shooter, body, payout)
		set_physics_process(false)
		hide()
		collision_layer = 0
		collision_mask = 0


func _on_Lifetime_timeout():
	timer_finished = true
	set_physics_process(false)
	hide()
	collision_layer = 0
	collision_mask = 0


func _on_ShotAudioLMG_finished():
	shot_audio_playing = false


func _on_ShotAudioShotgun_finished():
	shot_audio_playing = false


func _on_ShotAudioSniper_finished():
	shot_audio_playing = false


func _on_ImpactAudioLight_finished():
	impact_audio_playing = false


func _on_ImpactAudioMedium_finished():
	impact_audio_playing = false


func _on_ImpactAudioHeavy_finished():
	impact_audio_playing = false
