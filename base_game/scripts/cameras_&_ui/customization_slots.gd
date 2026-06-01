extends AspectRatioContainer


var vehicles := Array()


func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		$SlotsView/Viewport/Spatial/CodePivot/AnimationPlayer.play_backwards(
				"rotate_garage")
		yield_and_rotate(Vector3(0.0, -30.0, 0.0))
	elif Input.is_action_just_pressed("ui_right"):
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
	var skin_collection: SkinCollection = \
			SkinCollectionFactory.load_collection(vehicle_name)
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
	
	for n in 12:
		vehicles[n].set_skin(n)
