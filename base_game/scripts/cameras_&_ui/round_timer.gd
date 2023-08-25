extends ColorRect


var track: Spatial


func _ready():
	track = get_node("../../../../..").track
	$Above.text = "Stage " \
			+ String(6 - get_node("/root/RootControl").next_tracks.size())


func _physics_process(_delta):
	$TimeLeft.text = \
			String(int(track.get_node("GameplayManager/Timer").time_left))
