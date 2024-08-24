class_name HeatVehicle
extends CombatVehicle


var heat: float = 0.0
var delay_overheat: = false


func _physics_process(_delta):
	if heat != 0.0:
		var reduction: float = 0.04 + linear_velocity.length() / 200
		heat = max(heat - reduction, 0.0)
		if heat >= 100.0 or (heat >= 25.0 and not delay_overheat):
			overheat()
		delay_overheat = false


func change_heat(var amount: float):
	heat += amount
	delay_overheat = true


func remove_heat():
	heat = 0.0


func overheat():
	var damage: float
	var impulse: float
	if heat < 50.0:
		damage = base_health / 20
		impulse = weight / 4
		get_node("../AnimationPlayerHeat").play("overheat_light")
	elif heat < 75.0:
		damage = base_health / 5
		impulse = weight / 2
		get_node("../AnimationPlayerHeat").play("overheat_medium")
	else:
		damage = base_health / 2
		impulse = weight
		get_node("../AnimationPlayerHeat").play("overheat_heavy")
	apply_central_impulse(transform.basis.y * impulse)
	damage(damage, 0, 0.0, null)
	heat = 20.0
