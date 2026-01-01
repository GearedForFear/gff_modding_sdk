extends StandardButton


func _pressed():
	Global.root_control.track = ResourceLoader.load(
			"res://scenes/world/tracks/the_calm.tscn", "PackedScene").instance()
	Global.root_control.next_tracks = ["below", "twisted"]
	._pressed()
