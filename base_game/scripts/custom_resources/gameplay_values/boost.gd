class_name Boost
extends Resource


enum Inputs {NONE, PRESSED, JUST_PRESSED, JUST_RELEASED}

export(float, 0.0, 16_000_000.0) var force = 8000.0


func prepare(_vehicle: VehicleBody):
	pass


func use(_vehicle: VehicleBody, _input: int) -> float:
	return 0.0


func set_effects(_vehicle: VehicleBody, _enable: bool):
	pass
