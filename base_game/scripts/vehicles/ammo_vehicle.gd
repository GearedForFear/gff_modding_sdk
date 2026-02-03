class_name AmmoVehicle
extends CombatVehicle


signal ammo_changed(new)

var ammo: float = 100.0


func _enter_tree():
	if controls == null:
		ammo = 0.0


func _physics_process(_delta):
	if ammo != 100.0:
		var reload: float = 0.1
		if linear_velocity.length() < 5.0:
			reload = 0.3
		ammo = min(ammo + reload, 100.0)
		emit_signal("ammo_changed", ammo)
