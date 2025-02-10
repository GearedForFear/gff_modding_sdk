extends Button


func try_hide():
	yield(get_tree(), "idle_frame")
	if not get_parent().get_children().has(get_focus_owner()):
		get_node("../../Multiplayer").show()
		get_node("../../Viewports/Multiplayer").show()
		get_parent().hide()


func _pressed():
	get_node("/root/RootControl").player_amount = get_position_in_parent() + 2
	get_node("/root/RootControl/ButtonPressAudio").play()
	get_node("../../Multiplayer").show()
	get_node("../../Viewports/Multiplayer").show()
	get_parent().hide()
	get_node("../../Multiplayer").grab_focus()


func _on_Players2_focus_exited():
	try_hide()


func _on_Players3_focus_exited():
	try_hide()


func _on_Players4_focus_exited():
	try_hide()


func _on_Players5_focus_exited():
	try_hide()


func _on_Players6_focus_exited():
	try_hide()
