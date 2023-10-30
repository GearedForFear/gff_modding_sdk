extends Spatial


func _ready():
	var deletion_manager: Node = get_node("../DeletionManager")
	if OS.get_current_video_driver() == 0:
		$GPU.emitting = true
		deletion_manager.to_be_deleted.append($CPU)
	else:
		$CPU.emitting = true
		deletion_manager.to_be_deleted.append($GPU)
