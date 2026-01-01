extends Spatial


func _ready():
	hide()
	DeletionManager.add_to_stack(self)
