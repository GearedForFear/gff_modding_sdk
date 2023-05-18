extends AmmoVehicle


var can_shoot: bool = true

onready var gun_timer: Timer = get_node("../GunTimer")


func _ready():
	if controls == null:
		driver_name = "Fungibber"
	score = 1000


func _physics_process(_delta):
	if alive:
		if controls == null:
			pass
		else:
			pass


func damage(_amount: float, reward: int, _burn: float, _shooter: VehicleBody) \
		-> int:
	return reward


func _on_GunTimer_timeout():
	can_shoot = true
