class_name CustomizableVehicle
extends VehicleBody


enum MeshCategories {MAIN, WHEELS, SIMPLE, SIMPLE_NO_CULL}

export var body_values: Resource
export var meshes := [[], [], [], []]


func set_skin(skin_number: int):
	var skin_collection: SkinCollection = \
			SkinCollectionFactory.load_collection(body_values.vehicle_file_name)
	var skin: VehicleSkin = skin_collection.skins[skin_number]
	for n in meshes[MeshCategories.MAIN]:
		get_node(n).set_surface_material(0, skin.body_material)
	for n in meshes[MeshCategories.WHEELS]:
		var wheel_mesh: MeshInstance = get_node(n)
		wheel_mesh.mesh = skin.wheels.mesh
		wheel_mesh.set_surface_material(0, skin.wheel_material.duplicate())
