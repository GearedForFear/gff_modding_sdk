class_name MaterialManager
extends Node


const MONEY: ShaderMaterial = \
		preload("res://resources/materials/collectibles/money.material")
const EXPLOSION_0: ShaderMaterial = \
		preload("res://resources/materials/destruction/explosion_0.material")
const EXPLOSION_1: ShaderMaterial = \
		preload("res://resources/materials/destruction/explosion_1.material")
const BUZZSAW: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/buzzsaw.material")
const WATER_0: ShaderMaterial = \
		preload("res://resources/materials/world/decorations/water_0.material")
const WATER_1: ShaderMaterial = \
		preload("res://resources/materials/world/decorations/water_1.material")

const ColorBillboardUnshaded: Shader = \
		preload("res://shaders/simple/color_billboard_unshaded.gdshader")
const ColorNoSpecular: Shader = \
		preload("res://shaders/simple/color_no_specular.gdshader")
const ColorNoSpecularNoCull: Shader = \
		preload("res://shaders/simple/color_no_specular_no_cull.gdshader")
const TextureNoSpecular: Shader = \
		preload("res://shaders/simple/texture_no_specular.gdshader")
const MoneyShader: Shader = \
		preload("res://shaders/collectibles/money.gdshader")
const Tornado: Shader = \
		preload("res://shaders/world/gameplay_objects/tornado.gdshader")
const TornadoNoFade: Shader = \
		preload("res://shaders/world/gameplay_objects/tornado_no_fade.gdshader")
const IcelandScriptDefault: Shader = \
		preload("res://shaders/world/maps/iceland.gdshader")

const IcelandScriptNoTexture: Shader = \
		preload("res://shaders/world/maps/iceland_no_texture.gdshader")
const USAScriptNoTexture: Shader = \
		preload("res://shaders/world/maps/usa_no_texture.gdshader")

const IcelandScriptGLES2NoTexture: Shader = \
		preload("res://shaders/world/maps/iceland_gles2_no_texture.gdshader")
const USAScriptGLES2NoTexture: Shader = \
		preload("res://shaders/world/maps/usa_gles2_no_texture.gdshader")

const RockUSAColor: Color = Color("bb885f")
const TornadoUSAColor: Color = Color("cc9a76")

var rock_usa_material: ShaderMaterial
var tornado_material: ShaderMaterial
var iceland_material: ShaderMaterial
var usa_material: ShaderMaterial


func update_settings():
	if rock_usa_material == null:
		rock_usa_material = ResourceLoader.load(\
				"res://resources/materials/world/decorations/rock_usa.material",
				"ShaderMaterial")
		tornado_material = ResourceLoader.load(\
				"res://resources/materials/world/gameplay_objects/tornado.material",
				"ShaderMaterial")
		iceland_material = ResourceLoader.load(\
				"res://resources/materials/world/maps/iceland.material",
				"ShaderMaterial")
		usa_material = ResourceLoader.load(\
				"res://resources/materials/world/maps/usa.material",
				"ShaderMaterial")
	match get_node("/root/RootControl/SettingsManager").materials:
		0:
			MONEY.shader = ColorBillboardUnshaded
			
			rock_usa_material.shader = ColorNoSpecular
			rock_usa_material.set_shader_param("albedo", RockUSAColor)
			
			tornado_material.shader = ColorNoSpecularNoCull
			tornado_material.set_shader_param("albedo", TornadoUSAColor)
			
			if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
				iceland_material.shader = IcelandScriptNoTexture
				usa_material.shader = USAScriptNoTexture
			else:
				iceland_material.shader = IcelandScriptGLES2NoTexture
				usa_material.shader = USAScriptGLES2NoTexture
		1:
			enable_textures()
			
			var tornado_image: StreamTexture = ResourceLoader.load(\
					"res://resources/images/world/tornado.png", \
					"ImageTexture")
			tornado_material.shader = TornadoNoFade
			tornado_material.set_shader_param("albedo", TornadoUSAColor)
			tornado_material.set_shader_param("texture_albedo",
					tornado_image)
		2:
			enable_textures()
			
			var tornado_image: StreamTexture = ResourceLoader.load(\
					"res://resources/images/world/tornado.png", \
					"ImageTexture")
			tornado_material.shader = Tornado
			tornado_material.set_shader_param("albedo", TornadoUSAColor)
			tornado_material.set_shader_param("texture_albedo",
					tornado_image)
	compile_shaders()


static func get_this() -> MaterialManager:
	return Global.root_control.get_node("MaterialManager") as MaterialManager


static func compile_shaders():
	get_this().get_node("Precompiler").start()


func enable_textures():
	MONEY.shader = MoneyShader
	
	var usa_image: StreamTexture = ResourceLoader.load(\
			"res://resources/images/world/usa.png", \
			"ImageTexture")
	
	rock_usa_material.shader = TextureNoSpecular
	rock_usa_material.set_shader_param("texture_albedo", usa_image)
	
	iceland_material.shader = IcelandScriptDefault
	iceland_material.set_shader_param("texture_albedo",
			ResourceLoader.load(\
			"res://resources/images/world/iceland.png",
			"ImageTexture"))
	
	usa_material.shader = TextureNoSpecular
	usa_material.set_shader_param("texture_albedo", usa_image)


func set_colors(var track_data: TrackData):
	for n in [WATER_0, WATER_1]:
		n.set_shader_param("albedo_0", track_data.water_color_0)
		n.set_shader_param("albedo_1", track_data.water_color_1)


func set_movement(var b: bool):
	for n in [EXPLOSION_0, EXPLOSION_1, BUZZSAW]:
		n.set_shader_param("rotate", b)
	for n in [WATER_0, WATER_1]:
		n.set_shader_param("move", b)
