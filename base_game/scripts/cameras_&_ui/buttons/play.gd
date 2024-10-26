extends Button


export var players: int = 1


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	root_control.get_node("ButtonPressAudio").play()
	root_control.player_amount = players
	root_control.play()
