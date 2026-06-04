class_name VehicleSkin
extends Resource


export var exterior: Resource
export var wheels: Resource
export var primary_color := Color()
export var secondary_color := Color()
export var vehicle_name: String
export var monster_truck := false

var body_material: ShaderMaterial
var wheel_material: ShaderMaterial


func get_bytes() -> PoolByteArray:
	var return_value: PoolByteArray = [0, 0, 0, 0, 0, 0, 0, 0]
	return_value[0] = exterior.get_list_position()
	return_value[1] = wheels.get_list_position()
	return_value[2] = primary_color.r8
	return_value[3] = primary_color.g8
	return_value[4] = primary_color.b8
	return_value[5] = secondary_color.r8
	return_value[6] = secondary_color.g8
	return_value[7] = secondary_color.b8
	return return_value


func get_hex() -> String:
	return get_bytes().hex_encode()


func set_hex(new_value: String):
	var exterior_hex: String = "0x" + new_value.substr(0, 2)
	var exterior_id = exterior_hex.hex_to_int()
	exterior = SkinComponent.get_component(
			SkinComponent.Categories.VEHICLE_BODY, exterior_id)
	
	var wheels_hex: String = "0x" + new_value.substr(2, 2)
	var wheel_id: int = wheels_hex.hex_to_int()
	var category: int
	if monster_truck:
		category = SkinComponent.Categories.MONSTER_WHEEL
	else:
		category = SkinComponent.Categories.WHEEL
	wheels = SkinComponent.get_component(category, wheel_id)
	
	primary_color = Color(new_value.substr(4, 6))
	secondary_color = Color(new_value.substr(10, 6))
	
	generate_materials()


func copy(from: VehicleSkin):
	exterior = from.exterior
	wheels = from.wheels
	primary_color = from.primary_color
	secondary_color = from.secondary_color
	vehicle_name = from.vehicle_name
	
	generate_materials()


func generate_materials():
	body_material = ShaderMaterial.new()
	
	var shader: Shader = exterior.shader
	body_material.shader = shader
	var main_texture: StreamTexture = ResourceLoader.load(
			"res://resources/images/vehicles/" + vehicle_name + "/" \
			+ vehicle_name + ".png", "StreamTexture")
	body_material.set_shader_param("main_texture", main_texture)
	body_material.set_shader_param("skin_texture_0", exterior.texture_0)
	if exterior.has_color_override():
		body_material.set_shader_param("primary_color", exterior.color_override)
	else:
		body_material.set_shader_param("primary_color", primary_color)
	body_material.set_shader_param("secondary_color", secondary_color)
	body_material.set_shader_param("gloss", exterior.gloss)
	if exterior.mask_name != "":
		var mask: StreamTexture = ResourceLoader.load(
				"res://resources/images/vehicles/" + vehicle_name + "/"
				+ vehicle_name + "_" + exterior.mask_name + ".png",
				"StreamTexture")
		body_material.set_shader_param("mask", mask)
	
	wheel_material = ShaderMaterial.new()
	wheel_material.set_shader_param("texture_sharp", wheels.texture_0)
	wheel_material.set_shader_param("texture_blurry", wheels.texture_1)
	
	var path_start := "res://shaders/vehicles/"
	var path_middle: String
	var path_end := ".gdshader"
	if wheels.paint_colors == 0:
		path_middle = "wheel"
	else:
		path_middle = "wheel_paint"
	shader = ResourceLoader.load(path_start + path_middle + path_end, "Shader")
	wheel_material.shader = shader
