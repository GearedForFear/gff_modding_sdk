extends MeshInstance


var deletion_manager: Node
var visible_on: Array

onready var pools: Node = get_node("../..")


func start(global_transform: Transform):
	self.global_transform = global_transform
	set_physics_process(true)
	set_process(true)
	show()
	reset_physics_interpolation()
	$AnimationPlayer.play("sparks")


func stop():
	$AnimationPlayer.stop()
	set_physics_process(false)
	set_process(false)
	hide()
	pools.sparks_available.append(self)


func _on_VisibilityNotifier_camera_entered(camera):
	visible_on.append(camera)


func _on_VisibilityNotifier_camera_exited(camera):
	visible_on.erase(camera)
	if visible_on.empty() and $AnimationPlayer.is_playing():
		stop()


func _on_AnimationPlayer_animation_finished(_anim_name):
	stop()
