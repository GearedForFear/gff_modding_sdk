extends Node


var viewports: Array
var position: int = 0


func _process(_delta):
	if viewports.empty():
		set_process(false)
		return
	position = (position + 1) % viewports.size()
	if is_instance_valid(viewports[position]):
		viewports[position].render_target_update_mode = Viewport.UPDATE_ONCE
		return
	viewports.remove(position)
