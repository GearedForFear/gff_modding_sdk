extends AspectRatioContainer


var vehicles := Array()
var preview_position: int = 0
var skin_position: int = 0
var skin_amount: int


func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		move(-1)
		$SlotsView/Viewport/Spatial/CodePivot/AnimationPlayer.play_backwards(
				"rotate_garage")
		yield_and_rotate(Vector3(0.0, -30.0, 0.0))
	elif Input.is_action_just_pressed("ui_right"):
		move(1)
		$SlotsView/Viewport/Spatial/CodePivot.rotation_degrees \
				+= Vector3(0.0, 30.0, 0.0)
		$SlotsView/Viewport/Spatial/CodePivot/AnimationPlayer.play(
				"rotate_garage")
		yield_and_rotate(Vector3.ZERO)


func yield_and_rotate(rotation_degrees: Vector3):
	set_process(false)
	$SlotsView/Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	$SlotsView/Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	yield(get_node("SlotsView/Viewport/Spatial/CodePivot/AnimationPlayer"),
			"animation_finished")
	$SlotsView/Viewport/Spatial/CodePivot/AnimationPlayer.play("RESET")
	$SlotsView/Viewport/Spatial/CodePivot.rotation_degrees += rotation_degrees
	$SlotsView/Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
	yield(get_tree(), "physics_frame")
	yield(get_tree(), "physics_frame")
	$SlotsView/Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	set_process(true)


func set_vehicle(vehicle_name: String):
	$SlotsView/Viewport/Spatial/CodePivot/AnimationPlayer.play("RESET")
	$SlotsView/Viewport/Spatial/CodePivot.rotation_degrees = Vector3.ZERO
	preview_position = 0
	skin_position = 0
	var skin_collection: SkinCollection = \
			SkinCollectionFactory.load_collection(vehicle_name)
	skin_amount = skin_collection.skins.size()
	var path: String = "res://scenes/vehicles/preview/" + vehicle_name \
			+ "_preview.tscn"
	var preview_vehicle: PackedScene = ResourceLoader.load(path, "PackedScene")
	vehicles.clear()
	for n in $SlotsView/Viewport/Spatial/Previews.get_children():
		DeletionManager.add_to_garbage(n.get_child(0))
		n.remove_child(n.get_child(0))
		var vehicle: CustomizableVehicle = preview_vehicle.instance()
		vehicle.get_node("BodyMesh").set_surface_material(0,
				skin_collection.skins[0].body_material)
		n.add_child(vehicle)
		vehicles.append(vehicle)
	
	for n in 10:
		vehicles[n].set_skin(n)
	vehicles[11].set_skin(skin_amount - 1)


func move(direction: int):
	var vehicle_to_change: CustomizableVehicle = vehicles[preview_position - 2]
	if direction == -1:
		vehicle_to_change.set_skin(skin_position - 2)
	else:
		vehicle_to_change.set_skin((skin_position + 10) % skin_amount)
	preview_position = limit(preview_position + direction, 12)
	skin_position = limit(skin_position + direction, skin_amount)


func limit(position: int, upper_limit: int):
	var return_value: int = position + upper_limit
	return_value %= upper_limit
	return return_value
