extends Spatial


onready var deletion_manager: Node


func _enter_tree():
	deletion_manager = $DeletionManager
