extends TextureRect

enum Turn {
	PLAYER,
	ENEMY
}

enum Enemy{
	MAGE,
	DWARF,
	COLLECTOR,
	TRADER,
	THRIFTER,
	ARISTOCRAT,
	SUN_CASTER,
	MOON_CASTER,
	TWILIGHT_SAGE
}

#USER INTERFACE
const TUTORIAL = preload("uid://cq10yywodq6bn")
var current_tutorial = null
var tutorial_enabled = true
var has_encountered_flip = false
var has_encountered_spells = false
var has_encountered_reflip = false
var has_encountered_endturn = false
var has_encountered_reserve = false
var has_encountered_coin_health = false
@onready var tutorial_area: Marker2D = $"Tutorial Area"

var has_encountered_damage_gain = false
var has_encountered_debt = false
var has_encountered_spend = false
var has_encountered_thrift = false
var has_encountered_lock = false
var has_encountered_slow = false

@onready var player = $Player
@onready var enemy = $Enemy
@onready var main: TextureRect = $"."
var greed_color = '#ffa889'
var vignette_default = '#bdabb8'
var vignetter_default = '#ffe6909e'
var sun_caster_color = '#e56400'
var moon_caster_color = '#1a54fb'
var dawn_stance = '#ffcda0'
var dusk_stance = '#8dacf7'
@onready var battle_particles: GPUParticles2D = $"ParticleManager/Battle Particles"
@onready var dusk_particles: GPUParticles2D = $"ParticleManager/Dusk Particles"
@onready var dawn_particles: GPUParticles2D = $"ParticleManager/Dawn Particles"
@onready var player_reserve: Label = $"Battle UI/Player Reserve"

@onready var vignette: CanvasModulate = $"../Vignette"
@onready var vignetter: PointLight2D = $"../Vignetter"

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

const PASSIVE_PASSIVE_INCOME = preload("uid://cl4xnombcshkv")
const PASSIVE_PAYBACK = preload("uid://bbsxs62yhirxa")
const COIN_UPGRADE = preload("uid://c2sojoo67g7sq")
const PASSIVE_COIN_SNIPE = preload("uid://b0rkegpstg6g4")
const PASSIVE_SPARE_CHANGE = preload("uid://dc4ftba55c4w8")
const PASSIVE_REFUND = preload("uid://bubbbm2g4luge")
const PASSIVE_JAR_O_SAVINGS = preload("uid://ctageqytkfmgg")
const DEBT = preload("uid://cuwgygacdm7dj")
const PASSIVE_LOAN_SHARK = preload("uid://6xxw4avoncr8")
const PASSIVE_PAYDOWN = preload("uid://djv3lp0l3aftb")
const DEATH = preload("uid://bx1ttmouolx2q")

const BATTLE_START = preload("uid://whq12p7mykru")
const COIN_ATTACK_PARTICLE = preload("uid://djmpd27qq4nn1")
const EXTRA_TURN = preload("uid://yp1dxyml8rna")

#MUSIC

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

# --- PROGRESSION MAP ---
@onready var progression_map: CanvasLayer = $"Progression Map"
@onready var player_sprite: AnimatedSprite2D = $"Progression Map/Player_Sprite"
@onready var banner: TextureRect = $"Progression Map/MapBackground/Banner"

@onready var map_markers: Array[Node] = [
$"Progression Map/Enemy 1", 
$"Progression Map/Enemy 2", 
$"Progression Map/Enemy 3", 
$"Progression Map/Elite Enemy", 
$"Progression Map/Shop", 
$"Progression Map/Boss"
]

@onready var endTurn_button = $"Battle UI/Endturn"
@onready var flip_button = $"Battle UI/PlayerHealthBar2"
@onready var re_flip_button: Button = $"Battle UI/Re-Flip"
@onready var reflip_sprite: AnimatedSprite2D = $"Battle UI/Re-Flip/Reflip_Sprite"
@onready var reflip_label: Label = $"Battle UI/Re-Flip/Reflip_Label"
@onready var turn_calculation: Label = $"Battle UI/Turn Calculation Box/Turn Calculation"
@onready var turn_calculation_box: TextureRect = $"Battle UI/Turn Calculation Box"


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

var active_passive_notifs: Dictionary = {}
var active_temp_notifs: Array = []
var recent_triggers: Dictionary = {}
var active_temp_ids: Dictionary = {}
var passive_order: Array = []
var max_visible_passives = 10
var overflow_notif: Control = null

	
const PASSIVE_SCENE = preload("res://Scene/passsive_notification.tscn")

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
var total_debt = 0
var highest_debt = 0
var enemies_defeated = 0
var total_heads = 0
var total_tails = 0
var total_flips = 0
var total_reflips = 0
var total_passives = 0

var overall_total_damage: int = 0
var overall_highest_damage: int = 0
var overall_total_gain: int = 0
var overall_highest_gain: int = 0

var current_enemy_type

var is_surrender = false

var current_enemy_index
var current_room
@onready var shop_manager: CanvasLayer = $ShopManager

func _on_item_purchased(card_id,price):
	update_player_coin()
	if shop_manager.visible:
		shop_manager.coin_label.text = "Coins: " + str(player.coin)

func switch_vignette_color(to,duration):
	var tween = create_tween()
	tween.tween_property(vignette,"color",Color.from_string(to,Color.WHITE),duration)

func switch_vignetter_color(to,duration):
	var tween = create_tween()
	tween.tween_property(vignetter,"color",Color.from_string(to,Color.WHITE),duration)

# Called when the node enters the scene tree for the first time.
func _ready():

	await get_tree().create_timer(0.4).timeout
	await _play_fake_coin_intro()
	turn_calculation_box.visible = false
	turn_ui.visible = false
	current_room = 0
	current_enemy_index = randi_range(0,1)
	passive_manager.setup(self)
	player.setup(self)
	#show_enemy_passive("Hello!", 3.0)
	game_over_ui.visible = false
	pause_menu.visible = false
	turn_ui.visible = false
	print(reward_manager)
	player.reset_stats()
	
	#GREED MODE
	if player.greed: 
		main.self_modulate = Color(greed_color)
		tutorial_enabled = false
		enemy.greed = true
		player.coin += 15
		player.silver_flip_rate += 0.2
		player.gold_flip_rate += 0.1
		player.max_re_flip += 3
		player.max_reserve += 4
	else: main.self_modulate = Color.WHITE
	shop_manager.item_purchased.connect(_on_item_purchased)
	
	if not pause_menu.end_run_pressed.is_connected(_on_end_run_pressed):
		pause_menu.end_run_pressed.connect(_on_end_run_pressed)
 	
	if not endTurn_button.pressed.is_connected(_on_endturn_pressed):
		endTurn_button.pressed.connect(_on_endturn_pressed)
	if not re_flip_button.pressed.is_connected(_on_re_flip_pressed):
		re_flip_button.pressed.connect(_on_re_flip_pressed)      
	battle_start()
	
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
	if tutorial_enabled and current_room == 0:
		re_flip_button.visible = false
		player_reserve.visible = false
	else:
		re_flip_button.visible = true
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
	enemy.reset_passives()
	show_all_passive_notifications()

	coin_deck.reset_sigils()
	reflip_label.text = str(player.max_re_flip - player.current_re_flip)

	randomize()
	
	flip_button.pressed.connect(_on_flip_pressed)
	endTurn_button.pressed.connect(_on_endturn_pressed)
	re_flip_button.pressed.connect(_on_re_flip_pressed)
	var enemy_id = current_enemy_index
	match enemy_id:
		0: 
			enemy.setup(self,Enemy.MAGE)
			enemy_portrait_sprite.play("MAGE")
			current_enemy_type = Enemy.MAGE
		1: 
			enemy.setup(self,Enemy.DWARF)
			enemy_portrait_sprite.play("DWARF")
			current_enemy_type = Enemy.DWARF
		2: 
			enemy.setup(self,Enemy.COLLECTOR)
			enemy_portrait_sprite.play("COLLECTOR")
			current_enemy_type = Enemy.COLLECTOR
		3: 
			enemy.setup(self,Enemy.TRADER)
			enemy_portrait_sprite.play("TRADER")
			current_enemy_type = Enemy.TRADER
		4: 
			enemy.setup(self,Enemy.THRIFTER)
			enemy_portrait_sprite.play("THRIFTER")
			current_enemy_type = Enemy.THRIFTER
		5:
			enemy.setup(self,Enemy.ARISTOCRAT)
			enemy_portrait_sprite.play("ARISTOCRAT")
			current_enemy_type = Enemy.ARISTOCRAT
		6: 
			enemy.setup(self,Enemy.SUN_CASTER)
			enemy_portrait_sprite.play("SUN_CASTER")
			current_enemy_type = Enemy.SUN_CASTER
		7: 
			enemy.setup(self,Enemy.MOON_CASTER)
			enemy_portrait_sprite.play("MOON_CASTER")
			current_enemy_type = Enemy.MOON_CASTER
		8:
			enemy.setup(self,Enemy.TWILIGHT_SAGE)
			enemy_portrait_sprite.play("TWILIGHT_SAGE_DAWN")
			current_enemy_type = Enemy.TWILIGHT_SAGE

	
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
	await player.activate_pre_battle_passives()
	player.player_turn_count = 0
	start_player_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		if player.has_pocket_money:
			await get_tree().create_timer(1.0).timeout
		endTurn_button.disabled = false
	await get_tree().create_timer(1.0).timeout
	
func _on_end_run_pressed():
	print("Main Script: Received End Run")
	get_tree().paused = false
	pause_menu.visible = false
	is_surrender = true
	trigger_game_over(false)

func create_tutorial(title, text, pos, y_offset):
	var tutorial = TUTORIAL.instantiate()
	tutorial.setup(title,text,pos,y_offset)
	add_child(tutorial)
	return tutorial
	
func start_player_turn():
	if player.coin > 0:
		show_turn_ui("PLAYER TURN")
		current_turn = Turn.PLAYER
		sound_manager.play_sound(TURN_PLAYER)
		await player.start_turn()
		if tutorial_enabled and !has_encountered_flip:
			current_tutorial = create_tutorial("Coin Flipping", "Press your Coin Bar to Flip a Coin.",player_health_bar.global_position,-100)
			endTurn_button.disabled = true
			player.toggle_button(re_flip_button,true)
		if tutorial_enabled and !has_encountered_reflip and current_room == 1:
			current_tutorial = create_tutorial("Re-Flip", "If there are coins on the Arcane Circle, \nPress Re-Flip to flip all coins again.",re_flip_button.global_position,-100)
			endTurn_button.disabled = true
		if tutorial_enabled and !has_encountered_debt:
			if player.debt > 0:
				has_encountered_debt = true
				current_tutorial = create_tutorial("DEBT", "Each Stack of DEBT blocks 1 Coin generated by GAIN.",tutorial_area.global_position,-50)
		if tutorial_enabled and !has_encountered_thrift:
			if player.thrift > 0:
				has_encountered_thrift = true
				current_tutorial = create_tutorial("THRIFT", "Each Stack of THRIFT blocks\n 1 vacant slot on the Arcane Circle.",tutorial_area.global_position,-50)
		if tutorial_enabled and !has_encountered_spend:
			if player.spend > 0:
				has_encountered_spend = true
				current_tutorial = create_tutorial("SPEND", "While having SPEND, each Coin Flip costs 2 Coins.",tutorial_area.global_position,-50)
		if !has_encountered_lock:
			if player.lock:
				has_encountered_lock = true
				current_tutorial = create_tutorial("LOCK","You cannot Add or Remove Reserved Coins this turn.",tutorial_area.global_position,-50)
		if !has_encountered_slow:
			if player.slow:
				has_encountered_slow = true
				current_tutorial = create_tutorial("SLOW","Each Coin only has a 50% Chance to Re-Flip.",tutorial_area.global_position,-50)
		if enemy.coin == 0:
			check_defeat()
	else:
		check_defeat()
			
func start_enemy_turn():
	if enemy.coin > 0:
		show_turn_ui("ENEMY'S TURN")
		coin_deck.reset_sigils()
		current_turn = Turn.ENEMY
		sound_manager.play_sound(TURN_ENEMY)
		if tutorial_enabled and !has_encountered_debt:
			if enemy.debt > 0:
				has_encountered_debt = true
				current_tutorial = create_tutorial("DEBT", "Each Stack of DEBT reduces 1 GAIN next turn.",tutorial_area.global_position,-50)
		if tutorial_enabled and !has_encountered_thrift:
			if enemy.thrift > 0:
				has_encountered_thrift = true
				current_tutorial = create_tutorial("THRIFT", "Each Stack of THRIFT blocks\n 1 vacant slot on the Arcane Circle.",tutorial_area.global_position,-50)
		if tutorial_enabled and !has_encountered_spend:
			if enemy.spend > 0:
				has_encountered_spend = true
				current_tutorial = create_tutorial("SPEND", "While having SPEND, each Coin Flip costs 2 Coins.",tutorial_area.global_position,-50)
		await enemy.start_enemy_turn()
		if enemy.coin > 0:
			if current_tutorial != null: current_tutorial.close()
			start_player_turn()
		else:
			check_defeat()

func _on_endturn_pressed():
	if enemy.coin > 0 and player.coin > 0:
		if tutorial_enabled:
			if has_encountered_endturn:
				if tutorial_enabled and current_tutorial != null: current_tutorial.close()
				if tutorial_enabled and !has_encountered_reflip and current_room == 1: has_encountered_reflip = true
				await player.end_turn()
				turn_calculation_box.exit()
				var defeat = await check_defeat()
				if defeat == null:
					await get_tree().create_timer(1.0).timeout
					if !player.has_extra_turn:
						start_enemy_turn()
						player.extra_turn_penalty = 1
					else:
						sound_manager.play_sound(EXTRA_TURN)
						show_turn_ui("EXTRA TURN")
						player.extra_turn()
						player.has_extra_turn = false
		else:
			if current_tutorial != null: current_tutorial.close()
			await player.end_turn()
			turn_calculation_box.exit()
			var defeat = await check_defeat()
			if defeat == null:
				await get_tree().create_timer(1.0).timeout
				if !player.has_extra_turn:
					start_enemy_turn()
					player.extra_turn_penalty = 1
				else:
					sound_manager.play_sound(EXTRA_TURN)
					show_turn_ui("EXTRA TURN")
					player.extra_turn()
					player.has_extra_turn = false

func show_passive_notification(text: String, duration: float = 1.5) -> void:
	var notif = PASSIVE_SCENE.instantiate()
	passive_label.add_child(notif)
	
	notif.setup(text)
	
	var container_width = passive_label.get_size().x
	notif.position = Vector2(container_width + 50, 0)
	
	notif.modulate.a = 1.0
	notif.scale = Vector2(0.9, 0.9)
	notif.z_index = 100
	
	var tween_in = create_tween()
	tween_in.parallel().tween_property(notif, "position:x", 0, 0.3)
	tween_in.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.3)
	
	for i in range(passive_label.get_child_count()):
		var child = passive_label.get_child(i)
		if child != notif:
			child.position.y += 30
			
		await get_tree().create_timer(duration).timeout
	
func show_enemy_passive(text: String, duration: float = 2.5) -> void:
	if not is_instance_valid(enemy_passive_label):
		return
		
	if enemy_notif_base_pos == Vector2.ZERO:
		enemy_notif_base_pos = enemy_passive_bg.position
	
	# Kill previous animation (IMPORTANT)
	if enemy_notif_tween and enemy_notif_tween.is_running():
		enemy_notif_tween.kill()
	
	enemy_passive_label.text = text
	enemy_passive_label.visible = true
	enemy_passive_bg.visible = true
	enemy_passive_label.modulate.a = 0.0
	enemy_passive_bg.modulate.a = 0.0
	enemy_passive_label.scale = Vector2(0.9, 0.9)

	
	enemy_notif_tween = create_tween()
	enemy_notif_tween.parallel().tween_property(enemy_passive_label, "modulate:a", 1.0, 0.2)
	enemy_notif_tween.parallel().tween_property(enemy_passive_bg, "modulate:a", 1.0, 0.2)
	enemy_notif_tween.parallel().tween_property(enemy_passive_label, "position:y", enemy_notif_base_pos.y + 15, 0.2)
	enemy_notif_tween.parallel().tween_property(enemy_passive_label, "scale", Vector2(1.05, 1.05), 0.2)
	enemy_notif_tween.tween_property(enemy_passive_label, "scale", Vector2(1, 1), 0.1)
	enemy_notif_tween.tween_interval(duration)
	enemy_notif_tween.tween_property(enemy_passive_label, "modulate:a", 0.0, 0.4)
	enemy_notif_tween.tween_property(enemy_passive_bg,	 "modulate:a", 0.0, 0.4)
	enemy_notif_tween.tween_callback(func():
		enemy_passive_label.visible = false
		enemy_passive_bg.visible = false
	)
	

func _on_flip_pressed():
	if current_turn != Turn.PLAYER:
		return
	player.flip()
	if tutorial_enabled and has_encountered_reflip and !has_encountered_reserve and player.current_played_coin >= 16:
		if current_tutorial != null: current_tutorial.close()
		has_encountered_reserve = true
		current_tutorial = create_tutorial("Coin Reserve", "If Arcane Circle overflows with coins, \nadd it to the Reserve.",tutorial_area.global_position,-400)
	if tutorial_enabled and !has_encountered_flip and player.current_played_coin > 1:
		has_encountered_flip = true
		current_tutorial.close()
		current_tutorial = create_tutorial("Coin Spells","𖤓 + 𖤓 = More DAMAGE \n☾ + ☾ = More GAIN \n𖤓 + ☾ = Low DAMAGE and Low GAIN",player_health_bar.global_position,-200)
		has_encountered_spells = true
	if tutorial_enabled and has_encountered_spells and !has_encountered_endturn and player.current_played_coin > 5:
		has_encountered_endturn = true
		player.toggle_button(re_flip_button,true)
		player.toggle_button(flip_button,true)
		current_tutorial.close()
		current_tutorial = create_tutorial("End Turn","Press the Center of the Arcane Circle\nto end your turn.",endTurn_button.global_position,-100)
		
	if player.coin == 0 or enemy.coin == 0:
		check_defeat()

	
	
func trigger_game_over(player_won: bool):
	sound_manager.play_sound(DEATH)
	sound_manager.stop_music()
	if player_won:
		enemy.max_playable_coins = 0
		if current_enemy_index != 8:
			reward_manager.show_rewards()
	
	game_over_ui.visible = true
	
	flip_button.disabled = true
	re_flip_button.disabled = true
	endTurn_button.disabled = true
	
	
	set_process(false)
	
	var result_label = game_over_ui.get_node("ColorRect/Gameover")
	var enemy_label = game_over_ui.get_node("ColorRect/EnemyLabel")
	
	var stats = {
	"remaining_coins": player.coin,
	"total_damage_dealt": total_damage_dealt,
	"highest_damage_dealt": highest_damage_dealt,
	"total_gain": total_gain,
	"highest_gain": highest_gain,
	"overall_total_damage": overall_total_damage,
	"overall_highest_damage": overall_highest_damage,
	"overall_total_gain": overall_total_gain,
	"overall_highest_gain": overall_highest_gain,
	"enemies_defeated": enemies_defeated,
	"heads": total_heads,
	"tails": total_tails,
	"flips": total_flips,
	"reflips": total_reflips
}
	game_over_ui.show_stats(stats)
	game_over_ui.visible = true
	
	
	
	match current_enemy_type:
		Enemy.MAGE:
			if is_surrender:
				result_label.text = "RUN ABANDONED"
				enemy_label.text = "You gave up the fight..."
			else:
				result_label.text = "CONSUMED BY MAGIC"
				enemy_label.text = "Mage Wins"

		Enemy.DWARF:
			if is_surrender:
				result_label.text = "RUN ABANDONED"
				enemy_label.text = "You gave up the fight..."
			else:
				result_label.text = "CRUSHED BY THE FORGE"
				enemy_label.text = "Dwarf Wins"

		Enemy.COLLECTOR:
			if is_surrender:
				result_label.text = "RUN ABANDONED"
				enemy_label.text = "You gave up the fight..."
			else:
				result_label.text = "ADDED TO THE COLLECTION"
				enemy_label.text = "Collector Wins"

		Enemy.TRADER:
			if is_surrender:
				result_label.text = "RUN ABANDONED"
				enemy_label.text = "You gave up the fight..."
			else:
				result_label.text = "A BAD DEAL"
				enemy_label.text = "Trader Wins"

		Enemy.THRIFTER:
			if is_surrender:
				result_label.text = "RUN ABANDONED"
				enemy_label.text = "You gave up the fight..."
			else:
				result_label.text = "SPENT TO NOTHING"
				enemy_label.text = "Thrifter Wins"

		Enemy.ARISTOCRAT:
			if is_surrender:
				result_label.text = "RUN ABANDONED"
				enemy_label.text = "You gave up the fight..."
			else:
				result_label.text = "BENEATH THEIR CLASS"
				enemy_label.text = "Aristocrat Wins"

		Enemy.SUN_CASTER:
			if is_surrender:
				result_label.text = "RUN ABANDONED"
				enemy_label.text = "You gave up the fight..."
			else:
				result_label.text = "SCORCHED BY DAWN"
				enemy_label.text = "Sun Caster Wins"

		Enemy.MOON_CASTER:
			if is_surrender:
				result_label.text = "RUN ABANDONED"
				enemy_label.text = "You gave up the fight..."
			else:
				result_label.text =  "CONSUMED BY DUSK"
				enemy_label.text = "Moon Caster Wins"

		Enemy.TWILIGHT_SAGE:
			if is_surrender:
				result_label.text = "RUN ABANDONED"
				enemy_label.text = "You gave up the fight..."
			elif player_won:
				result_label.text = "PLAYER WON"
				enemy_label.text = "Twilight Sage has been slain"
			else:
				result_label.text =  "LOST IN TWILIGHT"
				enemy_label.text = "Twilight Sage Wins"

	enemy_label.modulate.a = 0.0
	
	await get_tree().create_timer(2.0).timeout
	var tween = create_tween()
	tween.tween_property(enemy_label, "modulate:a", 1.0, 1.0)
	is_surrender = false
	
	
	

func check_defeat():
	if player.coin <= 0:
		if player.has_payback:
			if player.payback_used:
				game_over_ui.visible = true
				trigger_game_over(false)
		else:
			game_over_ui.visible = true
			trigger_game_over(false)
		return true
		
	if enemy.coin <= 0:
		flip_button.disabled = true
		endTurn_button.disabled = true 
		re_flip_button.disabled = true
		enemies_defeated += 1
		await handle_victory_flow()
		return true
	
	return null

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
	particle_manager.despawn_emitting_particles()
	await show_turn_ui("VICTORY")
	sound_manager.play_sound(PASSIVE_SPARE_CHANGE)
	var reserved_coins = get_tree().get_nodes_in_group("reserved coins")
	for c in reserved_coins:
		player.coin += 1
		c.queue_free()
		player.current_reserve -= 1
	
	if current_tutorial != null: current_tutorial.close()
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
	
	player.coin += enemy.bounty
	await progression_after_victory()
	#wait reward_manager.show_card_selection_async()
	#wait show_map()
	
func progression_after_victory():
	#var map = MAP_SCENE.instantiate()
	#map.setup(current_room)
	#add_child(map)
	if current_room == 5:
		current_room = 5
		trigger_game_over(true)
	elif current_room < 4:
		sound_manager.stop_music()
		sound_manager.play_music(PASSIVE_SELECTION)
		await reward_manager.show_card_selection_async()
		current_room += 1
			#map.background.global_position.y = 1000
			#add_child(map)
			#tween = create_tween()
			#tween.tween_property(map,"position:y",0,0.4)
		await _play_progression_cutscene(current_room - 1, current_room)
		if current_room == 4:
			await shop_manager.show_shop_async(player)
			current_room += 1
			await _play_progression_cutscene(current_room - 1, current_room)
			proceed_to_next_enemy()
		else:
			proceed_to_next_enemy()
		
func _on_re_flip_pressed():
	if !has_encountered_reflip:
		has_encountered_reflip = true
		if current_tutorial != null: current_tutorial.close()
	player.re_flip()

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
	player_health_label.text = "Coins: " + str(player.coin)
	
func update_player_reflip_and_reserve():
	if player.slow:
		player_slow_particles.emitting = true
		player_slow.visible = true
	else:
		player_slow_particles.emitting = false
		player_slow.visible = false
	if player.lock:
		player_reserve.text = ""
		player_lock.visible = true
		player_lock_particles.emitting = true
	else:
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
	await get_tree().create_timer(0.2).timeout
	get_tree().reload_current_scene()
	

func proceed_to_next_enemy():
	match enemies_defeated:
		1:
			current_enemy_index = randi_range(2,3)
		2:
			current_enemy_index = randi_range(4,5)
		3:
			current_enemy_index = randi_range(6,7)
		4:
			current_enemy_index = 8
	battle_start()
	print("I AM RWADY TO BATTLE")


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

func _play_progression_cutscene(from_index: int, to_index: int) -> void:
	get_tree().paused = true
	var screen_height = get_viewport_rect().size.y 
	
	progression_map.offset.y = -screen_height 
	progression_map.visible = true
	
	var slide_in = progression_map.create_tween()
	slide_in.tween_property(progression_map, "offset:y", 0.0, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	slide_in.tween_interval(0.3)
	await slide_in.finished
	
	player_sprite.play("default") 
	
	var walk_tween = progression_map.create_tween()
	
	var distance = player_sprite.global_position.distance_to(map_markers[to_index].global_position)
	var walk_duration = distance / 80.0 
	
	walk_tween.tween_property(player_sprite, "global_position", map_markers[to_index].global_position, walk_duration).set_trans(Tween.TRANS_LINEAR)
	await walk_tween.finished

	var dramatic_pause = progression_map.create_tween()
	dramatic_pause.tween_interval(1.0)
	await dramatic_pause.finished
	sound_manager.stop_music()
	sound_manager.play_sound(PASSIVE_PASSIVE_INCOME)
	
	var slide_out = progression_map.create_tween()
	slide_out.tween_property(progression_map, "offset:y", -screen_height, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	await slide_out.finished

	progression_map.visible = false
	get_tree().paused = false
	


func _show_temporary_passive(id: String, text: String, duration: float = 1.5):
	
	if active_temp_ids.has(id):
		return
	
	active_temp_ids[id] = true
	
	
	var notif: Control = PASSIVE_SCENE.instantiate()
	passive_label.add_child(notif)
	notif.setup(text)
	notif.modulate.a = 0.0
	notif.scale = Vector2(0.9, 0.9)
	notif.z_index = 200 # above persistent passives
	
	active_temp_notifs.append(notif)
	
	_restack_passives()
	
	# Start off-screen
	var container_width = passive_label.get_rect().size.x
	notif.position = Vector2(container_width + 200, 40)
	
	# Slide in and fade in
	var tween = create_tween()
	tween.parallel().tween_property(notif, "position:x", 0, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(notif, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.2)
	await tween.finished
	
	# Wait duration
	await get_tree().create_timer(duration).timeout
	
	# Fade out
	var tween_out = create_tween()
	tween_out.tween_property(notif, "modulate:a", 0.0, 0.2)
	tween_out.tween_callback(func():
		if is_instance_valid(notif):
			active_temp_notifs.erase(notif)
			active_temp_ids.erase(id)
			notif.queue_free()
			_restack_passives()
	)

func _restack_passives():
	var spacing = 40
	var index = 0
	
	var tween = create_tween()
	
	# Persistent passives
	var hidden_count = 0
	
	for i in range(passive_order.size()):
		var id = passive_order[i]
		var notif = active_passive_notifs[id]
	
		if not is_instance_valid(notif):
			continue
	
		if index < max_visible_passives:
			notif.visible = true
		
			var target_y = index * spacing
			tween.parallel().tween_property(notif, "position:y", target_y, 0.2)
			tween.parallel().tween_property(notif, "modulate:a", 1.0, 0.2)
			tween.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.2)
		
			index += 1
		else:
			notif.visible = false
			hidden_count += 1
			
	if hidden_count > 0:
		if overflow_notif == null or !is_instance_valid(overflow_notif):
			overflow_notif = PASSIVE_SCENE.instantiate()
			passive_label.add_child(overflow_notif)
			
			overflow_notif.gui_input.connect(func(event):
				if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					max_visible_passives = min(max_visible_passives + 3, passive_order.size())
					_restack_passives()
	)
	
		overflow_notif.visible = true
		overflow_notif.setup("+" + str(hidden_count) + " more...")
	
		var target_y = index * spacing
		tween.parallel().tween_property(overflow_notif, "position:y", target_y, 0.2)
		tween.parallel().tween_property(overflow_notif, "modulate:a", 0.6, 0.2)
		tween.parallel().tween_property(overflow_notif, "scale", Vector2(0.85, 0.85), 0.2)
	
		index += 1
	else:
		if overflow_notif != null and is_instance_valid(overflow_notif):
			overflow_notif.visible = false
			
	# Temporary passives
	for notif in active_temp_notifs:
		if not is_instance_valid(notif):
			continue
		var target_y = index * spacing
		tween.tween_property(notif, "position:y", target_y, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		index += 1
		
func show_all_passive_notifications():
	if player.has_wishbone:
		trigger_passive("wishbone", "WISH BONE")
		
	if player.has_golden_clover:
		trigger_passive("golden_clover", "GOLDEN CLOVER")
		
	if player.has_sleight_of_hand:
		trigger_passive("sleight_of_hand", "SLEIGHT OF HAND")
		
	if player.has_pocket_money:
		trigger_passive("pocket_money", "POCKET MONEY")
		
	if player.has_inflation:
		trigger_passive("inflation", "INFLATION")
		
	if player.has_lending_charge:
		trigger_passive("lending_charge", "LENDING CHARGE")

	if player.has_deposit:
		trigger_passive("deposit", "DEPOSIT")

	# --- SHOP PASSIVE (PERSISTENT) ---
	if player.has_merchant_scroll:
		trigger_passive("merchant_scroll", "MERCHANT SCROLL")


		
enum PassiveDisplayType {
	PERSISTENT,
	TEMPORARY
}

var passive_display_type = {
	# --- PERSISTENT ---
	"wishbone": PassiveDisplayType.TEMPORARY,
	"golden_clover": PassiveDisplayType.TEMPORARY,
	"deposit": PassiveDisplayType.TEMPORARY,
	"sleight_of_hand": PassiveDisplayType.TEMPORARY,
	"pocket_money": PassiveDisplayType.TEMPORARY,
	"passive_income": PassiveDisplayType.TEMPORARY,
	"lending_charge": PassiveDisplayType.TEMPORARY,
	"reimbursement": PassiveDisplayType.TEMPORARY,
	"merchant_scroll": PassiveDisplayType.TEMPORARY,

	# --- TEMPORARY ---
	"piggy": PassiveDisplayType.TEMPORARY,
	"advanced_planning": PassiveDisplayType.TEMPORARY,
	"value_increase": PassiveDisplayType.TEMPORARY,
	"simple_interest": PassiveDisplayType.TEMPORARY,
	"jar_o_savings": PassiveDisplayType.TEMPORARY,
	"withdraw": PassiveDisplayType.TEMPORARY,
	"dividend": PassiveDisplayType.TEMPORARY,
	"payback": PassiveDisplayType.TEMPORARY,
	"cash_out": PassiveDisplayType.TEMPORARY,
	"triple_nickel": PassiveDisplayType.TEMPORARY,
	"solar_coin": PassiveDisplayType.TEMPORARY,
	"lunar_coin": PassiveDisplayType.TEMPORARY,
	"lucky_pair": PassiveDisplayType.TEMPORARY,
	"refund": PassiveDisplayType.TEMPORARY,
	"spare_change": PassiveDisplayType.TEMPORARY,
	"coin_snipe": PassiveDisplayType.TEMPORARY,
	"inflation": PassiveDisplayType.TEMPORARY,
	"active_income": PassiveDisplayType.TEMPORARY,
	"impromptu_flip": PassiveDisplayType.TEMPORARY,
	"magic_trick": PassiveDisplayType.TEMPORARY,
	"loan_shark": PassiveDisplayType.TEMPORARY,
	"pay_down": PassiveDisplayType.TEMPORARY
}

func trigger_passive_notification(id: String, text: String):
	if not passive_display_type.has(id):
		print("⚠ Missing passive display type for: ", id)
		return
	
	match passive_display_type[id]:
		PassiveDisplayType.PERSISTENT:
			_add_persistent_passive(id, text)
		PassiveDisplayType.TEMPORARY:
			_show_temporary_passive(id, text, 2)
			
func _add_persistent_passive(id: String, text: String,):
	if active_passive_notifs.has(id):
		return
	
	var notif: Control = PASSIVE_SCENE.instantiate()
	passive_label.add_child(notif)
	notif.setup(text)
	notif.modulate.a = 0.0
	notif.scale = Vector2(0.9, 0.9)
	notif.z_index = 100
	
	active_passive_notifs[id] = notif
	passive_order.append(id)
	
	# Slide in
	var container_width = passive_label.get_rect().size.x
	notif.position = Vector2(container_width + 200, 0)
	var tween = create_tween()
	tween.parallel().tween_property(notif, "position:x", 0, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(notif, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.2)
	
	_restack_passives()
	
func trigger_passive(id: String, text: String):
	var time = Time.get_ticks_msec()
	
	# Prevent spam (200ms window)
	if recent_triggers.has(id):
		if time - recent_triggers[id] < 200:
			return
	
	recent_triggers[id] = time
	
	trigger_passive_notification(id, text)

func trigger_passive_effect(text: String):
	show_passive_notification(text, 1.5)
