extends Node


func _ready():
	get_node("/root/RootControl/DeletionManager").to_be_deleted.append(self)
