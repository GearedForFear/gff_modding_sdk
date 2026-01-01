extends Node


func _ready():
	DeletionManager.add_array_to_stack([$GPU, $CPU])
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		$GPU.remove_and_skip()
		remove_child($CPU)
	else:
		$CPU.remove_and_skip()
		remove_child($GPU)
