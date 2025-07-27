extends Node


const Money: ShaderMaterial = \
		preload("res://resources/materials/collectibles/money.material")
const Explosion0: ShaderMaterial = \
		preload("res://resources/materials/destruction/explosion_0.material")
const Explosion1: ShaderMaterial = \
		preload("res://resources/materials/destruction/explosion_1.material")
const Buzzsaw: ShaderMaterial = \
		preload("res://resources/materials/weapon_components/buzzsaw.material")

const ColorBillboardUnshaded: Shader = \
		preload("res://resources/materials/simple_shaders/color_billboard_unshaded.gdshader")
const ColorNoSpecular: Shader = \
		preload("res://resources/materials/simple_shaders/color_no_specular.gdshader")
const ColorNoSpecularNoCull: Shader = \
		preload("res://resources/materials/simple_shaders/color_no_specular_no_cull.gdshader")
const TextureNoSpecular: Shader = \
		preload("res://resources/materials/simple_shaders/texture_no_specular.gdshader")
const MoneyShader: Shader = \
		preload("res://resources/materials/collectibles/money.gdshader")
const Tornado: Shader = \
		preload("res://resources/materials/world/decorations/tornado.gdshader")
const TornadoNoFade: Shader = \
		preload("res://resources/materials/world/decorations/tornado_no_fade.gdshader")
const IcelandScriptDefault: Shader = \
		preload("res://resources/materials/world/maps/iceland.gdshader")

const IcelandScriptNoTexture: Shader = \
		preload("res://resources/materials/world/maps/iceland_no_texture.gdshader")
const USAScriptNoTexture: Shader = \
		preload("res://resources/materials/world/maps/usa_no_texture.gdshader")

const IcelandScriptGLES2NoTexture: Shader = \
		preload("res://resources/materials/world/maps/iceland_gles2_no_texture.gdshader")
const USAScriptGLES2NoTexture: Shader = \
		preload("res://resources/materials/world/maps/usa_gles2_no_texture.gdshader")

const RockUSAColor: Color = Color("bb885f")
const TornadoUSAColor: Color = Color("cc9a76")

var rock_usa_material: ShaderMaterial
var tornado_usa_material: ShaderMaterial
var iceland_material: ShaderMaterial
var usa_material: ShaderMaterial


func update_settings():
	if rock_usa_material == null:
		rock_usa_material = ResourceLoader.load(\
				"res://resources/materials/world/decorations/rock_usa.material",
				"ShaderMaterial")
		tornado_usa_material = ResourceLoader.load(\
				"res://resources/materials/world/decorations/tornado_usa.material",
				"ShaderMaterial")
		iceland_material = ResourceLoader.load(\
				"res://resources/materials/world/maps/iceland.material",
				"ShaderMaterial")
		usa_material = ResourceLoader.load(\
				"res://resources/materials/world/maps/usa.material",
				"ShaderMaterial")
	match get_node("/root/RootControl/SettingsManager").materials:
		0:
			Money.shader = ColorBillboardUnshaded
			
			rock_usa_material.shader = ColorNoSpecular
			rock_usa_material.set_shader_param("albedo", RockUSAColor)
			
			tornado_usa_material.shader = ColorNoSpecularNoCull
			tornado_usa_material.set_shader_param("albedo", TornadoUSAColor)
			
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
			tornado_usa_material.shader = TornadoNoFade
			tornado_usa_material.set_shader_param("albedo", TornadoUSAColor)
			tornado_usa_material.set_shader_param("texture_albedo",
					tornado_image)
		2:
			enable_textures()
			
			var tornado_image: StreamTexture = ResourceLoader.load(\
					"res://resources/images/world/tornado.png", \
					"ImageTexture")
			tornado_usa_material.shader = Tornado
			tornado_usa_material.set_shader_param("albedo", TornadoUSAColor)
			tornado_usa_material.set_shader_param("texture_albedo",
					tornado_image)
	get_node("/root/RootControl/Precompiler").start()


func enable_textures():
	Money.shader = MoneyShader
	
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


func set_movement(var b: bool):
	Explosion0.set_shader_param("rotate", b)
	Explosion1.set_shader_param("rotate", b)
	Buzzsaw.set_shader_param("rotate", b)
