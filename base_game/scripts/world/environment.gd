extends WorldEnvironment


func _ready():
	environment.ss_reflections_max_steps \
			= get_node("/root/RootControl/SettingsManager").reflections
