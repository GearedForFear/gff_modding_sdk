extends Node


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		$GPU.remove_and_skip()
		get_node("/root/RootControl/DeletionManager").to_be_deleted.append($CPU)
		remove_child($CPU)
	else:
		$CPU.remove_and_skip()
		get_node("/root/RootControl/DeletionManager").to_be_deleted.append($GPU)
		remove_child($GPU)
