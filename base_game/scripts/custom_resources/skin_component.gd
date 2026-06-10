class_name SkinComponent
extends Resource


enum Categories {VEHICLE_BODY, WHEEL, MONSTER_WHEEL, OTHER}

const EXTERIORS := Array()
const WHEELS_LIST := Array()
const MONSTER_WHEELS_LIST := Array()

export(Categories) var category
export(int, 0, 2) var paint_colors
export var texture_0: Texture
export var texture_1: StreamTexture
export var mask_name: String
export var mesh: ArrayMesh
export var shader: Shader
export(float, 0.0, 1.0) var gloss = 0.0
export var color_override := Color.black
export var teeth: Resource


static func start():
	EXTERIORS.append_array(ResourceLoader.load(
			"res://resources/custom/skins/exteriors.tres").array)
	WHEELS_LIST.append_array(ResourceLoader.load(
			"res://resources/custom/skins/wheels_list.tres").array)
	MONSTER_WHEELS_LIST.append_array(ResourceLoader.load(
			"res://resources/custom/skins/monster_wheels_list.tres").array)


func get_list_position() -> int:
	return get_list(category).find(self)


static func get_list(component_category: int) -> Array:
	match component_category:
		Categories.VEHICLE_BODY:
			return EXTERIORS
		Categories.WHEEL:
			return WHEELS_LIST
		Categories.MONSTER_WHEEL:
			return MONSTER_WHEELS_LIST
	return Array()


static func get_component(component_category: int, position_in_list: int) \
		-> SkinComponent:
	return get_list(component_category)[position_in_list]


func has_color_override() -> bool:
	return color_override != Color.black
