extends Node


const Explosion0: ShaderMaterial = \
		preload("res://resources/materials/destruction/explosion_0.material")
const Explosion1: ShaderMaterial = \
		preload("res://resources/materials/destruction/explosion_1.material")
const Buzzsaw: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/buzzsaw.material")


func _ready():
	set_parameters(true)


func set_parameters(var b: bool):
	Explosion0.set_shader_param("rotate", b)
	Explosion1.set_shader_param("rotate", b)
	Buzzsaw.set_shader_param("rotate", b)
