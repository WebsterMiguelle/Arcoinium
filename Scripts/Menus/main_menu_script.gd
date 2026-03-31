extends Node

@onready var coin: AnimatedSprite2D = $Coin
@onready var button: Button = $Button
@onready var flip_coin_to_start: Label = $"Flip Coin to Start"
@onready var main_game_title: Label = $"Main Game Title"
@onready var sound_manager: Node2D = $SoundManager

# NEW: Reference your Glow Panel here! Update the path if you named it differently.
@onready var glow_panel: Panel = $Glow

const COIN_FLIP = preload("uid://bmscttmxwr782")
const PASSIVE_PASSIVE_INCOME = preload("uid://cl4xnombcshkv")
var is_waiting_to_stop = false
var freeze_frame_on : int = 0
var float_tween: Tween
var bounce_tween: Tween

# NEW: A dedicated tween just for the glowing pulse effect
var glow_tween: Tween 

func _ready() -> void:
	coin.play("coin_flipping")
	fading_text()
	
	# NEW: Hide the glow by default when the scene loads
	glow_panel.modulate.a = 0.1 
	
	button.mouse_entered.connect(_on_button_hovered)
	button.mouse_exited.connect(_on_button_exited)
	button.pressed.connect(_on_button_pressed)
	
	coin.frame_changed.connect(_on_frame_changed)
	
	_coin_float()
	
func _on_button_hovered() -> void:
	is_waiting_to_stop = true
	
	# NEW: Start the pulsing glow loop!
	if glow_tween: glow_tween.kill()
	glow_tween = create_tween().set_loops()
	# Pulse up to 100% visibility, then down to 40% visibility repeatedly
	glow_tween.tween_property(glow_panel, "modulate:a", 0.8, 0.5).set_trans(Tween.TRANS_SINE)
	glow_tween.tween_property(glow_panel, "modulate:a", 0.1, 0.5).set_trans(Tween.TRANS_SINE)
	
func _on_button_exited() -> void:
	is_waiting_to_stop = false
	
	if not coin.is_playing():
		coin.play()
		
	# NEW: Kill the pulse loop and fade the glow back to invisible
	if glow_tween: glow_tween.kill()
	glow_tween = create_tween()
	glow_tween.tween_property(glow_panel, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
		
func _on_button_pressed() -> void:
	sound_manager.play_sound(COIN_FLIP)
	sound_manager.play_sound(PASSIVE_PASSIVE_INCOME)
	button.disabled = true
	
	is_waiting_to_stop = false
	
	if glow_tween: glow_tween.kill()
	glow_panel.modulate.a = 0.0
	
	if float_tween:
		float_tween.kill()
	if bounce_tween:
		bounce_tween.kill()
	
	bounce_tween = create_tween()
	bounce_tween.tween_property(coin,"position:y", -500.0, 0.2).as_relative().set_trans(Tween.TRANS_LINEAR)
	
	coin.play("coin_flip_up") 
	game_title_go_up()
	SceneTransition.load_scene("res://Scene/main.tscn")
	
func _on_frame_changed() -> void:
	if is_waiting_to_stop and coin.frame == freeze_frame_on:
		coin.pause()

func _coin_float():
	button.disabled = false
	if float_tween:
		float_tween.kill()
		
	coin.play("coin_flipping")
	float_tween = create_tween().set_loops()
	
	float_tween.tween_property(coin, "position:y", -20.0, 0.5).as_relative().set_trans(Tween.TRANS_SINE)
	float_tween.parallel().tween_property(glow_panel, "position:y", -20.0, 0.5).as_relative().set_trans(Tween.TRANS_SINE)
	float_tween.parallel().tween_property(button, "position:y", -20.0, 0.5).as_relative().set_trans(Tween.TRANS_SINE)

	float_tween.tween_property(coin, "position:y", 20.0, 0.5).as_relative().set_trans(Tween.TRANS_SINE)
	float_tween.parallel().tween_property(glow_panel, "position:y", 20.0, 0.5).as_relative().set_trans(Tween.TRANS_SINE)
	float_tween.parallel().tween_property(button, "position:y", 20.0, 0.5).as_relative().set_trans(Tween.TRANS_SINE)

func fading_text():
	var tween = create_tween().set_loops()
	tween.tween_property(flip_coin_to_start,"self_modulate:a",0.0,0.5)
	tween.tween_property(flip_coin_to_start,"self_modulate:a",1.0,0.5)

func game_title_go_up():
	var tween = create_tween()
	tween.tween_property(main_game_title,"position:y", -200, 0.5)
