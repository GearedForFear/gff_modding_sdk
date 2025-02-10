extends SubViewport


func _ready():
	var root_control: Control = get_node("/root/RootControl")
	if root_control.player_amount != 1 and \
			not root_control.get_node("SettingsManager").mirror_frame_rate:
		root_control.get_node("MirrorManager").viewports.append(self)
		root_control.get_node("MirrorManager").set_process(true)
