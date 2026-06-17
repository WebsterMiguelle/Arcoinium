extends CanvasLayer

signal end_run_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_end_run_pressed() -> void:
	print("Pause Menu: End Run pressed")
	emit_signal("end_run_pressed")


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/Main_Menu.tscn")
