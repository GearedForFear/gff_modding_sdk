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
						"../AspectRatioContainer/Loading")
				if loading == null:
					loading = get_parent().menu_orphans[0].get_node("Loading")
				loading.hide()
				set_process(false)
			else:
				position_in_array = 0


func start():
	get_node("../AspectRatioContainer/Loading").show()
	set_process(true)
	emit_particles()
	position_in_array = 0


func add_materials():
	for array in ResourceLoader.load(\
			"res://resources/custom/precompiled_materials.tres", \
			"Resource").array:
		for material_path in array:
			materials.append(ResourceLoader.load(material_path, "Material"))


func emit_particles():
	for n in $Viewport/Camera/Particles.get_children():
		n.emitting = true


func _on_Precompiler_visibility_changed():
	var rendering: bool = get_parent().visible
	for n in $Viewport/Camera/Particles.get_children():
		n.emitting = rendering
