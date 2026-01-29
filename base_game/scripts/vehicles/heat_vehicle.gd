class_name HeatVehicle
extends CombatVehicle


var heat: float = 0.0
var already_overheating := false
var delay_overheat := false
var block_overheat := false


func _physics_process(_delta):
	if heat != 0.0:
		var reduction: float = 0.04 + linear_velocity.length() / 200
		heat = max(heat - reduction, 0.0)
		if not already_overheating and not block_overheat and (heat >= 100.0
				or (heat >= 25.0 and not delay_overheat)):
			overheat()
		delay_overheat = false


func damage(amount: float, _reward: int, burn: float, shooter: VehicleBody) \
		-> int:
	if alive:
		change_heat(burn)
	.damage(amount, 0, burn, shooter)
	return 0


func reward(amount: int):
	if alive:
		change_heat(-amount)
	.reward(amount)


func change_heat(var amount: float):
	heat += amount
	delay_overheat = true
	block_overheat = already_overheating


func remove_heat():
	heat = 0.0


func overheat():
	already_overheating = true
	var damage: float
	var impulse: float
	if heat < 50.0:
		damage = body_values.base_health / 20
		impulse = weight / 4
		get_node("../AnimationPlayerHeat").play("overheat_light")
	elif heat < 75.0:
		damage = body_values.base_health / 5
		impulse = weight / 2
		get_node("../AnimationPlayerHeat").play("overheat_medium")
	else:
		damage = body_values.base_health / 2
		impulse = weight
		get_node("../AnimationPlayerHeat").play("overheat_heavy")
	apply_central_impulse(transform.basis.y * impulse)
	damage(damage, 0, 0.0, null)
	heat = 20.0


func _on_RespawnTimer_timeout():
	remove_heat()
	._on_RespawnTimer_timeout()


func _on_AnimationPlayerHeat_animation_finished(_anim_name):
	already_overheating = false
