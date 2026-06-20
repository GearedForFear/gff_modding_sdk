class_name VehicleSkin
extends Resource


const SHADER_PATH_START := "res://shaders/vehicles/"
const SHADER_PATH_END := ".gdshader"

export var exterior: Resource
export var wheels: Resource
export var primary_color := Color()
export var secondary_color := Color()
export var vehicle_name: String
export var monster_truck := false
export var has_teeth := false

var body_material: ShaderMaterial
var wheel_material: ShaderMaterial
var no_cull_material: ShaderMaterial
var simple_material: ShaderMaterial
var simple_no_cull_material: ShaderMaterial


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
	monster_truck = from.monster_truck
	has_teeth = from.has_teeth
	
	generate_materials()


func generate_materials():
	if exterior.has_color_override():
		primary_color = exterior.color_override
	
	body_material = ShaderMaterial.new()
	body_material.shader = exterior.shader
	var main_texture: StreamTexture = ResourceLoader.load(
			"res://resources/images/vehicles/" + vehicle_name + "/" \
			+ vehicle_name + ".png", "StreamTexture")
	body_material.set_shader_param("main_texture", main_texture)
	body_material.set_shader_param("skin_texture_0", exterior.texture_0)
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
	var path_middle: String
	if wheels.paint_colors == 0:
		path_middle = "wheel"
	else:
		path_middle = "wheel_paint"
	var shader: Shader = ResourceLoader.load(SHADER_PATH_START + path_middle
			+ SHADER_PATH_END, "Shader")
	wheel_material.shader = shader
	wheel_material.set_shader_param("texture_sharp", wheels.texture_0)
	wheel_material.set_shader_param("texture_blurry", wheels.texture_1)
	
	no_cull_material = ShaderMaterial.new()
	no_cull_material.shader = exterior.shader_no_cull
	no_cull_material.set_shader_param("skin_texture_0", exterior.texture_0)
	no_cull_material.set_shader_param("primary_color", primary_color)
	no_cull_material.set_shader_param("secondary_color", secondary_color)
	no_cull_material.set_shader_param("gloss", exterior.gloss)
	
	simple_material = ShaderMaterial.new()
	simple_material.shader = exterior.shader_simple
	simple_material.set_shader_param("skin_texture_0", exterior.texture_0)
	simple_material.set_shader_param("primary_color", primary_color)
	simple_material.set_shader_param("secondary_color", secondary_color)
	simple_material.set_shader_param("gloss", exterior.gloss)
	
	simple_no_cull_material = ShaderMaterial.new()
	if has_teeth:
		var teeth: SkinComponent = exterior.teeth
		simple_no_cull_material.shader = teeth.shader
		if teeth.color_override == Color.black:
			simple_no_cull_material.set_shader_param("skin_texture_0",
					exterior.texture_0)
			simple_no_cull_material.set_shader_param("primary_color",
					exterior.color_override)
		else:
			simple_no_cull_material.set_shader_param("primary_color",
					teeth.color_override)
			simple_no_cull_material.set_shader_param("secondary_color",
					teeth.color_override)
		simple_no_cull_material.set_shader_param("gloss", teeth.gloss)
