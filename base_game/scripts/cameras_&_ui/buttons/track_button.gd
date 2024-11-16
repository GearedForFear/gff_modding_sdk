extends Button


export var track_path: String = "res://scenes/world/tracks/downpour.tscn"


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	get_parent().hide()
	while root_control.thread.is_alive():
		yield(get_tree(), "idle_frame")
	var path: String
	root_control.switch_buttons(get_parent(), \
			get_node("../../PlayerButtons/OnePlayer"))
	root_control.get_node("ButtonPressAudio").play()
	if track_path == "":
		path = "res://scenes/world/tracks/figure_8.tscn"
		root_control.next_tracks = ["res://scenes/world/tracks/glacier.tscn",
		"res://scenes/world/tracks/twisted.tscn"]
	else:
		path = track_path
		root_control.next_tracks = []
	root_control.spawn_track(path)
