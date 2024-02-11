extends WorldEnvironment


func _ready():
	var max_steps: int = \
			get_node("/root/RootControl/SettingsManager").reflections
	environment.ss_reflections_max_steps = max_steps
	environment.ss_reflections_enabled = max_steps != 0
