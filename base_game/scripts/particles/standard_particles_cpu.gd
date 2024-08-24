extends CPUParticles


func _enter_tree():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES2:
		emitting = true
	else:
		get_node("/root/RootControl").track.deletion_manager.to_be_deleted.append(self)
