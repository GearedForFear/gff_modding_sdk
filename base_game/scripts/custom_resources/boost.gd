class_name Boost
extends Resource


export(float, 0.0, 16_000_000.0) var force = 8000.0


func prepare(vehicle: VehicleBody):
	pass


func use(vehicle: VehicleBody) -> float:
	return 0.0


func set_effects(vehicle: VehicleBody, enable: bool):
	pass
