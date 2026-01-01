class_name Precompiler
extends ViewportContainer


var materials: Array
var position_in_array: int = 0
var can_finish: bool = false

onready var mesh: MeshInstance = $Viewport/Camera/MeshInstance


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		$Viewport/Camera/CPUParticles.queue_free()
	else:
		var camera: Camera = $Viewport/Camera
		get_node("/root/RootControl/DeletionManager").to_be_deleted.append(\
				camera.get_node("Particles"))
		camera.remove_child(camera.get_node("Particles"))
		camera.get_node("CPUParticles").name = "Particles"


func _process(_delta):
	if materials.size() > 1:
		mesh.material_override = materials[position_in_array]
		position_in_array += 1
		if position_in_array == materials.size():
			if can_finish:
				hide()
				var loading: Control = get_node_or_null(\
						"/root/FrontContainer/Loading")
				loading.hide()
				set_process(false)
			else:
				position_in_array = 0


static func get_this() -> Precompiler:
	return MaterialManager.get_this().get_node("Precompiler") as Precompiler


func start():
	if is_inside_tree():
		var loading: Control = get_node_or_null("/root/FrontContainer/Loading")
		if loading != null:
			loading.show()
	set_process(true)
	emit_particles()
	position_in_array = 0


func add_materials():
	for array in ResourceLoader.load(\
			"res://resources/custom/precompiled_materials.tres", \
			"Resource").array:
		for material_path in array:
			if material_path.begins_with(
					"res://resources/materials/vehicles/wheels_standard/"):
				materials.append(ResourceLoader.load(material_path.replace(
						"wheels_standard", "wheels_standard/front"),
						"Material"))
				materials.append(ResourceLoader.load(material_path.replace(
						"wheels_standard", "wheels_standard/back"),
						"Material"))
			else:
				materials.append(ResourceLoader.load(material_path, "Material"))
	
	var skin_names := Array()
	for skin_name in ResourceLoader.load(\
			"res://resources/custom/skin_names.tres", \
			"Resource").array:
		skin_names.append("/" + skin_name + ".material")
	var body_skins: Array = skin_names.duplicate()
	body_skins.append("/flame.material")
	var wheel_skins: Array = skin_names.duplicate()
	var weapon_skins: Array = skin_names.duplicate()
	
	var body_folders := Array()
	var wheel_folders := Array()
	var weapon_folders := Array()
	for folder in ResourceLoader.load(\
			"res://resources/custom/skin_folders.tres", \
			"Resource").array:
		if folder.begins_with("wheels_"):
			wheel_folders.append(folder + "/front")
			wheel_folders.append(folder + "/back")
		elif folder.begins_with("../weapon_components/"):
			weapon_folders.append(folder)
		else:
			body_folders.append(folder)
	
	for folder in body_folders:
		for skin_name in body_skins:
			materials.append(ResourceLoader.load(\
					"res://resources/materials/vehicles/"
					+ folder + skin_name, "Material"))
	for folder in wheel_folders:
		for skin_name in wheel_skins:
			materials.append(ResourceLoader.load(\
					"res://resources/materials/vehicles/"
					+ folder + skin_name, "Material"))
	for folder in weapon_folders:
		for skin_name in weapon_skins:
			materials.append(ResourceLoader.load(\
					"res://resources/materials/vehicles/"
					+ folder + skin_name, "Material"))


func emit_particles():
	for n in $Viewport/Camera/Particles.get_children():
		n.emitting = true


func _on_Precompiler_visibility_changed():
	pass
#	var rendering: bool = get_parent().visible
#	for n in $Viewport/Camera/Particles.get_children():
#		n.emitting = rendering
