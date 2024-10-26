extends Label3D


export var height: float = 2.0


func _enter_tree():
	match get_node("../../../../..").name:
		"SpawnPoint1":
			layers = 2
			get_node("../CameraBase/Camera").cull_mask -= 2
		"SpawnPoint2":
			layers = 4
			get_node("../CameraBase/Camera").cull_mask -= 4
		"SpawnPoint3":
			layers = 8
			get_node("../CameraBase/Camera").cull_mask -= 8
		"SpawnPoint4":
			layers = 16
			get_node("../CameraBase/Camera").cull_mask -= 16
		"SpawnPoint5":
			layers = 32
			get_node("../CameraBase/Camera").cull_mask -= 32
		"SpawnPoint6":
			layers = 64
			get_node("../CameraBase/Camera").cull_mask -= 64
		_: # for Eternal Bond halves
			match get_node("../../../../../../..").name:
				"SpawnPoint1":
					layers = 2
				"SpawnPoint2":
					layers = 4
				"SpawnPoint3":
					layers = 8
				"SpawnPoint4":
					layers = 16
				"SpawnPoint5":
					layers = 32
				"SpawnPoint6":
					layers = 64


func _physics_process(_delta):
	var parent: Node = get_parent()
	global_translation = parent.global_translation + Vector3(0, height, 0)
	var score: float = parent.score
	text = String(score) + "€"
	score /= clamp(parent.gameplay_manager.pursuers[0].score, 100, 1_000_000)
	modulate = Color(1, 1, 1, score)
