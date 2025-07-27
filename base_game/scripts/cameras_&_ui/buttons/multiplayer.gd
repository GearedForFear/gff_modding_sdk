extends Button


func _pressed():
	get_node("/root/RootControl/ButtonPressAudio").play()
	if Global.root_control.player_amount == 1:
		hide()
		get_node("../Viewports/Multiplayer").hide()
		get_node("../PlayerAmount").show()
		get_node("../PlayerAmount/Players2").grab_focus()
	else:
		Global.root_control.player_amount = 1
		update()


func update():
	var singleplayer: bool = Global.root_control.player_amount == 1
	if singleplayer:
		text = "MULTIPLAYER"
	else:
		text = "SINGLEPLAYER"
	if get_node_or_null("../Viewports") != null:
		get_node("../Viewports/Multiplayer/Viewport/Body").visible = singleplayer
		get_node("../Viewports/Multiplayer/Viewport/Body2").visible = singleplayer
		get_node("../Viewports/Multiplayer/Viewport/Body3").visible = singleplayer
		get_node("../Viewports/Multiplayer/Viewport/Body5").visible = singleplayer
		get_node("../Viewports/Multiplayer/Viewport/Body6").visible = singleplayer


func _on_Multiplayer_visibility_changed():
	update()
