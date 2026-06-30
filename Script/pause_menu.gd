extends CanvasLayer

signal end_run_pressed

var settings_scene = preload("res://Scene/settings_menu.tscn")
var settings_instance = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	get_tree().get_root().get_node("Main").toggle_pause()
	


func _on_end_run_pressed() -> void:
	print("Pause Menu: End Run pressed")
	emit_signal("end_run_pressed")


func _on_quit_pressed() -> void:
	PauseManager.pause()
	get_tree().change_scene_to_file("res://Scene/Main_Menu.tscn")


func _on_setting_pressed() -> void:
	if settings_instance == null:
		settings_instance = preload("res://Scene/settings_menu.tscn").instantiate()
		add_child(settings_instance)
		settings_instance.pause_menu_ui = $Panel
		
	settings_instance.visible = true
	$Panel.visible = false 
