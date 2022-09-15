extends MeshInstance


var deletion_manager: Node


func _ready():
	set_as_toplevel(true)
	$AnimationPlayer.play("sparks")


func _on_AnimationPlayer_animation_finished(_anim_name):
	set_process(false)
	hide()
	deletion_manager.to_be_deleted.append(self)


func _on_VisibilityNotifier_screen_exited():
	set_process(false)
	hide()
	deletion_manager.to_be_deleted.append(self)
