class_name Projectile
extends Area


enum explosive_types {NONE, FIRE}

export(explosive_types) var explosive_type: int = explosive_types.NONE
export var speed: float = 1.0

var damage: float
var reward: int
var burn: float
var acid_duration: int = 0
var shooter: CombatVehicle

var timer_finished: bool = false
var shot_audio_playing: bool = false
var impact_audio_playing: bool = false
var gles3: bool

onready var pools: Node = get_node("../..")


func start(global_transform: Transform, damage: float, reward: int, \
		burn: float, shooter: CombatVehicle):
	self.global_transform = global_transform
	self.damage = damage
	self.reward = reward
	self.burn = burn
	self.shooter = shooter
	collision_layer = 8
	collision_mask = 3
	set_physics_process(true)
	set_process(true)
	show()
	reset_physics_interpolation()
	$Lifetime.start()
	timer_finished = false


func collide(var _body: PhysicsBody):
	pass


func make_available():
	pass


func try_make_available():
	if timer_finished and not shot_audio_playing and not impact_audio_playing:
		set_process(false)
		make_available()


func _on_Area_body_entered(body):
	if body != shooter:
		match explosive_type:
			explosive_types.NONE:
				if body.is_in_group("combat_vehicle") \
						and explosive_type == explosive_types.NONE:
					if acid_duration > 0 and body.alive:
						body.acid_duration += acid_duration
						body.acid_cause = shooter
					
					rotation.z = randi() / TAU
					pools.get_sparks().start(global_transform)
					
					var payout: int = body.damage(damage, reward, burn, shooter)
					if payout > 0:
						pools.get_money().start(global_transform, shooter, body, \
								payout)
			explosive_types.FIRE:
				pools.get_explosion().start(global_transform, damage, reward, \
						burn, shooter)
		collide(body)
		set_physics_process(false)
		hide()
		collision_layer = 0
		collision_mask = 0
		$Lifetime.stop()
		timer_finished = true
		try_make_available()


func _on_Lifetime_timeout():
	timer_finished = true
	set_physics_process(false)
	hide()
	collision_layer = 0
	collision_mask = 0
	try_make_available()
