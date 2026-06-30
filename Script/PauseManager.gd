extends Node

var is_paused: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func pause():
	is_paused = true
	Engine.time_scale = true  

func resume():
	is_paused = false
	Engine.time_scale = false
