extends TextureRect

enum Turn {
	PLAYER,
	ENEMY
}

enum Enemy{
	SHOP_KEEPER
}

@onready var player = $Player
@onready var enemy = $Enemy
@onready var main: TextureRect = $"."
var vignette_default = '#bdabb8'
var vignetter_default = '#ffe6909e'
var sun_caster_color = '#e56400'
var moon_caster_color = '#1a54fb'
var dawn_stance = '#ffcda0'
var dusk_stance = '#8dacf7'
@onready var battle_particles: GPUParticles2D = $"ParticleManager/Battle Particles"
@onready var dusk_particles: GPUParticles2D = $"ParticleManager/Dusk Particles"
@onready var dawn_particles: GPUParticles2D = $"ParticleManager/Dawn Particles"
@onready var reserve_button: Button = $"Battle UI/Reserve Button"
@onready var player_reserve: Label = $"Battle UI/Reserve Button/Player Reserve"
@onready var player_reserve_rug: TextureRect = $"Player/Player Reserve Rug"
@onready var vignette: CanvasModulate = $"../Vignette"
@onready var vignetter: PointLight2D = $"../Vignetter"

var second_enemy
var third_enemy

#PARTICLES
const COIN_ADD_PARTICLE = preload("res://Scene/Coin Add Particle.tscn")
const COIN_PLAY_PARTICLE = preload("res://Scene/Coin Play Particle.tscn")
const DAMAGE_PARTICLE = preload("res://Scene/Damage Particle.tscn")
const SINGLE_DAMAGE_PARTICLE = preload("res://Scene/Single Damage Particle.tscn")

#MANAGERS
@onready var sound_manager: Node2D = $SoundManager
@onready var particle_manager: Node2D = $ParticleManager

#SFX
const COIN_ENDTURN = preload("uid://bfruqunt0uyuj")
const COIN_FLIP = preload("uid://bmscttmxwr782")
const COIN_REFLIP = preload("uid://qtxsmuntihe3")
const DAMAGE_HEAVY = preload("uid://b8us2t16pmggo")
const DAMAGE_LIGHT = preload("uid://ds0jngoq17iij")
const DAMAGE_MODERATE = preload("uid://b2rf2iy046cx2")
const TURN_ENEMY = preload("uid://rncriov1quyx")
const TURN_PLAYER = preload("uid://dk7433d32rg52")
const TURN_REVEAL = preload("uid://boyjppal62qns")
const VICTORY = preload("uid://bu3c18dhngcvw")

const COIN_UPGRADE = preload("uid://c2sojoo67g7sq")
const DEBT = preload("uid://cuwgygacdm7dj")
const DEATH = preload("uid://bx1ttmouolx2q")

const BATTLE_START = preload("uid://whq12p7mykru")
const COIN_ATTACK_PARTICLE = preload("uid://djmpd27qq4nn1")
const EXTRA_TURN = preload("uid://yp1dxyml8rna")

#MUSIC
const SHOP = preload("uid://cj6gpgjo4y5s0")
const PASSIVE_SELECTION = preload("uid://cfm3uhjitv627")
const TWILIGHT_SAGE = preload("uid://dh7vynnxrbqwa")
const TWILIGHT_ZONE___BATTLE_THEME_1 = preload("uid://b8go57qfww8el")
const TWILIGHT_ZONE___BATTLE_THEME_2 = preload("uid://byxwfs5g71s5x")
const TWILIGHT_ZONE___BATTLE_THEME_3 = preload("uid://bivy2e314q2fa")

#@onready var player_portrait: ColorRect = $Player/Player_Portrait
#@onready var enemy_portrait: ColorRect = $Enemy/Enemy_Portrait
@onready var enemy_portrait = $Enemy/Enemy_Portrait
@onready var enemy_portrait_sprite: AnimatedSprite2D = $Enemy/Enemy_Portrait/Enemy_Portrait_Sprite
@onready var player_portrait: AnimatedSprite2D = $Player/Player_Portrait

@onready var endTurn_button = $"Battle UI/Endturn"
@onready var flip_button = $"Battle UI/PlayerHealthBar2"
@onready var re_flip_button: Button = $"Battle UI/Re-Flip"
@onready var reflip_sprite: AnimatedSprite2D = $"Battle UI/Re-Flip/Reflip_Sprite"
@onready var reflip_label: Label = $"Battle UI/Re-Flip/Reflip_Label"
@onready var turn_calculation: Label = $"Battle UI/Turn Calculation Box/Turn Calculation"
@onready var turn_calculation_box: TextureRect = $"Battle UI/Turn Calculation Box"

#USER INTERFACE
const TUTORIAL = preload("uid://cq10yywodq6bn")
var current_tutorial = null
var has_encountered_flip = false
var has_encountered_spells = false
var tutorial_flip_count = 0 
var tutorial_overflow_count = 0
var tutorial_reserve_count: int = 0

var has_encountered_reflip = false
var has_encountered_endturn = false
var has_encountered_reserve = false
var has_encountered_overflow = false
var has_encountered_coin_health = false

var adv_tutorial_started  = false   
var adv_debt_done  = false   
var adv_coin_tiers_done  = false   
var adv_coin_status_done  = false   
var adv_flip_count  = 0       
var adv_tier_flip_count = 0  
var adv_coin_status_radiant_seen = false


const DIALOGUE_BOX = preload("uid://dv278qg6j2epd")
var dialogue: Node2D = null
@onready var dialogue_area: Marker2D = $"Dialogue Area" 

signal player_info_opened
var has_encountered_damage_gain = false
var has_encountered_debt = false
var has_encountered_spend = false
var has_encountered_thrift = false

@onready var player_health_bar = $"Battle UI/PlayerHealthBar2"
@onready var player_gain: Label = $"Player/Player Gain"
@onready var player_debt: Label = $"Player/Player Debt"
@onready var player_health_label = $"Battle UI/HealthLabel"
@onready var player_thrift: Label = $"Player/Player Thrift"
@onready var player_lock: Label = $"Player/Player Lock"
@onready var player_slow: Label = $"Battle UI/Re-Flip/Player Slow"
@onready var player_slow_particles: GPUParticles2D = $"Battle UI/Re-Flip/Player Slow Particles"
var slow_color = "#43a563"
const PLAYER_INFORMATION_DISPLAY = preload("uid://c61s4yrsvak0l")
var player_info_menu: Node = null


@onready var player_lock_particles: GPUParticles2D = $"Player/Player Lock Particles"
@onready var player_gain_particles: GPUParticles2D = $"Player/Player Gain Particles"
@onready var player_debt_particles: GPUParticles2D = $"Player/Player Debt Particles"
@onready var enemy_debt_particles: GPUParticles2D = $"Enemy/Enemy Debt Particles"
@onready var player_thrift_particles: GPUParticles2D = $"Player/Player Thrift Particles"
@onready var enemy_thrift_particles: GPUParticles2D = $"Enemy/Enemy Thrift Particles"
@onready var enemy_gain_particles: GPUParticles2D = $"Enemy/Enemy Gain Particles"

@onready var player_spend_particles: GPUParticles2D = $"Battle UI/Player Spend Particles"
@onready var player_spend: Label = $"Battle UI/Player Spend"
@onready var enemy_spend_particles: GPUParticles2D = $"Battle UI/Enemy Spend Particles"
@onready var enemy_spend: Label = $"Battle UI/Enemy Spend"


@onready var enemy_health_bar = $"Battle UI/EnemyHealthBar"
@onready var enemy_health_label: Label = $"Battle UI/EnemyHealthLabel"
@onready var enemy_gain: Label = $"Enemy/Enemy Gain"
@onready var enemy_debt: Label = $"Enemy/Enemy Debt"
@onready var enemy_thrift: Label = $"Enemy/Enemy Thrift"

@onready var enemy_passive_label = $"Battle UI/CenterContainer/Background/EnemyLabelNotification"
@onready var enemy_passive_bg = $"Battle UI/CenterContainer/Background"
var enemy_notif_tween: Tween = null
var enemy_notif_base_pos: Vector2

@onready var turn_ui: ColorRect = $"Battle UI/Turn UI"
@onready var turn_ui_label: Label = $"Battle UI/Turn UI/Turn UI Label"

@onready var passive_manager = $PassiveManager
@onready var passive_label = $"Battle UI/PassiveContainer"

var overflow_notif: Control = null

@onready var game_over_ui: CanvasLayer = $"Game Over UI"

@onready var pause_menu = $PauseMenu

#COIN DECK 
@onready var coin_deck: Node2D = $CoinDeck
@onready var reward_manager = $CardManager

#COIN
const COIN = preload("uid://ddet242jm5v23")

#CALCULATIONS
var damage = 0
var gain = 0
var debt = 0
var reserved_coin = null
var current_turn = Turn.PLAYER
var total_damage_dealt = 0
var highest_damage_dealt = 0

#GameStatistics
var total_damage = 0
var highest_damage = 0
var total_gain = 0
var highest_gain = 0
var enemies_defeated = 0
var total_heads = 0
var total_tails = 0
var total_flips = 0
var total_reflips = 0
var total_passives = 0
var overall_reserved_coins = 0

var overall_total_damage: int = 0
var overall_highest_damage: int = 0
var overall_total_gain: int = 0
var overall_highest_gain: int = 0

var advance_mode: bool = false

var is_surrender = false
var current_enemy_type


var current_enemy_index
var current_room

func _spawn_dialogue() -> void:
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.queue_free()
	dialogue = DIALOGUE_BOX.instantiate()
	add_child(dialogue)
	await get_tree().process_frame
	dialogue.setup(dialogue_area.global_position, 150)
	dialogue.z_index = 50

func _say(key: String) -> void:
	_spawn_dialogue()
	dialogue.set_tail(DialogueBox.TailSide.RIGHT)
	dialogue.play(key)

func _dismiss_dialogue() -> void:
	if dialogue != null and is_instance_valid(dialogue):
		dialogue.close()
		dialogue = null

func _close_current_tutorial():
	if current_tutorial != null and is_instance_valid(current_tutorial):
		current_tutorial.close()
	current_tutorial = null

func _show_tutorial(title: String, text: String, pos: Vector2, y_offset: float,
		enabled_buttons: Array = []) -> void:
	_close_current_tutorial()
 
	
	flip_button.disabled    = true
	re_flip_button.disabled = true
	endTurn_button.disabled = true
	reserve_button.disabled = true
 
	
	re_flip_button.visible = has_encountered_flip    
	endTurn_button.visible = has_encountered_reflip  
	reserve_button.visible = has_encountered_endturn 
	
	for btn in enabled_buttons:
		btn.disabled = false
		btn.visible  = true
 
	current_tutorial = create_tutorial(title, text, pos, y_offset)

func _adv_unlock_all() -> void:
	flip_button.disabled = false
	flip_button.visible = true
	re_flip_button.disabled = false
	re_flip_button.visible = true
	endTurn_button.disabled = false
	endTurn_button.visible = true
	reserve_button.disabled = false
	reserve_button.visible = true

func _adv_lock_except_flip() -> void:
	flip_button.disabled = false
	flip_button.visible  = true
	re_flip_button.disabled = true
	re_flip_button.visible  = true
	endTurn_button.disabled = true
	endTurn_button.visible  = true
	reserve_button.disabled = true
	reserve_button.visible  = true
	
func _tutorial_force_shine_coin() -> void:
	if not advance_mode:
		return
	var coin = player.latest_coin
	if coin == null:
		var coins = get_tree().get_nodes_in_group("coins")
		if coins.size() > 0:
			coin = coins.back()
	if coin != null:
		coin.add_status(coin.CoinStatus.SHINED)
		coin.refresh_sprite()
		coin.pulse_glow()


	
func _adv_start_shine_tutorial() -> void:
	_tutorial_force_shine_coin()
	await get_tree().create_timer(0.8).timeout
	_say("adv_coin_status_intro")
	_show_tutorial("Coin Status Effects","See those glowing coins?\nThat's SHINED — a Coin Status Effect.\nShined Heads coins boost Damage.\nShined Tails boost Gain.\nInspect your coins to learn more!",coin_deck.global_position, -120,[flip_button, re_flip_button, endTurn_button, reserve_button])
	await _wait_for_spell_inspection()
	while player_info_menu != null and is_instance_valid(player_info_menu):
		await get_tree().process_frame
	_close_current_tutorial()
	adv_coin_status_radiant_seen = true
	
	await get_tree().create_timer(0.5).timeout
	_adv_start_coin_tiers_tutorial()
	
	
func _adv_start_coin_tiers_tutorial() -> void:
	adv_tier_flip_count = 0
	_say("adv_coin_tiers_intro")
	_show_tutorial("Coin Tiers","Coins come in three tiers:\nCopper, Silver, and Gold.\nSilver and Gold coins flip with\nhigher Heads odds — keep flipping!",player_health_bar.global_position,-120,[flip_button, re_flip_button, endTurn_button])
	
	await current_tutorial.closed
	
	adv_coin_tiers_done = true
	_say("adv_all_done")
	_adv_unlock_all()
	start_player_turn()
	
func switch_vignette_color(to,duration):
	var tween = create_tween()
	tween.tween_property(vignette,"color",Color.from_string(to,Color.WHITE),duration)

func switch_vignetter_color(to,duration):
	var tween = create_tween()
	tween.tween_property(vignetter,"color",Color.from_string(to,Color.WHITE),duration)

# Called when the node enters the scene tree for the first time.
func _ready():
	advance_mode = SceneTransition.tutorial_advance_mode
	await get_tree().create_timer(0.4).timeout
	await _play_fake_coin_intro()
	turn_calculation_box.visible = false
	turn_ui.visible = false
	current_enemy_index = randi_range(0,1)
	player.setup(self)
	game_over_ui.visible = false
	pause_menu.visible = false
	turn_ui.visible = false
	player.reset_stats()
	
	
	main.self_modulate = Color.WHITE
	
	if advance_mode:
		has_encountered_flip = true
		has_encountered_reflip = true
		has_encountered_endturn = true
		has_encountered_reserve = true
		has_encountered_overflow = true
	
	if not pause_menu.end_run_pressed.is_connected(_on_end_run_pressed):
		pause_menu.end_run_pressed.connect(_on_end_run_pressed)
	if not endTurn_button.pressed.is_connected(_on_endturn_pressed):
		endTurn_button.pressed.connect(_on_endturn_pressed)
	if not re_flip_button.pressed.is_connected(_on_re_flip_pressed):
		re_flip_button.pressed.connect(_on_re_flip_pressed)      
	battle_start()
	
func on_enemy_radiant_fired() -> void:
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"): # ESC key
		toggle_pause()
		
func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	
	battle_particles.emitting = !get_tree().paused
	dusk_particles.emitting = !get_tree().paused
	dawn_particles.emitting = !get_tree().paused
	
func battle_start():
	game_over_triggered = false
	re_flip_button.visible = has_encountered_flip
	endTurn_button.visible = has_encountered_reflip
	reserve_button.visible = has_encountered_endturn
	player_reserve.visible = true
	switch_vignetter_color(vignetter_default,0.1)
	switch_vignette_color(vignette_default,0.1)
	battle_particles.emitting = true
	dawn_particles.emitting = false
	dusk_particles.emitting = false
	
	turn_ui.visible = false
	var coins = get_tree().get_nodes_in_group("enemy coins")
	for coin in coins:
		coin.queue_free()
		
	coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		coin.queue_free()

	coins = get_tree().get_nodes_in_group("reserved coins")
	for coin in coins:
		coin.queue_free()
		
	coins = get_tree().get_nodes_in_group("enemy_coins")
	for coin in coins:
		coin.queue_free()
	reserved_coin = null
	player.refresh_start_of_battle_stats()
	enemy.refresh_start_of_battle_stats()

	coin_deck.reset_sigils()
	reflip_label.text = str(player.max_re_flip - player.current_re_flip)

	randomize()
	
	if flip_button.pressed.is_connected(_on_flip_pressed):
		flip_button.pressed.disconnect(_on_flip_pressed)
	if endTurn_button.pressed.is_connected(_on_endturn_pressed):
		endTurn_button.pressed.disconnect(_on_endturn_pressed)
	if re_flip_button.pressed.is_connected(_on_re_flip_pressed):
		re_flip_button.pressed.disconnect(_on_re_flip_pressed)
	
	flip_button.pressed.connect(_on_flip_pressed)
	endTurn_button.pressed.connect(_on_endturn_pressed)
	re_flip_button.pressed.connect(_on_re_flip_pressed)
	
	enemy.setup(self, Enemy.SHOP_KEEPER)
	enemy_portrait_sprite.play("SHOP_KEEPER")
	current_enemy_type = Enemy.SHOP_KEEPER
	
	update_enemy_coin()
	update_player_coin()
	flip_button.disabled = false
	sound_manager.play_sound(BATTLE_START)
	var bgm_rand = randi_range(0,2)
	if current_enemy_index == 8:
		sound_manager.play_music(TWILIGHT_SAGE)
	elif bgm_rand == 0: 
		sound_manager.play_music(TWILIGHT_ZONE___BATTLE_THEME_1)
	elif bgm_rand == 1:
		sound_manager.play_music(TWILIGHT_ZONE___BATTLE_THEME_2)
	else:
		sound_manager.play_music(TWILIGHT_ZONE___BATTLE_THEME_3)
		
	#Battle Start Passives
	player.player_turn_count = 0
	current_turn = Turn.PLAYER
	start_player_turn()

func _process(delta: float) -> void:
	update_player_coin()
	update_enemy_coin()
	update_player_stacks()
	update_enemy_stacks()
	update_player_reflip_and_reserve()

func show_turn_ui(text):
	sound_manager.play_sound(TURN_REVEAL)
	endTurn_button.disabled = true
	turn_ui.visible = true
	turn_ui_label.text = text
	turn_ui.modulate = Color("ffffff00")
	turn_ui.global_position = get_viewport_rect().size / 2
	turn_ui.global_position.x -= 600
	
	var target_position = turn_ui.global_position.y - 40
	
	var tween = create_tween()
	tween.parallel().tween_property(turn_ui,"modulate",Color("ffffff"),0.2)
	tween.parallel().tween_property(turn_ui, "position:y",target_position,0.2)
	await get_tree().create_timer(1.0).timeout
	turn_ui_label.text = text
	tween = create_tween()
	tween.parallel().tween_property(turn_ui,"modulate",Color("ffffff00"),0.2)
	tween.parallel().tween_property(turn_ui, "position:y",target_position - 30,0.2)
	if current_turn == Turn.PLAYER:
		endTurn_button.disabled = false
	await get_tree().create_timer(1.0).timeout
	
func _on_end_run_pressed():
	print("Main Script: Received End Run")
	get_tree().paused = false
	pause_menu.visible = false
	is_surrender = true
	trigger_game_over(false)

	
func start_player_turn():
	if player.coin <= 0:
		await check_defeat()
		return
		
	show_turn_ui("PLAYER TURN")
	current_turn = Turn.PLAYER
	sound_manager.play_sound(TURN_PLAYER)
	await player.start_turn()
	
	if advance_mode:
		if !adv_tutorial_started:
			adv_tutorial_started = true
			_say("adv_welcome")
			_adv_lock_except_flip()
			endTurn_button.visible  = true
			endTurn_button.disabled = false
			return
		if !adv_debt_done and player.debt > 0:
			adv_debt_done = true   
			await get_tree().create_timer(0.8).timeout  
			_say("adv_debt_intro")
			_show_tutorial("Status Effects: Debt","See how your Gain was reduced?\nThat's Debt at work — it cancels out\nyour Coin Gain at the start of your turn.\nThe higher your Debt, the less you gain!",player_debt.global_position,-120,[flip_button, endTurn_button])
			await current_tutorial.closed
			_adv_start_shine_tutorial()
			return
		return
	
	if !has_encountered_flip:
		_say("sk_first_flip")
		_show_tutorial("Coin Flipping","Press your Coin Bar to Flip a Coin.",player_health_bar.global_position,-100,[flip_button] )
		return
			
	if !has_encountered_reflip:
		_say("sk_first_reflip")
		_show_tutorial("Re-Flip", "If there are coins on the Arcane Circle,\npress Re-Flip to flip all coins again.",re_flip_button.global_position,-100,[re_flip_button])
		return
		
			
func start_enemy_turn():
	
	if enemy.coin <= 0:
		await check_defeat()
		return
		
	show_turn_ui("ENEMY'S TURN")
	_say("sk_player_losing")
	coin_deck.reset_sigils()
	current_turn = Turn.ENEMY
	sound_manager.play_sound(TURN_ENEMY)
	await enemy.start_enemy_turn()
	await get_tree().process_frame
		
	if game_over_triggered:
		return
		
	var defeat = await check_defeat()
	if not defeat:
		_close_current_tutorial()
		await get_tree().create_timer(1.0).timeout
		start_player_turn()
		
func _show_coin_spells_tutorial() -> void:
	_show_tutorial("Coin Spells","Some coins have Spells that activate when\nflipped Heads or Tails. Click your Portrait\nto view your Coin Spells.",player_portrait.global_position,-120)
	await _wait_for_spell_inspection()
	while player_info_menu != null and is_instance_valid(player_info_menu):
		await get_tree().process_frame
	_close_current_tutorial()
	start_player_turn()

func _on_endturn_pressed():
	if enemy.coin <= 0 or player.coin <= 0:
		return
		
	if advance_mode:
		_close_current_tutorial()
		_dismiss_dialogue()
		flip_button.visible  = true
		flip_button.disabled = true
		await player.end_turn()
		turn_calculation_box.exit()
		var defeat = await check_defeat()
		if not defeat:
			await get_tree().create_timer(1.0).timeout
			start_enemy_turn()
		return
		
	if !has_encountered_endturn:
		has_encountered_endturn = true
		
	_close_current_tutorial()
	_dismiss_dialogue()
	flip_button.visible  = true
	flip_button.disabled = true

	await player.end_turn()
	turn_calculation_box.exit()
		
	if !has_encountered_reserve:
		tutorial_reserve_count = 0
		reserve_button.visible  = true
		_say("sk_reserve")
		_show_tutorial("Reserve","Press the Reserve Button to save one coin\nfor later. Reserved coins return at the\nend of battle as bonus coins!",Vector2(reserve_button.global_position.x - 200, reserve_button.global_position.y),-250,[reserve_button,flip_button])
		await current_tutorial.closed
		return
		
		
	flip_button.disabled    = false
	flip_button.visible  = true
	re_flip_button.disabled = false
	endTurn_button.disabled = false
	reserve_button.disabled = false
	re_flip_button.visible  = true
	endTurn_button.visible  = true
	reserve_button.visible  = true
	
	var defeat = await check_defeat()
	if not defeat:
		await get_tree().create_timer(1.0).timeout
		start_enemy_turn()
			

func _wait_for_spell_inspection() -> void:
	await player_info_opened
	_close_current_tutorial()


func _on_flip_pressed():
	if current_turn != Turn.PLAYER or game_over_triggered:
		return
		
	total_flips += 1
	player.flip()
	await get_tree().process_frame
	await check_defeat()
	
	if advance_mode:
		return
		
	if !has_encountered_flip:
		tutorial_flip_count += 1
		if tutorial_flip_count >= 4:
			has_encountered_flip = true
			_close_current_tutorial()
			re_flip_button.visible  = true
			re_flip_button.disabled = false
			endTurn_button.visible  = false
			_say("sk_coin_spell")
			await _show_coin_spells_tutorial()
		return
	if has_encountered_reserve and not has_encountered_overflow:
		tutorial_overflow_count += 1
		var reserved = get_tree().get_nodes_in_group("reserved coins")
		
		if reserved.size() > 0 and tutorial_overflow_count >= 17:
			has_encountered_overflow = true
			_close_current_tutorial()
			_say("sk_overflow")
			
		flip_button.visible     = true
		flip_button.disabled    = false
		re_flip_button.visible  = true
		re_flip_button.disabled = false
		endTurn_button.visible  = true
		endTurn_button.disabled = false
		reserve_button.visible  = true
		reserve_button.disabled = false
	return
	await check_defeat()
	

	
var game_over_triggered = false 


	
func trigger_game_over(player_won: bool):
	
	if game_over_triggered:
		return
	game_over_triggered = true
	
	_close_current_tutorial()
	sound_manager.stop_music()
	set_process(false)
	
	flip_button.disabled = true
	re_flip_button.disabled = true
	endTurn_button.disabled = true
	
	if player_won:
		sound_manager.play_sound(VICTORY)
	else:
		sound_manager.play_sound(DEATH)

	await get_tree().create_timer(2.0).timeout
	SceneTransition.load_scene("res://Scene/Shop_keepers Room.tscn")
	

func check_defeat():
	if game_over_triggered:
		return true
	if player.coin <= 0:
		trigger_game_over(false)
		return true
		
	if enemy.coin <= 0:
		flip_button.disabled = true
		endTurn_button.disabled = true 
		re_flip_button.disabled = true
		await handle_victory_flow()
		return true
	
	return false

func handle_victory_flow():
	endTurn_button.disabled = true
	player.lock = false
	player.slow = false
	var coins = get_tree().get_nodes_in_group("reserved coins")
	player.current_reserve = coins.size()
	player.max_reserve = player.initial_max_reserve
	switch_vignetter_color(vignetter_default,1.0)
	switch_vignette_color(vignette_default,1.0)
	battle_particles.emitting = true
	dusk_particles.emitting = false
	dawn_particles.emitting = false
	player.gain_coin()
	sound_manager.play_sound(VICTORY)
	turn_calculation_box.exit()
	_say("sk_victory")
	await show_turn_ui("VICTORY")
	var reserved_coins = get_tree().get_nodes_in_group("reserved coins")
	for c in reserved_coins:
		player.coin += 1
		overall_reserved_coins += 1
		c.queue_free()
		player.current_reserve -= 1
	particle_manager.despawn_emitting_particles()
	# Disable gameplay buttons
	flip_button.disabled = true
	re_flip_button.disabled = true
	endTurn_button.disabled = true
	
	overall_total_damage += total_damage_dealt
	if total_damage_dealt > overall_highest_damage:
		overall_highest_damage = total_damage_dealt
		
	overall_total_gain += total_gain
	if total_gain > overall_highest_gain:
		overall_highest_gain = total_gain
		
	trigger_game_over(true)
#		
func _on_re_flip_pressed():
	total_reflips += 1
	player.re_flip()
	
	if advance_mode:
		return
		
	if !has_encountered_reflip:
		has_encountered_reflip = true
		_close_current_tutorial()
		flip_button.visible     = true    
		flip_button.disabled    = true    
		re_flip_button.visible  = true   
		re_flip_button.disabled = true 
		_say("sk_endturn")
		_show_tutorial("End Turn","When you are done flipping,\npress End Turn to send your coins\ninto battle!",Vector2(endTurn_button.global_position.x - 150, endTurn_button.global_position.y),-100,[endTurn_button])
		endTurn_button.visible  = true
		endTurn_button.disabled = false

func reserve_left_over_coin():
	var is_left = true # true - Left Coin, false - Right Coin
	var left_coin
	var right_coin
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if is_left == true:
			left_coin = coin
		if is_left == false:
			right_coin = coin
		
		if left_coin != null and right_coin != null:
			left_coin = null
			right_coin = null
		is_left = !is_left

	if left_coin != null and right_coin == null:
		left_coin.reserved = true
		var target_pos = coin_deck.get_reserve_slot()
		var tween = create_tween()
		left_coin.refresh_sprite()
		sound_manager.play_sound(COIN_FLIP)
		tween.tween_property(left_coin,"position:x",target_pos[0],0.2)
		tween.tween_property(left_coin,"position:y",target_pos[1],0.2)
		left_coin.add_to_group("reserved coins")
		coins = get_tree().get_nodes_in_group("reserved coins")
		player.current_reserve = coins.size()

func update_player_coin():
	player_health_label.text =  str(player.coin)
	
func update_player_reflip_and_reserve():
	if player.slow:
		player_slow_particles.emitting = true
		player_slow.visible = true
	else:
		player_slow_particles.emitting = false
		player_slow.visible = false
	if player.lock:
		player_reserve.text = ""
		reserve_button.visible = false
		player_lock.visible = true
		player_lock_particles.emitting = true
	else:
		reserve_button.visible = has_encountered_endturn
		player_lock.visible = false
		player_lock_particles.emitting = false
		player_reserve.text = "Reserve: " + str(player.current_reserve) + "/" + str(player.max_reserve)
	
func update_enemy_coin():
	enemy_health_label.text = "Coins: " + str(enemy.coin)
	
func update_player_stacks():
	player_debt_particles.emitting = false
	player_gain_particles.emitting = false
	player_thrift_particles.emitting = false
	player_spend_particles.emitting = false
	player_gain.text = ""
	player_debt.text = ""
	player_thrift.text = ""
	player_spend.text = ""
	if player.gain != 0:
		player_gain.text = str(player.gain)
		player_gain_particles.emitting = true
	if player.debt != 0:
		player_debt_particles.emitting = true
		player_debt.text = str(player.debt)
	if player.thrift != 0:
		player_thrift.text = str(player.thrift)
		player_thrift_particles.emitting = true
	if player.spend != 0:
		player_spend.text = str(player.spend)
		player_spend_particles.emitting = true
	
func update_enemy_stacks():
	enemy_debt_particles.emitting = false
	enemy_thrift_particles.emitting = false
	enemy_gain_particles.emitting = false
	enemy_spend_particles.emitting = false
	enemy_gain.text = ""
	enemy_debt.text = ""
	enemy_thrift.text = ""
	enemy_spend.text = ""
	if enemy.gain != 0:
		enemy_gain.text = str(enemy.gain)
		enemy_gain_particles.emitting = true
	if enemy.debt != 0:
		enemy_debt.text =str(enemy.debt)
		enemy_debt_particles.emitting = true
	if enemy.thrift != 0:
		enemy_thrift.text = str(enemy.thrift)
		enemy_thrift_particles.emitting = true
	if enemy.spend != 0:
		enemy_spend.text = str(enemy.spend)
		enemy_spend_particles.emitting = true

func _on_restart_pressed():
	game_over_triggered = false
	await get_tree().create_timer(0.2).timeout
	get_tree().reload_current_scene()
	
func _on_refresh_pressed() -> void:
	pass # Replace with function body.

func _on_endturn_mouse_entered() -> void:
	if current_turn == Turn.PLAYER:
		coin_deck.sigil_light_up()

func _on_endturn_mouse_exited() -> void:
	coin_deck.sigil_unlight_()

func _play_fake_coin_intro():
	var fake_coin = COIN.instantiate()
	fake_coin.degrade_to_copper()
	add_child(fake_coin)
	fake_coin.z_index = 100 
	
	await get_tree().process_frame
	var screen_center = get_viewport_rect().size / 2
	var start_pos = Vector2(screen_center.x, -200) 
	
	if fake_coin.has_method("setup"):
		fake_coin.setup(0, start_pos) 
	else:
		fake_coin.global_position = start_pos 
	
	var target_pos = player_health_bar.global_position 
	
	var tween = create_tween()
	tween.tween_property(fake_coin, "global_position", target_pos, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(fake_coin, "scale", Vector2(0.6, 0.6), 0.4)
	
	tween.finished.connect(fake_coin.queue_free)


func _on_re_flip_mouse_entered() -> void:
	if !re_flip_button.disabled:
		reflip_sprite.play("default")


func _on_re_flip_mouse_exited() -> void:
	reflip_sprite.pause()

func _on_player_info_toggled(toggled_on: bool) -> void:
	print("toggled: ", toggled_on)
	if toggled_on:
		player_info_menu = PLAYER_INFORMATION_DISPLAY.instantiate()
		add_child(player_info_menu)
		player_info_menu.setup(player)
		
		await get_tree().process_frame
		var screen_size = get_viewport_rect().size
		var menu_size = player_info_menu.size
		player_info_menu.global_position = Vector2((screen_size.x - menu_size.x) / 2,
			(screen_size.y - menu_size.y) / 2)
		player_info_menu.z_index = 100
		player_info_menu.open()
		emit_signal("player_info_opened")
	else:
		if player_info_menu != null and is_instance_valid(player_info_menu):
			player_info_menu.close()
			player_info_menu = null


func _on_reserve_button_pressed() -> void:
	player.reserve()
	reserve_button.disabled = player.current_reserve >= player.max_reserve
	
	if advance_mode:
		return
	
	if !has_encountered_reserve:
		tutorial_reserve_count += 1
		if tutorial_reserve_count >= 2:
			has_encountered_reserve = true
			_close_current_tutorial()
			
			
			if not has_encountered_overflow:
				tutorial_overflow_count = 0
				flip_button.visible  = true    
				flip_button.disabled = false  
				_say("sk_overflow")
				_show_tutorial("Overflow Reserve","If you flip more coins than your Arcane\nCircle can hold, the extra coin is\nautomatically Reserved for you!",Vector2(reserve_button.global_position.x - 200, reserve_button.global_position.y),-250,[flip_button])
				#return


func create_tutorial(title, text, pos, y_offset):
	var tutorial = TUTORIAL.instantiate()
	tutorial.setup(title,text,pos,y_offset)
	add_child(tutorial)
	return tutorial
