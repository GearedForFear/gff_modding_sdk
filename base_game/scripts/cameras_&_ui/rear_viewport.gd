extends SubViewport


func _ready():
	var root_control: Control = get_node("/root/RootControl")
	var player_amount: int = root_control.player_amount
	var settings_manager: SettingsManager\
			= root_control.get_node("SettingsManager")
	if player_amount != 1 and not settings_manager.mirror_frame_rate:
		root_control.get_node("MirrorManager").viewports.append(self)
		root_control.get_node("MirrorManager").set_process(true)
	if settings_manager.rear_view_shadows == 0 \
			or settings_manager.rear_view_shadows == 1 and player_amount > 1:
		shadow_atlas_size = 0
