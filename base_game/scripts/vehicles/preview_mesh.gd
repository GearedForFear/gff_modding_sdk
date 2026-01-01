extends MeshInstance


const BLACK_MATERIAL: ShaderMaterial = \
		preload("res://resources/materials/simple/unshaded_black.tres")


func hide_texture():
	set_surface_material(0, BLACK_MATERIAL)
