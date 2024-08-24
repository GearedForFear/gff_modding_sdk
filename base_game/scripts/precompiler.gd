extends ViewportContainer


var materials: Array
var position_in_array: int = 0

onready var mesh: MeshInstance = $Viewport/Camera/MeshInstance
onready var gles3: bool = OS.get_current_video_driver() == 0


func _process(_delta):
	if materials.size() > 1:
		mesh.material_override = materials[position_in_array]
		position_in_array = (position_in_array + 1) % (materials.size() - 1)


func add_materials():
	for array in ResourceLoader.load(\
			"res://resources/custom/precompiled_materials.tres", \
			"Resource").array:
		for material_path in array:
			materials.append(ResourceLoader.load(material_path, "Material"))


func emit_particles():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		for n in $Viewport/Camera/Particles.get_children():
			n.emitting = true
	else:
		for n in $Viewport/Camera/CPUParticles.get_children():
			n.emitting = true


func _on_Precompiler_visibility_changed():
	var rendering: bool = get_parent().visible
	set_process(rendering)
	$Viewport/Camera/WorldEnvironment._ready()
	if gles3:
		for n in $Viewport/Camera/Particles.get_children():
			n.emitting = rendering
		if has_node("Viewport/Camera/CPUParticles"):
			$Viewport/Camera/CPUParticles.queue_free()
	else:
		for n in $Viewport/Camera/CPUParticles.get_children():
			n.emitting = rendering
		if has_node("Viewport/Camera/Particles"):
			$Viewport/Camera/Particles.queue_free()
