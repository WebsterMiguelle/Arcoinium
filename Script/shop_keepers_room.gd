extends ColorRect

@onready var dialogue_area: Marker2D = $"Dialogue Area"
const DIALOGUE = preload("uid://dv278qg6j2epd")
const CREDITS_SCENE = preload("res://Scene/Credits.tscn")

@onready var basic_button: TextureButton = $"Basic Mode"
@onready var advance_button: TextureButton = $"Advance Mode"
@onready var credits_button: TextureButton = $"Credits Button"
@onready var basic_mode_label: Label = $"Basic Mode/BasicModeLabel"
@onready var advance_mode_label: Label = $"Advance Mode/AdvanceModeLabel"
@onready var credits_label: Label = $"Credits Button/Credits Label"

var tutorial_advance_mode: bool = false
var dialogue: Node2D = null
var has_encountered_basic = false
var has_encountered_advance = false
var current_mode = ""

# Animation Variables
var basic_base_y: float
var advance_base_y: float
var credits_base_y: float
var credits_base_x: float
var lift_amount: float = 20.0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Wait exactly one frame for Godot to arrange the UI before grabbing positions
	await get_tree().process_frame 
	basic_mode_label.visible = false
	advance_mode_label.visible = false
	credits_label.visible = false
	if is_instance_valid(basic_button) and is_instance_valid(advance_button):
		basic_base_y = basic_button.position.y
		advance_base_y = advance_button.position.y
		credits_base_y = credits_button.position.y
	if is_instance_valid(credits_button):
		credits_base_x = credits_button.position.x
	_spawn_dialogue()
	_play("welcome", DialogueBox.TailSide.LEFT)

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

# ==========================================
# ANIMATION HELPER
# ==========================================
func animate_hover(button: Control, target_y: float) -> void:
	if not is_instance_valid(button): return
	var tween = create_tween()
	tween.tween_property(button, "position:y", target_y, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# ==========================================
# BUTTON LOGIC
# ==========================================
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
	animate_hover(advance_button, advance_base_y - lift_amount)
	advance_mode_label.visible = true
	if current_mode == "advance":
		return
	current_mode = "advance"
	
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.queue_free()
		dialogue = null
	
	_spawn_dialogue()
	_play("advance_first" if not has_encountered_advance else "advance_return")
	has_encountered_advance = true

func _on_advance_mode_mouse_exited() -> void:
	animate_hover(advance_button, advance_base_y)
	advance_mode_label.visible = false 

func _on_advance_mode_pressed() -> void:
	SceneTransition.tutorial_advance_mode = true
	SceneTransition.tutorial_from_startup = false
	SceneTransition.load_scene("res://Scene/tutorial_main.tscn")

func _on_basic_mode_mouse_entered() -> void:
	animate_hover(basic_button, basic_base_y - lift_amount) 
	basic_mode_label.visible = true
	if current_mode == "basic":
		return
	current_mode = "basic"
	
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.queue_free()
		dialogue = null
	
	_spawn_dialogue()
	_play("basic_first" if not has_encountered_basic else "basic_return")
	has_encountered_basic = true

func _on_basic_mode_mouse_exited() -> void:
	animate_hover(basic_button, basic_base_y)
	basic_mode_label.visible = false

func _on_basic_mode_pressed() -> void:
	SceneTransition.tutorial_advance_mode = false
	SceneTransition.tutorial_from_startup = false
	SceneTransition.load_scene("res://Scene/tutorial_main.tscn")

func _on_archive_button_pressed() -> void:
	SceneTransition.load_scene("res://Scene/archive.tscn")


func _on_credits_button_pressed() -> void:
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.queue_free()
		dialogue = null
	credits_button.disabled = true
	var tween_out = create_tween()
	tween_out.tween_property(credits_button, "position:x", credits_base_x + 500, 0.4)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween_out.finished
	var credits_instance = CREDITS_SCENE.instantiate()
	add_child(credits_instance)
	await credits_instance.tree_exited
	var tween_in = create_tween()
	tween_in.tween_property(credits_button, "position:x", credits_base_x, 0.4)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween_in.finished
	credits_button.disabled = false

func _on_credits_button_mouse_entered() -> void:
	animate_hover(credits_button, credits_base_y - lift_amount) 
	credits_label.visible = true
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.queue_free()
		dialogue = null
	_play("credits")


func _on_credits_button_mouse_exited() -> void:
	animate_hover(credits_button, credits_base_y) 
	credits_label.visible = false


func _on_archive_button_mouse_entered() -> void:
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.queue_free()
		dialogue = null
	_spawn_dialogue()
	_play("archive")
