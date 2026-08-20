class_name PickupFactory


const money_material: ShaderMaterial = preload(
		"res://resources/materials/collectibles/money.material")
const ammo_material: ShaderMaterial = preload(
		"res://resources/materials/collectibles/ammo.material")
const light_shield_material: ShaderMaterial = preload(
		"res://resources/materials/collectibles/light_shield.material")


static func create(global_transform: Transform, shooter: CombatVehicle,
		spawner: CombatVehicle, type: int, amount: int) -> Area:
	var return_value: Area = Pools.get_pickup()
	return_value.global_transform = global_transform
	return_value.shooter = shooter
	return_value.spawner = spawner
	return_value.type = type
	return_value.amount = amount
	var material: ShaderMaterial
	match type:
		GlobalEnums.PickupTypes.MONEY:
			material = money_material
		GlobalEnums.PickupTypes.AMMO:
			material = ammo_material
		GlobalEnums.PickupTypes.LIGHT_SHIELD:
			material = light_shield_material
	return_value.get_node("MeshInstance").set_surface_material(0, material)
	return_value.start()
	return return_value
