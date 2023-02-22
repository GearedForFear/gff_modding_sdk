extends AudioStreamPlayer3D


var deletion_manager: Node


func _on_AudioStreamPlayer3D_finished():
	set_process(false)
	hide()
	deletion_manager.to_be_deleted.append(self)
