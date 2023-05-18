extends ColorRect


var track: Spatial


func _ready():
	track = get_node("../../../../..").track


func _physics_process(_delta):
	$Above.text = "Stage " \
			+ String(6 - get_node("/root/RootControl").next_tracks.size())
	$TimeLeft.text = \
			String(int(track.get_node("GameplayManager/Timer").time_left))
