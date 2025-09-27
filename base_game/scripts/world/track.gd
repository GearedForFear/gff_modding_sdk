extends Spatial


export var data: Resource


func _ready():
	MaterialManager.get_this().set_colors(data)
