extends Node2D
@onready var sound_manager: Node2D = $SoundManager
const IN_THIS_WORLD_OF_COINS = preload("uid://bkxiylr3twixl")
const COIN_FLIP = preload("uid://bmscttmxwr782")


@onready var label: Label = $CanvasLayer/Dialogue
var _queue: Array = []
var _playing = false
signal dialogue_finished
const LINE_DURATION = 2.0
const CHARS_PER_SECOND = 30.0
@onready var shopkeeper: TextureRect = $CanvasLayer/Shopkeeper

var yes_base_y: float
var no_base_y: float
var lift_amount: float = 20.0 
@onready var yes_button: TextureButton = $CanvasLayer/YesButton
@onready var no_button: TextureButton = $CanvasLayer/NoButton
@onready var yes_label: Label = $CanvasLayer/YesButton/Yes
@onready var no_label: Label = $CanvasLayer/NoButton/No
var current_mode = ""


const LINES = {
	"welcome": [
		"Greetings Coin Caster. Before purging the\nCorruption, would you like to remember your \nCasting Skills? (Enter Tutorial)"
		 ],
	"yes":["Very well then. Ready your Coins."],
	"no":["Then may you defeat the\nSage of Twilight, Caster.\nDon't let the Greed consume you."]
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	sound_manager.play_music(IN_THIS_WORLD_OF_COINS)
	play("welcome")
	var fade_tween = create_tween()
	fade_tween.tween_property(shopkeeper,"self_modulate",Color.WHITE,1.0)
	await get_tree().process_frame 
	yes_label.visible = false
	no_label.visible = false
	if is_instance_valid(yes_button) and is_instance_valid(no_button):
		yes_base_y = 500
		no_base_y = 500
	await dialogue_finished
	var tween = create_tween().set_parallel(true)
	tween.tween_property(yes_button, "position:y", 500, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(no_button, "position:y", 500, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play(key: String) -> void:
	if not LINES.has(key):
		push_warning("Dialogue: unknown key '%s'" % key)
		return
	_queue = LINES[key].duplicate()
	_playing = true
	_next()
	
func _next() -> void:
	if _queue.is_empty():
		_playing = false
		#close()
		dialogue_finished.emit()
		return
		
	label.text = ""
	if modulate.a < 0.9:
		modulate.a = 0
		var tween = create_tween()
		tween.parallel().tween_property(self, "modulate:a", 1, 0.2)
		tween.parallel().tween_property(self, "position:y", position.y + 80, 0.2)
		await tween.finished
	
	var txt = _queue.pop_front()
	await _set_text(txt)
	await get_tree().create_timer(LINE_DURATION).timeout
	_next()
	
func _set_text(txt: String) -> void:
	label.text = ""
	label.visible_characters = 0
	
	var char_count = txt.length()
	var duration = char_count / CHARS_PER_SECOND
	
	label.text = txt
	label.visible_characters = 0
	
	var tween = create_tween()
	tween.tween_property(label, "visible_characters", char_count, duration) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	
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

func _on_no_button_mouse_entered() -> void:
	animate_hover(no_button, no_base_y - lift_amount)
	no_label.visible = true
	if current_mode == "no":
		return
	current_mode = "no"
	

func _on_no_button_mouse_exited() -> void:
	animate_hover(no_button, no_base_y)
	no_label.visible = false 


func _on_no_button_pressed() -> void:
	sound_manager.play_sound(COIN_FLIP)
	play("no")
	yes_base_y = 1000
	no_base_y = 1000
	var tween = create_tween().set_parallel(true)
	tween.tween_property(yes_button, "position:y", 1000, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(no_button, "position:y", 1000, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await dialogue_finished
	var shrink = create_tween()
	shrink.tween_property(shopkeeper,"scale", Vector2(0.7,0.7), 5)
	
	SceneTransition.load_scene_fade("res://Scene/SplashScreen.tscn", 1)



func _on_yes_button_mouse_entered() -> void:
	animate_hover(yes_button, yes_base_y - lift_amount) 
	yes_label.visible = true
	if current_mode == "yes":
		return
	current_mode = "yes"


func _on_yes_button_mouse_exited() -> void:
	animate_hover(yes_button, yes_base_y)
	yes_label.visible = false


func _on_yes_button_pressed() -> void:
	sound_manager.play_sound(COIN_FLIP)
	play("yes")
	yes_base_y = 1000
	no_base_y = 1000
	var tween = create_tween().set_parallel(true)
	tween.tween_property(yes_button, "position:y", 1000, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(no_button, "position:y", 1000, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	await dialogue_finished
	SceneTransition.tutorial_advance_mode = false
	SceneTransition.tutorial_from_startup = true
	SceneTransition.load_scene("res://Scene/tutorial_main.tscn")
