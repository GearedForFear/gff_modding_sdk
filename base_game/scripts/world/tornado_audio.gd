extends AudioStreamPlayer3D


func _enter_tree():
	stream = get_node("/root/RootControl/ResourceManager").tornado_audio
	play()
