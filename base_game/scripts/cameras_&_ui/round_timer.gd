extends ColorRect


var track: Spatial


func _ready():
	track = get_node("../../../../..").track
	var remaining_tracks: int = get_node("/root/RootControl").next_tracks.size()
	if remaining_tracks == 0:
		$Above.text = tr("FINALE")
	else:
		$Above.text = tr("STAGE") + " " + String(6 - remaining_tracks)


func _physics_process(_delta):
	$TimeLeft.text = \
			String(int(track.get_node("GameplayManager/Timer").time_left))
