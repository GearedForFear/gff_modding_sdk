extends StandardButton


func _pressed():
	GlobalAudio.play("ButtonPressAudio")
	Global.root_control.player_amount = get_position_in_parent() + 1
	MenuManager.escape()
