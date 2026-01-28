class_name LevelVehicle
extends CombatVehicle


export var level_cap: bool = true

var level: int = 1
var xp: float = 0.0
var burst_duration: int = 0


func _physics_process(_delta):
	level = xp / 20 + 1
	xp -= 0.1
	if level_cap:
		level = clamp(level, 1, 5)
		xp = clamp(xp, 0.0, 100.0)


func try_boost() -> float:
	if Input.is_action_just_pressed(controls.boost):
		xp += 6.0
		burst_duration = 6 * level
		$LoopingAudio/BurstAudio.unit_size = level * 0.5
		$LoopingAudio/BurstAudio.play()
	if burst_duration > 0:
		burst_duration -= 1
		return boost.use(self)
	else:
		boost.set_effects(self, false)
		return 0.0
