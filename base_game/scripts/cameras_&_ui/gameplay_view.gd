extends VBoxContainer


func set_views(cameras: Array):
	return
	cameras[0].get_parent().remove_child(cameras[0])
	$HBoxContainer.add_child(cameras[0])
	#spawns[1].get_parent().remove_child(spawns[1])
	#$HBoxContainer2.add_child(spawns[1])
