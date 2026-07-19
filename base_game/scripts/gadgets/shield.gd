class_name Shield
extends MeshInstance


func _ready():
	get_parent().connect("light_shield_remaining_changed", self,
			"_on_light_shield_remaining_changed")
	get_parent().connect("death", self, "_on_death")


func _on_light_shield_remaining_changed(new: int, vehicle: CombatVehicle):
	if new > 0 and vehicle.shield_mode == CombatVehicle.ShieldModes.OFF:
		vehicle.shield_mode = CombatVehicle.ShieldModes.LIGHT
		visible = vehicle.alive
	elif new == 0:
		vehicle.shield_mode = CombatVehicle.ShieldModes.OFF
		hide()


func _on_death():
	hide()
