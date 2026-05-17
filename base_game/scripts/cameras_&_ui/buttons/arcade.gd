extends StandardButton


func _pressed():
	Global.root_control.next_tracks = ["the_calm", "below", "twisted"]
	._pressed()
