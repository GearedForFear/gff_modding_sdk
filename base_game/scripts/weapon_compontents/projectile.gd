class_name Projectile
extends Area


enum ImpactTypes {NORMAL, ACID, RICOCHET}

export var speed: float = 1.0
export var explosive := false

var damage: float
var reward: int
var burn: float
var acid_duration: int = 0
var shooter: CombatVehicle

var bounce: bool = false
var timer_finished: bool = false
var shot_audio_playing: bool = false
var impact_audio_playing: bool = false


func _ready():
	set_physics_process(false)
	set_process(false)


func _physics_process(_delta):
	if abs(global_translation.x) >= 900 or global_translation.y >= 320 \
			or global_translation.y <= -32 or abs(global_translation.z) >= 1200:
		stop()


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
	var lifetime: Timer = get_node_or_null("Lifetime")
	if lifetime != null:
		lifetime.start()
	timer_finished = false


func stop():
	set_physics_process(false)
	hide()
	collision_layer = 0
	collision_mask = 0
	$Lifetime.stop()
	timer_finished = true
	try_make_available()


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
		var pools: Node = get_node("../..")
		if explosive:
			pools.get_explosion().start(global_transform, damage, reward, burn,
					shooter)
		else:
			if body.is_in_group("combat_vehicle"):
				if acid_duration > 0 and body.alive:
					body.acid_duration += acid_duration
					body.acid_cause = shooter
				
				pools.get_sparks().start(global_transform)
				
				var payout: int = body.damage(damage, reward, burn, shooter)
				if payout > 0 and shooter != null:
					pools.get_money().start(global_transform, shooter, body, \
							payout)
				if bounce:
					if body.is_in_group("heist_target"):
						shooter = null
					else:
						shooter = body
			elif bounce:
				shooter = null
		collide(body)
		if bounce:
			reset_physics_interpolation()
			bounce = false
			return
		stop()


func _on_Lifetime_timeout():
	timer_finished = true
	set_physics_process(false)
	hide()
	collision_layer = 0
	collision_mask = 0
	try_make_available()
