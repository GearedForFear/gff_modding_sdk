extends Particles


func _enter_tree():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		emitting = true
	else:
		DeletionManager.add_to_stack(self)
