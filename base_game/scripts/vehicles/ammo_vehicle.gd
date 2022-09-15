class_name AmmoVehicle
extends CombatVehicle


var ammo: float = 100.0


func _physics_process(_delta):
	ammo = clamp(ammo + 0.1, 0, 100)
