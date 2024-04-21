extends WorldEnvironment


func _ready():
	var max_steps: int = \
			get_node("/root/RootControl/SettingsManager").reflections
	environment.ss_reflections_max_steps = min(OS.window_size.x \
			/ get_node("/root/RootControl/SettingsManager").resolution / 4, \
			max_steps)
	environment.ss_reflections_enabled = max_steps != 0
