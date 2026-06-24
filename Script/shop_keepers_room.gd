extends ColorRect

@onready var dialogue_area: Marker2D = $"Dialogue Area"
const DIALOGUE = preload("uid://dv278qg6j2epd")

var tutorial_advance_mode: bool = false
var dialogue: Node2D = null
var has_encountered_basic = false
var has_encountered_advance = false
var current_mode = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_dialogue()
	_play("welcome",DialogueBox.TailSide.LEFT)

func _spawn_dialogue() -> void:
	dialogue = DIALOGUE.instantiate()
	add_child(dialogue)
	dialogue.setup(dialogue_area.global_position, 100)
	dialogue.dialogue_finished.connect(_on_dialogue_finished)
	
func _on_dialogue_finished() -> void:
	#dialogue = null
	pass
	
func _play(key: String, tail: DialogueBox.TailSide = DialogueBox.TailSide.LEFT) -> void:
	if dialogue == null or not is_instance_valid(dialogue):
		_spawn_dialogue()
	dialogue.set_tail(tail)
	dialogue.play(key)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_button_pressed() -> void:
	SceneTransition.load_scene("res://Scene/Main_Menu.tscn") 

func _on_back_button_mouse_entered() -> void:
	if current_mode == "back":
		return
	current_mode = "back"
	
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.queue_free()
		dialogue = null
	
	_spawn_dialogue()
	_play("back_first" if not has_encountered_advance else "back_return")
	has_encountered_advance = true

func _on_advance_mode_mouse_entered() -> void:
	if current_mode == "advance":
		return
	current_mode = "advance"
	
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.queue_free()
		dialogue = null
	
	_spawn_dialogue()
	_play("advance_first" if not has_encountered_advance else "advance_return")
	has_encountered_advance = true
	
func _on_advance_mode_pressed() -> void:
	SceneTransition.tutorial_advance_mode = true
	SceneTransition.load_scene("res://Scene/tutorial_main.tscn")

func _on_basic_mode_mouse_entered() -> void:
	
	if current_mode == "basic":
		return
	current_mode = "basic"
	
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.queue_free()
		dialogue = null
	
	_spawn_dialogue()
	_play("basic_first" if not has_encountered_basic else "basic_return")
	has_encountered_basic = true

func _on_basic_mode_pressed() -> void:
	SceneTransition.tutorial_advance_mode = false
	SceneTransition.load_scene("res://Scene/tutorial_main.tscn")


func _on_archive_button_pressed() -> void:
	SceneTransition.load_scene("res://Scene/archive.tscn")
