extends Button


export var players: int = 1


func _pressed():
	get_node("/root/RootControl/ButtonPressAudio").play()
	get_node("/root/RootControl").player_amount = players
	get_node("/root/RootControl").play()
