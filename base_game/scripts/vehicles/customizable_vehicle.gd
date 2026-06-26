class_name CustomizableVehicle
extends VehicleBody


enum MeshCategories {MAIN, WHEELS, NO_CULL, SIMPLE, SIMPLE_NO_CULL}

export var body_values: Resource
export var meshes := [[NodePath("BodyMesh")], [], [], [], []]
export var skins_implemented := false


func set_skin(skin_number: int):
	var skin_collection: SkinCollection = \
			SkinCollectionFactory.load_collection(body_values.vehicle_file_name)
	var skin: VehicleSkin = skin_collection.skins[skin_number]
	
	for n in meshes[MeshCategories.MAIN]:
		var body_mesh: MeshInstance = get_node(n)
		var texture: StreamTexture = body_mesh.get_surface_material(0).get_shader_param("main_texture")
		var material: ShaderMaterial = skin.body_material.duplicate()
		material.set_shader_param("main_texture", texture)
		body_mesh.set_surface_material(0, material)
	
	for n in meshes[MeshCategories.WHEELS]:
		var wheel_mesh: MeshInstance = get_node(n)
		wheel_mesh.mesh = skin.wheels.mesh
		wheel_mesh.set_surface_material(0, skin.wheel_material.duplicate())
	
	if not meshes[MeshCategories.NO_CULL].empty():
		var texture: StreamTexture = get_node(meshes[2][0]).\
				get_surface_material(0).get_shader_param("main_texture")
		skin.no_cull_material.set_shader_param("main_texture", texture)
		for n in meshes[MeshCategories.NO_CULL]:
			get_node(n).set_surface_material(0, skin.no_cull_material)
	
	for n in meshes[MeshCategories.SIMPLE]:
		get_node(n).set_surface_material(0, skin.simple_material)
		
	for n in meshes[MeshCategories.SIMPLE_NO_CULL]:
		get_node(n).set_surface_material(0, skin.simple_no_cull_material)
