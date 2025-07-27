class_name TrackData
extends Resource


export var music: PoolStringArray
export(float, 0, 100) var music_timer: float


func get_music() -> Array:
	var queue := Array()
	for n in music:
		match n:
			"STOP":
				queue.append(MusicPlayer.action.STOP)
		match n:
			"SKIP":
				queue.append(MusicPlayer.action.SKIP)
		match n:
			"PLAY_1":
				queue.append(MusicPlayer.action.PLAY_1)
		match n:
			"PLAY_2":
				queue.append(MusicPlayer.action.PLAY_2)
		match n:
			"PLAY_3":
				queue.append(MusicPlayer.action.PLAY_3)
		match n:
			"PLAY_4":
				queue.append(MusicPlayer.action.PLAY_4)
	return queue
