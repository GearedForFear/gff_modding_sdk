extends Node


const ABSORB_COLOR := Color("00ff6a")
const DEFLECT_COLOR := Color("ff3600")

export var absorb_resource: Resource
export var deflect_resource: Resource
export var meshes: Array


func absorb(vehicle: CombatVehicle):
	if vehicle.ammo < absorb_resource.ammo_cost:
		return
	
	vehicle.shield_mode = CombatVehicle.ShieldModes.ABSORB
	vehicle.ammo -= absorb_resource.ammo_cost
	set_color(vehicle, ABSORB_COLOR)


func deflect(vehicle: CombatVehicle):
	if vehicle.ammo < deflect_resource.ammo_cost:
		return
	
	vehicle.shield_mode = CombatVehicle.ShieldModes.DEFLECT
	vehicle.ammo -= deflect_resource.ammo_cost
	set_color(vehicle, DEFLECT_COLOR)


func disable(vehicle: CombatVehicle):
	vehicle.shield_mode = CombatVehicle.ShieldModes.OFF
	set_color(vehicle, Color.black)


func set_color(vehicle: CombatVehicle, color: Color):
	vehicle.get_node("BodyMesh").get_surface_material(0).set_shader_param(
			"emission", color)
