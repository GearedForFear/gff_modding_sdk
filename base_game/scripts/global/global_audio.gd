class_name GlobalAudio
extends Node


static func play(audio_name: String):
	Global.root_control.get_node("GlobalAudio/" + audio_name).try_play()
