extends Spatial


func _ready():
	hide()
	get_node("/root/RootControl/DeletionManager").to_be_deleted.append(self)
