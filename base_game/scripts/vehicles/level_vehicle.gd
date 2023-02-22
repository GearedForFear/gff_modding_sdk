class_name LevelVehicle
extends CombatVehicle


export var max_level: bool = false

var level: int = 1
var xp: float = 0.0


func _physics_process(_delta):
	level = xp / 20 + 1
	xp = clamp(xp - 0.1, 0, 100)
	level = clamp(level, 1, 5)


func burst() -> int:
	xp += 6.0
	return level
