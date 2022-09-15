extends Node


func modify():
	get_node("/root/RootControl/Title").text = "Modified"
	queue_free()
