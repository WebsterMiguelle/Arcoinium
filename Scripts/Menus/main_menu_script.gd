extends Node
@onready var greed_coin: AnimatedSprite2D = $"GreedButton/Greed Coin"
@onready var greed_glow_panel: Panel = $"GreedButton/Greed Glow"
@onready var greed_button: Button = $GreedButton
@onready var normal: Label = $NORMAL
@onready var greed: Label = $GREED

@onready var coin: AnimatedSprite2D = $Button/Coin
@onready var button: Button = $Button
@onready var glow_panel: Panel = $Button/Glow
@onready var flip_coin_to_start: Label = $"Flip Coin to Start"
@onready var main_game_title: Label = $"Main Game Title"
@onready var sound_manager: Node2D = $SoundManager

@onready var tutorial_coin: AnimatedSprite2D = $Tutorial/Coin2
@onready var tutorial_button: Button = $Tutorial
@onready var tutorial_glow_panel: Panel = $Tutorial/Glow2
@onready var tutorial_label: Label = $"Tutorial Label"



const COIN_FLIP = preload("uid://bmscttmxwr782")
const PASSIVE_PASSIVE_INCOME = preload("uid://cl4xnombcshkv")
var normal_waiting: bool = false
var greed_waiting: bool = false
var tutorial_waiting: bool = false
var freeze_frame_on : int = 0

var float_tween: Tween
var bounce_tween: Tween

# NEW: A dedicated tween just for the glowing pulse effect
var glow_tween: Tween 
var greed_float_tween: Tween
var greed_bounce_tween: Tween
var tutorial_float_tween: Tween
var tutorial_bounce_tween: Tween

# NEW: A dedicated tween just for the glowing pulse effect
var greed_glow_tween: Tween 
var tutorial_glow_tween: Tween 

func _ready() -> void:
	coin.play("coin_flipping")
	greed_coin.play("gold_coin_flip")
	tutorial_coin.play("tutorial_coin")
	fading_text()
	
	# NEW: Hide the glow by default when the scene loads
	tutorial_glow_panel.modulate.a = 0.1 
	glow_panel.modulate.a = 0.1 
	greed_glow_panel.modulate.a = 0.1 
	button.mouse_entered.connect(_on_button_hovered)
	button.mouse_exited.connect(_on_button_exited)
	button.pressed.connect(_on_button_pressed)
	greed_button.mouse_entered.connect(_on_greed_button_hovered)
	greed_button.mouse_exited.connect(_on_greed_button_exited)
	greed_button.pressed.connect(_on_greed_button_pressed)
	tutorial_button.mouse_entered.connect(_on_tutorial_button_hovered)
	tutorial_button.mouse_exited.connect(_on_tutorial_button_exited)
	tutorial_button.pressed.connect(_on_tutorial_button_pressed)
	
	tutorial_coin.frame_changed.connect(_on_tutorial_frame_changed)
	coin.frame_changed.connect(_on_frame_changed)
	greed_coin.frame_changed.connect(_on_greed_frame_changed)
	
	_tutorial_coin_float()
	_coin_float()
	_greed_coin_float()
	
func _on_button_hovered() -> void:
	normal.visible = true
	normal_waiting = true
	
	if float_tween: float_tween.pause()
	
	if glow_tween: glow_tween.kill()
	glow_tween = create_tween().set_loops()
	glow_tween.tween_property(glow_panel, "modulate:a", 0.8, 0.5).set_trans(Tween.TRANS_SINE)
	
func _on_button_exited() -> void:
	normal.visible = false
	normal_waiting = false
	
	if float_tween: float_tween.play()
	
	if not coin.is_playing():
		coin.play()
		
	if glow_tween: glow_tween.kill()
	glow_tween = create_tween()
	glow_tween.tween_property(glow_panel, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
		
func _on_button_pressed() -> void:
	PlayerSingleton.greed = false
	sound_manager.play_sound(COIN_FLIP)
	button.disabled = true
	
	normal_waiting = false
	
	if glow_tween: glow_tween.kill()
	glow_panel.modulate.a = 0.0
	
	if float_tween:
		float_tween.kill()
	if bounce_tween:
		bounce_tween.kill()
	
	bounce_tween = create_tween()
	bounce_tween.tween_property(coin,"position:y", -500.0, 0.2).as_relative().set_trans(Tween.TRANS_LINEAR)
	
	coin.play("coin_flipping") 
	SceneTransition.load_scene("res://Scene/main.tscn")
	
func _on_frame_changed() -> void:
	if normal_waiting and coin.frame == freeze_frame_on:
		coin.pause()

func _coin_float():
	button.disabled = false
	if float_tween:
		float_tween.kill()
		
	coin.play("coin_flipping")
	float_tween = create_tween().set_loops()
	
	# Normal Coin Tempo: 0.5 seconds (Standard speed)
	var tempo = 0.5 
	
	float_tween.tween_property(coin, "position:y", -10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	float_tween.parallel().tween_property(glow_panel, "position:y", -10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	float_tween.parallel().tween_property(button, "position:y", -10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)

	float_tween.tween_property(coin, "position:y", 10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	float_tween.parallel().tween_property(glow_panel, "position:y", 10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	float_tween.parallel().tween_property(button, "position:y", 10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
func fading_text():
	var tween = create_tween().set_loops()
	tween.tween_property(flip_coin_to_start,"self_modulate:a",0.0,0.5)
	tween.tween_property(flip_coin_to_start,"self_modulate:a",1.0,0.5)

	
func _on_greed_button_hovered() -> void:
	greed.visible = true
	greed_waiting = true
	
	if greed_float_tween: greed_float_tween.pause()
	
	if greed_glow_tween: greed_glow_tween.kill()
	greed_glow_tween = create_tween().set_loops()
	greed_glow_tween.tween_property(greed_glow_panel, "modulate:a", 0.8, 0.5).set_trans(Tween.TRANS_SINE)
	greed_glow_tween.tween_property(greed_glow_panel, "modulate:a", 0.1, 0.5).set_trans(Tween.TRANS_SINE)
	
func _on_greed_button_exited() -> void:
	greed.visible = false
	greed_waiting = false
	
	if greed_float_tween: greed_float_tween.play()
	
	if not greed_coin.is_playing():
		greed_coin.play()
		
	if greed_glow_tween: greed_glow_tween.kill()
	greed_glow_tween = create_tween()
	greed_glow_tween.tween_property(greed_glow_panel, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
	
func _on_greed_button_pressed() -> void:
	sound_manager.play_sound(COIN_FLIP)
	button.disabled = true
	
	greed_waiting = false
	
	if greed_glow_tween: greed_glow_tween.kill()
	greed_glow_panel.modulate.a = 0.0
	
	if greed_float_tween:
		greed_float_tween.kill()
	if greed_bounce_tween:
		greed_bounce_tween.kill()
	
	greed_bounce_tween = create_tween()
	greed_bounce_tween.tween_property(greed_coin,"position:y", -500.0, 0.2).as_relative().set_trans(Tween.TRANS_LINEAR)
	
	PlayerSingleton.greed = true
	greed_coin.play("gold_coin_flip") 

	SceneTransition.load_scene("res://Scene/main.tscn")

func _on_greed_frame_changed() -> void:
	if greed_waiting and greed_coin.frame == freeze_frame_on:
		greed_coin.pause()

func _greed_coin_float():
	greed_button.disabled = false
	if greed_float_tween:
		greed_float_tween.kill()
		
	greed_coin.play("gold_coin_flip")
	greed_float_tween = create_tween().set_loops()
	
	# Greed Coin Tempo: 0.65 seconds (Slightly slower and heavier)
	var tempo = 0.55 
	
	greed_float_tween.tween_property(greed_coin, "position:y", -10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	greed_float_tween.parallel().tween_property(greed_glow_panel, "position:y", -10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	greed_float_tween.parallel().tween_property(greed_button, "position:y", -10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)

	greed_float_tween.tween_property(greed_coin, "position:y", 10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	greed_float_tween.parallel().tween_property(greed_glow_panel, "position:y", 10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	greed_float_tween.parallel().tween_property(greed_button, "position:y", 10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
		

func _on_tutorial_frame_changed() -> void:
	if tutorial_waiting and tutorial_coin.frame == freeze_frame_on:
		tutorial_coin.pause()
		
func _tutorial_coin_float():
	tutorial_button.disabled = false
	if tutorial_float_tween:
		tutorial_float_tween.kill()
		
	tutorial_coin.play("tutorial_coin")
	tutorial_float_tween = create_tween().set_loops()
	
	# Tutorial Coin Tempo: 0.4 seconds (Slightly faster/lighter)
	var tempo = 0.6 
	
	tutorial_float_tween.tween_property(tutorial_coin, "position:y", -10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	tutorial_float_tween.parallel().tween_property(tutorial_glow_panel, "position:y", -10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	tutorial_float_tween.parallel().tween_property(tutorial_button, "position:y", -10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)

	tutorial_float_tween.tween_property(tutorial_coin, "position:y", 10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	tutorial_float_tween.parallel().tween_property(tutorial_glow_panel, "position:y", 10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)
	tutorial_float_tween.parallel().tween_property(tutorial_button, "position:y", 10.0, tempo).as_relative().set_trans(Tween.TRANS_SINE)


func _on_tutorial_button_hovered() -> void:
	tutorial_label.visible = true
	tutorial_waiting = true
	
	# FREEZE THE FLOAT
	if tutorial_float_tween: tutorial_float_tween.pause()
	
	if tutorial_glow_tween: tutorial_glow_tween.kill()
	tutorial_glow_tween = create_tween().set_loops()
	tutorial_glow_tween.tween_property(tutorial_glow_panel, "modulate:a", 0.8, 0.5).set_trans(Tween.TRANS_SINE)
	tutorial_glow_tween.tween_property(tutorial_glow_panel, "modulate:a", 0.1, 0.5).set_trans(Tween.TRANS_SINE)
	
func _on_tutorial_button_exited() -> void:
	tutorial_label.visible = false
	tutorial_waiting = false
	
	# UNFREEZE THE FLOAT
	if tutorial_float_tween: tutorial_float_tween.play()
	
	if not tutorial_coin.is_playing():
		tutorial_coin.play()
		
	if tutorial_glow_tween: tutorial_glow_tween.kill()
	tutorial_glow_tween = create_tween()
	tutorial_glow_tween.tween_property(tutorial_glow_panel, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)

func _on_tutorial_button_pressed() -> void:
	sound_manager.play_sound(COIN_FLIP)
	button.disabled = true
	
	tutorial_waiting = false
	
	if tutorial_glow_tween: tutorial_glow_tween.kill()
	tutorial_glow_panel.modulate.a = 0.0
	
	if tutorial_float_tween:
		tutorial_float_tween.kill()
	if tutorial_bounce_tween:
		tutorial_bounce_tween.kill()
	
	tutorial_bounce_tween = create_tween()
	tutorial_bounce_tween.tween_property(tutorial_coin,"position:y", -680.0, 0.2).as_relative().set_trans(Tween.TRANS_LINEAR)
	tutorial_coin.play("tutorial_coin") 
	SceneTransition.load_scene("res://Scene/Shop_keepers Room.tscn") 
