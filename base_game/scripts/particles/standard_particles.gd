extends Particles


func _enter_tree():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		emitting = true
	else:
		get_node("/root/RootControl").track.get_node("DeletionManager").to_be_deleted.append(self)
