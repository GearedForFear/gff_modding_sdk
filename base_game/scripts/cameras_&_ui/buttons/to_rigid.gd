extends Button


func _pressed():
	get_node("/root/RootControl").switch_buttons(get_parent(), \
			get_node("../../MaxRigidBodiesButtons/Rigid100"))
	get_node("/root/RootControl/ButtonPressAudio").play()


func _on_MaxRigidBodies_focus_entered():
	get_node("../../Warning").show()


func _on_MaxRigidBodies_focus_exited():
	if get_parent().visible:
		get_node("../../Warning").hide()
