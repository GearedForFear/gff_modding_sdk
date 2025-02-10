extends Button


export var track_path: String = "res://scenes/world/tracks/downpour.tscn"


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	root_control.get_node("AspectRatioContainer/MainMenu").hide()
	root_control.get_node("ButtonPressAudio").play()
	while root_control.thread.is_alive():
		yield(get_tree(), "idle_frame")
	var path: String
	if track_path == "":
		path = "res://scenes/world/tracks/the_calm.tscn"
		root_control.next_tracks = ["res://scenes/world/tracks/below.tscn",
		"res://scenes/world/tracks/twisted.tscn"]
	else:
		path = track_path
		root_control.next_tracks = []
		get_node("../..").hide()
	root_control.spawn_track(path)
	root_control.play()
