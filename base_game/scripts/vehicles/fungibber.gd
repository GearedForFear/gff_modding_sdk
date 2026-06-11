extends AmmoVehicle


var can_shoot: bool = true

onready var gun_timer: Timer = get_node("../GunTimer")


func _physics_process(_delta):
	if alive:
		if controls == null:
			pass
		else:
			pass


func damage(_amount: float, reward: int, _burn: float, _shooter: VehicleBody) \
		-> int:
	return reward


func reduce_health(_amount: float, _shooter: VehicleBody) -> int:
	return 0


func _on_GunTimer_timeout():
	can_shoot = true
