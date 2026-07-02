extends TextureRect

enum Turn {
	PLAYER,
	ENEMY,
	KEEPER
}

signal start_journey
@onready var start_run: CanvasLayer = $StartRun

@onready var greed_stamp: TextureRect = $"Progression Map/Greed_Stamp"
@onready var greed_stamp_start: TextureRect = $StartRun/Greed_Stamp

const SCROLL_OPEN = preload("uid://ciyhsb2lowwtt")
const GAME_OVER_WALL_CLOSE = preload("uid://dcogb5vig426m")
const GAME_OVER_WALL = preload("uid://cen1jkl1h44jj")
const SLOW = preload("uid://f5jmno7qyhek")
@onready var boss_defeat_transition: TextureRect = $BossDefeatTransition
const CRITICAL = preload("uid://nnwjjtfxt47l")
const SPEND_DAMAGE_PARTICLE = preload("uid://dmgnoylltbfre")
const SPEND_EXPLOSION_PARTICLE = preload("uid://bgfgq2kw3njao")
const GAIN_EFFECT_PARTICLE = preload("uid://c5py6ekby1mnm")
const THRIFT_DAMAGE_PARTICLE = preload("uid://bvrulyxw02bom")
const INFLATION_PARTICLE = preload("uid://bq67mkmrnr14p")
const COIN_BARRAGE_PARTICLE = preload("uid://btjsmqynj8nhe")
const VOIDED = preload("uid://ctvrb7nmqgd06")

const BOSS_DEFEATED = preload("uid://pbrojuc0bit1")
@onready var enemy_passive_container: CenterContainer = $"Battle UI/EnemyPassiveContainer"

@onready var forest_area: TextureRect = $"Forest Area"
@onready var fields_area: TextureRect = $"Fields Area"
@onready var shop_area: TextureRect = $"Shop Area"
@onready var player_info_passive_screen: Button = $"CardManager/Player Info Passive Screen"
@onready var card_manager: CanvasLayer = $CardManager
@onready var player_info_shop_screen: Button = $"ShopManager/Player Info Shop Screen"
@onready var shop_manager: CanvasLayer = $ShopManager

@onready var turn_spell_light: PointLight2D = $"Battle UI/Turn Calculation Box/Turn Spell Light"
@onready var dazzled_light: PointLight2D = $"Dazzled Effect/Dazzled Light"
@onready var keeper_info: Button = $"Keeper Info"


@onready var loan_shark: AnimatedSprite2D = $"Battle UI/LoanShark"
@onready var loan_splash: Marker2D = $"Battle UI/LoanShark/Loan Splash"
@onready var loan_enter: Marker2D = $"Battle UI/LoanShark/Loan Enter"

var is_game_over = false
var is_boss_defeated = false

const DEBT_EFFECT_PARTICLE = preload("uid://c52tpyupg2ynl")
const DEBT_DAMAGE_PARTICLE = preload("uid://1g21u656k60k")
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



@onready var player = $Player
@onready var enemy = $Enemy
@onready var shopkeeper: Node2D = $Shopkeeper

@onready var camera_2d: Camera2D = $Camera2D
@onready var main: TextureRect = $"."
var greed_color = '#ffa889'
var vignette_default = '#bdabb8'
var vignetter_default = '#ffe6909e'
var sun_caster_color = '#e56400'
var moon_caster_color = '#1a54fb'
var dawn_stance = '#ffcda0'
var dusk_stance = '#8dacf7'
@onready var dusk_particles: GPUParticles2D = $"ParticleManager/Dusk Particles"
@onready var dawn_particles: GPUParticles2D = $"ParticleManager/Dawn Particles"
@onready var reserve_button: TextureButton = $"Battle UI/Reserve Button"
@onready var player_reserve: Label = $"Battle UI/Reserve Button/Player Reserve"
@onready var player_reserve_rug: TextureRect = $"Player/Player Reserve Rug"
@onready var reserve_outside_texture: TextureRect = $"Player/Player Reserve Rug/OutsideTexture"
@onready var vignette: CanvasModulate = $Vignette
@onready var vignetter: PointLight2D = $Vignetter
@onready var mist_particles: GPUParticles2D = $"ParticleManager/Mist Particles"

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

# --- PROGRESSION MAP ---
@onready var progression_map: CanvasLayer = $"Progression Map"
@onready var banner: TextureRect = $"Progression Map/MapBackground/Banner"
@onready var player_sprite: AnimatedSprite2D = $"Progression Map/MapBackground/Player_Sprite"

@onready var map_markers: Array[Node] = [
$"Progression Map/Enemy 1", 
$"Progression Map/Enemy 2", 
$"Progression Map/Enemy 3", 
$"Progression Map/Elite Enemy", 
$"Progression Map/Shop", 
$"Progression Map/Boss"
]
@onready var player_info: Button = $"Player Info"
@onready var enemy_info: Button = $"Enemy Info"


@onready var endTurn_button = $"Battle UI/Endturn"
@onready var flip_button = $"Battle UI/PlayerHealthBar2"
@onready var re_flip_button: Button = $"Battle UI/Re-Flip"
@onready var reflip_sprite: AnimatedSprite2D = $"Battle UI/Re-Flip/Reflip_Sprite"
@onready var reflip_label: Label = $"Battle UI/Re-Flip/Reflip_Label"
@onready var turn_calculation: Label = $"Battle UI/Turn Calculation Box/Turn Calculation"
@onready var turn_calculation_box: TextureRect = $"Battle UI/Turn Calculation Box"
@onready var turn_damage_particle: GPUParticles2D = $"Battle UI/Turn Calculation Box/Turn Damage Particle"
@onready var turn_gain_particle: GPUParticles2D = $"Battle UI/Turn Calculation Box/Turn Gain Particle"
@onready var turn_debt_particle: GPUParticles2D = $"Battle UI/Turn Calculation Box/Turn Debt Particle"
@onready var turn_thrift_particle: GPUParticles2D = $"Battle UI/Turn Calculation Box/Turn Thrift Particle"
@onready var turn_spend_particle: GPUParticles2D = $"Battle UI/Turn Calculation Box/Turn Spend Particle"
@onready var turn_tally_particle: GPUParticles2D = $"Battle UI/Turn Calculation Box/Turn Tally Particle"

@onready var player_health_bar = $"Battle UI/PlayerHealthBar2"
@onready var player_gain: Label = $"Player/Player Gain"
@onready var player_debt: Label = $"Player/Player Debt"
@onready var player_health_label = $"Battle UI/HealthLabel"
@onready var player_thrift: Label = $"Player/Player Thrift"
@onready var player_lock: Label = $"Player/Player Lock"
@onready var player_slow: Label = $"Battle UI/Re-Flip/Player Slow"
@onready var player_slow_particles: GPUParticles2D = $"Battle UI/Re-Flip/Player Slow Particles"

var slow_color = "#43a563"
const PLAYER_INFORMATION_DISPLAY = preload("res://Scene/PlayerInformationDisplay.tscn")
var player_info_menu: Node = null
const ENEMY_INFORMATION_DISPLAY = preload("uid://1lqiy1lfcalo")
var enemy_info_menu: Node = null
const KEEPER_INFORMATION_DISPLAY = preload("uid://c8vfntelui3b7")
var keeper_info_menu: Node = null
const POST_GAME_SCREEN = preload("uid://c7uk7pxxcix85")

@onready var player_lock_particles: GPUParticles2D = $"Player/Player Lock Particles"
@onready var player_gain_particles: GPUParticles2D = $"Player/Player Gain Particles"
@onready var player_debt_particles: GPUParticles2D = $"Player/Player Debt Particles"
@onready var enemy_debt_particles: GPUParticles2D = $"Enemy/Enemy Debt Particles"
@onready var player_thrift_particles: GPUParticles2D = $"Player/Player Thrift Particles"
@onready var enemy_thrift_particles: GPUParticles2D = $"Enemy/Enemy Thrift Particles"
@onready var enemy_gain_particles: GPUParticles2D = $"Enemy/Enemy Gain Particles"
@onready var dazzled_effect: TextureRect = $"Player/Dazzled Effect"
@onready var player_tally: TextureRect = $"Player/Player Tally"
@onready var tally_effect: TextureRect = $"Tally Effect"
@onready var tally_flip_count: Label = $"Tally Effect/Tally Flip Count"
@onready var player_tally_count: Label = $"Player/Player Tally/Player Tally Count"


@onready var player_spend_particles: GPUParticles2D = $"Battle UI/Player Spend Particles"
@onready var player_spend: Label = $"Battle UI/Player Spend"
@onready var enemy_spend_particles: GPUParticles2D = $"Battle UI/Enemy Spend Particles"
@onready var enemy_spend: Label = $"Battle UI/Enemy Spend"


@onready var enemy_health_bar = $"Battle UI/EnemyHealthBar"
@onready var enemy_health_label: Label = $"Battle UI/EnemyHealthLabel"
@onready var keeper_health_bar: Control = $Shopkeeper/KeeperHealthBar
@onready var keeper_health_label: Label = $Shopkeeper/KeeperHealthLabel
@onready var enemy_gain: Label = $"Enemy/Enemy Gain"
@onready var enemy_debt: Label = $"Enemy/Enemy Debt"
@onready var enemy_thrift: Label = $"Enemy/Enemy Thrift"

@onready var enemy_passive_label: Label = $"Battle UI/EnemyPassiveContainer/Background/EnemyLabelNotification"
@onready var enemy_passive_bg: TextureRect = $"Battle UI/EnemyPassiveContainer/Background"
var enemy_notif_tween: Tween = null
var enemy_notif_base_pos: Vector2

@onready var turn_ui: TextureRect = $"Battle UI/Turn UI"
@onready var turn_ui_label: Label = $"Battle UI/Turn UI/Turn UI Label"
@onready var turn_portrait: AnimatedSprite2D = $"Battle UI/Turn UI/PortraitBG/Turn Portrait"

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

@onready var pause_menu = $PauseMenu

#COIN DECK 
@onready var coin_deck: Node2D = $CoinDeck
@onready var reward_manager = $CardManager

#COIN
const COIN = preload("uid://ddet242jm5v23")

#Timer
@onready var timer_label = $CanvasLayer/Timer

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
var run_timer: float = 0.0
var run_timer_active: bool = false
var total_debt_applied: int = 0
var highest_debt_applied: int = 0

var overall_total_damage: int = 0
var overall_highest_damage: int = 0
var overall_total_gain: int = 0
var overall_highest_gain: int = 0

var played_turns: int = 0
var total_damage_taken: int = 0
var current_enemy_type

var is_surrender = false

var current_enemy_index
var current_room

func _on_item_purchased(card_id,price):
	update_player_coin()
	if shop_manager.visible:
		shop_manager.coin_label.text = "Coins: " + str(player.coin)

func switch_vignette_color(to,duration):
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	tween.tween_property(vignette,"color",Color.from_string(to,Color.WHITE),duration)

func switch_vignetter_color(to,duration):
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	tween.tween_property(vignetter,"color",Color.from_string(to,Color.WHITE),duration)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	total_damage_dealt = 0
	highest_damage_dealt = 0
	total_gain = 0
	highest_gain = 0
	is_game_over = false
	forest_area.visible = true
	dusk_particles.emitting = true
	dawn_particles.emitting = false
	
	spin_reserve_rug(20.0)
	
	await get_tree().create_timer(0.4).timeout
	await _play_fake_coin_intro()
	turn_calculation_box.visible = false
	turn_ui.visible = false
	current_room = 0
	current_enemy_index = randi_range(0,1)
	passive_manager.setup(self)
	player.setup(self)
	#show_enemy_passive("Hello!", 3.0)
	pause_menu.visible = false
	turn_ui.visible = false
	print(reward_manager)
	player.reset_stats()

	#GREED MODE
	if player.greed: 
		main.self_modulate = Color(greed_color)
		enemy.greed = true
		player.coin += 15
		player.silver_flip_rate += 0.2
		player.gold_flip_rate += 0.1
	else: main.self_modulate = Color.WHITE
	shop_manager.item_purchased.connect(_on_item_purchased)
	
	if not pause_menu.end_run_pressed.is_connected(_on_end_run_pressed):
		pause_menu.end_run_pressed.connect(_on_end_run_pressed)
 	
	if not endTurn_button.pressed.is_connected(_on_endturn_pressed):
		endTurn_button.pressed.connect(_on_endturn_pressed)
	if not re_flip_button.pressed.is_connected(_on_re_flip_pressed):
		re_flip_button.pressed.connect(_on_re_flip_pressed) 
	
	if player.greed:
		greed_stamp.visible = true
		greed_stamp_start.visible = true

	
func _unhandled_input(event: InputEvent) -> void:
	if is_boss_defeated and is_game_over:
		return
	if !event.is_action_pressed("ui_cancel"): # ESC key
		return
	#if current_turn != Turn.PLAYER:
	#	return
	toggle_pause()
	get_viewport().set_input_as_handled()
		
func toggle_pause():
	if PauseManager.is_paused:
		PauseManager.resume()
		pause_menu.visible = true
		sound_manager.pause_sfx()
		turn_spell_light.visible = false
	else:
		PauseManager.pause()
		pause_menu.visible = false
		sound_manager.resume_sfx()
		turn_spell_light.visible = turn_calculation_box.visible

	print("After toggle - is_paused: ", PauseManager.is_paused, " tree paused: ", get_tree().paused)
	
func battle_start():
	if not run_timer_active:
		run_timer = 0.0
		run_timer_active = true
		
	re_flip_button.visible = true
	player_reserve.visible = true
	flip_button.disabled = true
	switch_vignetter_color(vignetter_default,0.1)
	switch_vignette_color(vignette_default,0.1)
	
	if fields_area.is_visible_in_tree():
		mist_particles.emitting = true
	
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
		
	coins = get_tree().get_nodes_in_group("keeper_coins")
	for coin in coins:
		coin.queue_free()
		
	reserved_coin = null
	player.refresh_start_of_battle_stats()
	enemy.refresh_start_of_battle_stats()
	if player.has_active_income:
		shopkeeper.refresh_start_of_battle_stats()
	enemy.reset_passives()
	show_all_passive_notifications()

	coin_deck.reset_sigils()
	reflip_label.text = str(player.max_re_flip - player.current_re_flip)

	randomize()
	
	flip_button.pressed.connect(_on_flip_pressed)
	endTurn_button.pressed.connect(_on_endturn_pressed)
	re_flip_button.pressed.connect(_on_re_flip_pressed)
	if player.has_active_income or player.has_merchant_scroll:
		keeper_health_label.text = "0"
		shopkeeper.setup(self)
		shopkeeper.visible = true
	else:
		shopkeeper.visible = false

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
	current_turn = Turn.PLAYER
	start_player_turn()

func _process(delta: float) -> void:
	update_player_coin()
	update_enemy_coin()
	update_player_stacks()
	update_enemy_stacks()
	update_player_status()
	
	if run_timer_active:
		run_timer += delta
		var minutes = int(run_timer) / 60
		var seconds = int(run_timer) % 60
		timer_label.text = "%02d:%02d" % [minutes, seconds]

func show_turn_ui(text):
	sound_manager.play_sound(TURN_REVEAL)
	endTurn_button.disabled = true
	turn_ui.visible = true
	turn_ui_label.text = text
	turn_ui.modulate = Color("ffffff00")
	turn_ui.global_position = get_viewport_rect().size / 2
	turn_ui.global_position.x -= 350
	turn_ui.global_position.y += 10
	
	var target_position = turn_ui.global_position.y - 40
	
	if current_turn == Turn.ENEMY:
		match current_enemy_index:
			0: 
				turn_portrait.play("MAGE")
			1: 
				turn_portrait.play("DWARF")
			2: 
				turn_portrait.play("COLLECTOR")
			3: 
				turn_portrait.play("TRADER")
			4: 
				turn_portrait.play("THRIFTER")
			5:
				turn_portrait.play("ARISTOCRAT")
			6: 
				turn_portrait.play("SUN_CASTER")
			7: 
				turn_portrait.play("MOON_CASTER")
			8:
				turn_portrait.play("TWILIGHT_SAGE")
	elif current_turn == Turn.KEEPER:
		turn_portrait.play("SHOPKEEPER")
	else:
		turn_portrait.play("COIN_CASTER")

	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	tween.parallel().tween_property(turn_ui,"modulate",Color("ffffff"),0.2)
	tween.parallel().tween_property(turn_ui, "position:y",target_position,0.2)
	await get_tree().create_timer(1.0, true).timeout
	print("=============================UI DONE")
	turn_ui_label.text = text
	tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	tween.parallel().tween_property(turn_ui,"modulate",Color("ffffff00"),0.2)
	tween.parallel().tween_property(turn_ui, "position:y",target_position - 30,0.2)
	if current_turn == Turn.PLAYER:
		if player.has_pocket_money:
			await get_tree().create_timer(1.0, true).timeout
		endTurn_button.disabled = false
	await get_tree().create_timer(1.0, true).timeout
	print("=============================UI DONE")
	
func _on_end_run_pressed():
	start_run.visible = false
	card_manager.visible = false
	shop_manager.visible = false
	player_health_label.text = "0"
	player.coin = 0
	
	print("Main Script: Received End Run")
	PauseManager.pause()
	pause_menu.visible = false
	is_surrender = true
	await get_tree().process_frame
	trigger_game_over(false)

	
func start_player_turn():
	played_turns += 1
	endTurn_button.mouse_default_cursor_shape = 2
	flip_button.mouse_default_cursor_shape = 2
	reserve_button.mouse_default_cursor_shape = 2
	re_flip_button.mouse_default_cursor_shape = 2
	
	enemy_info.visible = true
	player_info.visible = true
	if player.has_merchant_scroll or player.has_fully_paid:
		keeper_info.visible = true
	if player.coin > 0:
		current_turn = Turn.PLAYER
		if player.payback_used:
			show_turn_ui("PAYBACK")
		else:
			show_turn_ui("YOUR TURN")
		sound_manager.play_sound(TURN_PLAYER)
		await player.start_turn()
	else:
		check_defeat()

func start_keeper_turn():
	current_turn = Turn.KEEPER
	show_turn_ui("SHOPKEEPER'S TURN")
	coin_deck.reset_sigils()
	sound_manager.play_sound(TURN_PLAYER)
	if shopkeeper.has_fully_paid:
		shopkeeper.status.text = "FULLY PAID!"
		player.trigger_temp_passive("jar_o_savings","FULLY PAID")
	
	if shopkeeper.has_scroll_turn:
		player.trigger_temp_passive("merchant_scroll","KEEPER'S SCROLL")
	await shopkeeper.start_keeper_turn()
	shopkeeper.has_keeper_turn = false
	main.shopkeeper.max_playable_coins += 2
	if player.has_active_income:
		if player.debt > 0:
			shopkeeper.status.text = "SETTLE YOUR DEBT."
		else:
			shopkeeper.status.text = "NO DEBT YET."
	else:
		shopkeeper.status.text = "CASTER ARE YOU ALRIGHT?"
	if enemy.coin > 0:
		await get_tree().create_timer(0.6, true).timeout
		if shopkeeper.has_scroll_turn:
			shopkeeper.has_scroll_turn = false
			start_player_turn()
		else:
			start_enemy_turn()
	else:
		check_defeat()
		
func start_enemy_turn():
	if enemy.coin > 0:
		current_turn = Turn.ENEMY
		show_turn_ui("ENEMY TURN")
		coin_deck.reset_sigils()
		sound_manager.play_sound(TURN_ENEMY)
		if main.player.has_loan_shark and enemy.debt > 0:
			if player.has_pay_down:
				loan_shark.self_modulate = Color.BLACK
			else:
				loan_shark.self_modulate = Color.WHITE
			sound_manager.play_sound(PASSIVE_JAR_O_SAVINGS)
			particle_manager.spawn_particle(DEBT_EFFECT_PARTICLE,loan_enter.global_position)
			particle_manager.spawn_particle(DEBT_DAMAGE_PARTICLE,loan_enter.global_position)
			particle_manager.spawn_particle(DEBT_EFFECT_PARTICLE,loan_enter.global_position)
			particle_manager.spawn_particle(DEBT_DAMAGE_PARTICLE,loan_enter.global_position)
			loan_shark.play("default")
		await enemy.start_enemy_turn()
		if enemy.coin > 0:
			await get_tree().create_timer(1.0, true).timeout
			enemy.passive_income.visible = false
			if is_game_over:
				return
			if player.coin > 0:
				if !player.has_extra_turn:
					if player.has_merchant_scroll and shopkeeper.has_scroll_turn:
						start_keeper_turn()
					else:
						start_player_turn()
				else:
					sound_manager.play_sound(EXTRA_TURN)
					current_turn = Turn.PLAYER
					show_turn_ui("CASH OUT")
					current_turn = Turn.ENEMY
					player.extra_turn()
			else:
				check_defeat()
		else:
			check_defeat()

func _on_endturn_pressed():
	endTurn_button.mouse_default_cursor_shape = 8
	flip_button.mouse_default_cursor_shape = 8
	reserve_button.mouse_default_cursor_shape = 8
	re_flip_button.mouse_default_cursor_shape = 8
	
	if is_instance_valid(enemy_info_menu):
		return
	if is_instance_valid(player_info_menu):
		return
	enemy_info.visible = false
	player_info.visible = false
	keeper_info.visible = false
	if enemy.coin > 0 and player.coin > 0:
		await player.end_turn()
		turn_calculation_box.exit()
		var defeat = await check_defeat()
		if defeat == null:
			await get_tree().create_timer(1.0, true).timeout
			if !player.has_extra_turn:
				if current_turn == Turn.ENEMY:
					if shopkeeper.has_scroll_turn:
						start_keeper_turn()
					else:
						start_player_turn()
				else:
					if player.has_active_income and shopkeeper.has_keeper_turn:
						start_keeper_turn()
					else:
						start_enemy_turn()
			else:
				sound_manager.play_sound(EXTRA_TURN)
				show_turn_ui("CASH OUT")
				player.extra_turn()

func tally_end_turn():
	enemy_info.visible = false
	player_info.visible = false
	keeper_info.visible = false
	if enemy.coin > 0 and player.coin > 0:
		current_turn = Turn.ENEMY
		show_turn_ui("TURN ENDED")
		await player.end_turn()
		turn_calculation_box.exit()
		var defeat = await check_defeat()
		if defeat == null:
			await get_tree().create_timer(1.0, true).timeout
			if !player.has_extra_turn:
				start_enemy_turn()
			else:
				sound_manager.play_sound(EXTRA_TURN)
				show_turn_ui("CASH OUT")
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
	
	var tween_in = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	tween_in.parallel().tween_property(notif, "position:x", 0, 0.3)
	tween_in.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.3)
	
	for i in range(passive_label.get_child_count()):
		var child = passive_label.get_child(i)
		if child != notif:
			child.position.y += 30
			
		await get_tree().create_timer(duration, true).timeout
	
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

	
	enemy_notif_tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
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
	total_flips += 1
	player.flip()
	
func trigger_game_over(player_won: bool):
	if is_game_over:
		return
	is_game_over = true
	PauseManager.pause()
	run_timer_active = false
	timer_label.visible = false
	pause_menu.visible = false
	turn_calculation_box.visible = false
	sound_manager.play_sound(DEATH)
	sound_manager.stop_music()
	
	player.toggle_button(flip_button,true)
	player.toggle_button(re_flip_button,true)
	player.toggle_button(endTurn_button,true)
	player.toggle_button(reserve_button,true)
	player_info.visible = false
	enemy_info.visible = false
	endTurn_button.visible = false
	flip_button.disabled = true
	re_flip_button.disabled = true
	reserve_button.disabled = true
	endTurn_button.disabled = false
	endTurn_button.mouse_default_cursor_shape = 0
	flip_button.mouse_default_cursor_shape = 0
	reserve_button.mouse_default_cursor_shape = 0
	re_flip_button.mouse_default_cursor_shape = 0
	
	if player_won:
		enemy.max_playable_coins = 0
		if current_enemy_index != 8:
			reward_manager.show_rewards()
	
	flip_button.disabled = true
	re_flip_button.disabled = true
	endTurn_button.disabled = true
	
	set_process(false)

	var stats = {
	"remaining_coins": player.coin,
	"overall_total_damage": overall_total_damage,
	"highest_damage_dealt": highest_damage_dealt,
	"overall_total_gain": overall_total_gain,
	"highest_gain": highest_gain,
	"enemies_defeated": enemies_defeated,
	"heads": total_heads,
	"tails": total_tails,
	"flips": total_flips,
	"reflips": total_reflips,
	"total_reserved_coins": overall_reserved_coins,
	"total_debt_applied": total_debt_applied,     
	"highest_debt_applied": highest_debt_applied,
	"run_time": run_timer,
	"played_turns": played_turns,
	"total_damage_taken": total_damage_taken
}
	#game_over_ui.show_stats(stats)
	#game_over_ui.visible = true
	
	var collected_passives = passive_order 
	var title_text = ""
	var killer_text = ""
	match current_enemy_type:
		Enemy.MAGE:
			title_text = "RUN ABANDONED" if is_surrender else "CONSUMED BY MAGIC"
			killer_text = "You gave up the fight..." if is_surrender else "Mage Wins"
		Enemy.DWARF:
			title_text = "RUN ABANDONED" if is_surrender else "CRUSHED BY THE FORGE"
			killer_text = "You gave up the fight..." if is_surrender else "Dwarf Wins"
		Enemy.COLLECTOR:
			title_text = "RUN ABANDONED" if is_surrender else "ADDED TO THE COLLECTION"
			killer_text = "You gave up the fight..." if is_surrender else "Collector Wins"
		Enemy.TRADER:
			title_text = "RUN ABANDONED" if is_surrender else "A BAD DEAL"
			killer_text = "You gave up the fight..." if is_surrender else "Trader Wins"
		Enemy.THRIFTER:
			title_text = "RUN ABANDONED" if is_surrender else "SPENT TO NOTHING"
			killer_text = "You gave up the fight..." if is_surrender else "Thrifter Wins"
		Enemy.ARISTOCRAT:
			title_text = "RUN ABANDONED" if is_surrender else "BENEATH THEIR CLASS"
			killer_text = "You gave up the fight..." if is_surrender else "Aristocrat Wins"
		Enemy.SUN_CASTER:
			title_text = "RUN ABANDONED" if is_surrender else "SCORCHED BY DAWN"
			killer_text = "You gave up the fight..." if is_surrender else "Sun Caster Wins"
		Enemy.MOON_CASTER:
			title_text = "RUN ABANDONED" if is_surrender else "CONSUMED BY DUSK"
			killer_text = "You gave up the fight..." if is_surrender else "Moon Caster Wins"
		Enemy.TWILIGHT_SAGE:
			if is_surrender:
				title_text = "RUN ABANDONED"
				killer_text = "You gave up the fight..."
			elif player_won:
				title_text = "YOU WIN"
				killer_text = "Twilight Sage has been slain"
			else:
				title_text = "LOST IN TWILIGHT"
				killer_text = "Twilight Sage Wins"
		_:
				title_text = "RUN ABANDONED"
				killer_text = "Your fear of the upcoming journey is inevitable."

	is_surrender = false
	
	vignetter.range_z_max = 99
	turn_spell_light.range_z_max = 99
	
	var game_over_instance = POST_GAME_SCREEN.instantiate()
	game_over_instance.z_index = 100 
	add_child(game_over_instance)
	
	await get_tree().create_timer(1.0, true).timeout
	sound_manager.play_sound(GAME_OVER_WALL)
	if !player_won:
		game_over_instance.is_game_over = true
	game_over_instance.setup(stats, player_won, title_text, killer_text, player)
	await get_tree().create_timer(1.4, true).timeout
	sound_manager.play_sound(DAMAGE_MODERATE)
	await get_tree().create_timer(1.0, true).timeout
	boss_defeat_transition.visible = false
	
func check_defeat():
	if player.coin <= 0:
		if player.has_payback:
			if player.payback_used:
				await trigger_dramatic_slowdown()
				trigger_game_over(false)
		else:
			await trigger_dramatic_slowdown()
			trigger_game_over(false)
		return true
		
	if enemy.coin <= 0:
		flip_button.disabled = true
		endTurn_button.disabled = true 
		re_flip_button.disabled = true
		reserve_button.disabled = true
		if enemies_defeated == current_room or enemy.type == Enemy.TWILIGHT_SAGE:
			enemies_defeated += 1
			if enemy.type == Enemy.TWILIGHT_SAGE:
				await boss_dramatic_slowdown()
			else:
				await trigger_dramatic_slowdown()
			await handle_victory_flow()
			return true
	
	return null

func handle_victory_flow():
	PauseManager.pause()
	mist_particles.emitting = false
	endTurn_button.disabled = true
	player.lock = false
	player.slow = false
	var has_dazzle = false
	var main_coins = get_tree().get_nodes_in_group("coins")
	var coins = get_tree().get_nodes_in_group("reserved coins")
	player.current_reserve = coins.size()
	player.max_reserve = player.initial_max_reserve
	switch_vignetter_color(vignetter_default,1.0)
	switch_vignette_color(vignette_default,1.0)
	player.gain_coin()
	sound_manager.play_sound(VICTORY)
	turn_calculation_box.exit()
	current_turn = Turn.PLAYER
	await show_turn_ui("VICTORY")
	sound_manager.play_sound(PASSIVE_SPARE_CHANGE)
	var reserved_coins = get_tree().get_nodes_in_group("reserved coins")
	
	for c in reserved_coins:
		player.coin += 1
		overall_reserved_coins += 1
		c.queue_free()
		player.current_reserve -= 1
	if main_coins.size() > 0:
		for c in main_coins:
			player.coin += 1
			c.queue_free()
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
	
	player.coin += enemy.bounty
	await progression_after_victory()
	
	
func progression_after_victory():
	player.refresh_start_of_battle_stats()
	if player.has_merchant_scroll or player.has_fully_paid:
		shopkeeper.combat_won += 1
		if shopkeeper.combat_won == 3:
			shopkeeper.trust += 1
		shopkeeper.refresh_start_of_battle_stats()

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
		await _play_progression_cutscene(current_room - 1, current_room)
		if current_room == 4:
			sound_manager.play_music(SHOP)
			await shop_manager.show_shop_async(player)
			current_room += 1
			sound_manager.stop_music()
			await _play_progression_cutscene(current_room - 1, current_room)
			proceed_to_next_enemy()
		else:
			proceed_to_next_enemy()
		
func _on_re_flip_pressed():
	total_reflips += 1
	player.re_flip()
	if main.enemy.coin == 0:
		main.check_defeat()
	reflip_label.text = str(player.max_re_flip - player.current_re_flip)

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
		var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
		sound_manager.play_sound(COIN_FLIP)
		var c = COIN.instantiate()
		c.setup(0,main.coin_deck.get_reserve_slot())
		c.copy_coin(left_coin)
		c.add_to_group("reserved coins")
		player.add_child(c)
		left_coin.queue_free()
		coins = get_tree().get_nodes_in_group("reserved coins")
		player.current_reserve = coins.size()

func update_player_coin():
	player_health_label.text = str(player.coin)
	if player.has_active_income or player.has_merchant_scroll:
		keeper_health_label.text = str(shopkeeper.coin)
	
func update_player_status():
	if player.starstruck:
		dazzled_effect.visible = true
	else:
		dazzled_effect.visible = false
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
		if !main.player.has_inflation:
			reserve_button.visible = true
		else:
			reserve_button.visible = false
		player_lock.visible = false
		player_lock_particles.emitting = false
		player_reserve.text = "Reserve:\n" + str(player.current_reserve) + "/" + str(player.max_reserve)
	
func update_enemy_coin():
	enemy_health_label.text = str(enemy.coin)
	
func update_player_stacks():
	player_tally.visible = false
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
	if player.tally_counter != 0:
		player_tally_count.text = str(player.tally_counter)
		tally_flip_count.text = str(player.tally_counter)
		player_tally.visible = true
	
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
	await get_tree().create_timer(0.2, true).timeout
	get_tree().reload_current_scene()
	

func proceed_to_next_enemy():
	match enemies_defeated:
		1:
			current_enemy_index = randi_range(2,3)
			second_enemy = current_enemy_index
		2:
			current_enemy_index = randi_range(4,5)
			third_enemy = current_enemy_index
		3:
			if second_enemy == 2 and third_enemy == 5:
				current_enemy_index = 6
			elif second_enemy == 3 and third_enemy == 4:
				current_enemy_index = 7
			else:
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
	
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	tween.tween_property(fake_coin, "global_position", target_pos, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(fake_coin, "scale", Vector2(0.6, 0.6), 0.4)
	
	tween.finished.connect(fake_coin.queue_free)


func _on_re_flip_mouse_entered() -> void:
	if !re_flip_button.disabled:
		reflip_sprite.play("default")


func _on_re_flip_mouse_exited() -> void:
	reflip_sprite.pause()

func _play_progression_cutscene(from_index: int, to_index: int) -> void:
	PauseManager.pause()
	var screen_height = get_viewport_rect().size.y 
	
	progression_map.offset.y = -screen_height 
	progression_map.visible = true
	
	var slide_in = progression_map.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	slide_in.tween_property(progression_map, "offset:y", 0.0, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	slide_in.tween_interval(0.3)

	await slide_in.finished
	
	var walk_tween = progression_map.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	
	var distance = player_sprite.global_position.distance_to(map_markers[to_index].global_position)
	var walk_duration = distance / 80.0 
	
	walk_tween.tween_property(player_sprite, "global_position", map_markers[to_index].global_position, walk_duration).set_trans(Tween.TRANS_LINEAR)
	await walk_tween.finished

	var dramatic_pause = progression_map.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	dramatic_pause.tween_interval(1.0)
	await dramatic_pause.finished
	sound_manager.stop_music()
	sound_manager.play_sound(PASSIVE_PASSIVE_INCOME)
	var bg_fade = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	if to_index == 2:
		fields_area.visible = true
		bg_fade.tween_property(forest_area,"modulate", Color("#0059a800"),0.6)
		await bg_fade.finished
		forest_area.visible = false
		dusk_particles.emitting = false
		dawn_particles.emitting = true
		mist_particles.emitting = true
	elif to_index == 4:
		shop_area.visible = true
		bg_fade.tween_property(fields_area,"modulate", Color("#0059a800"),0.6)
		await bg_fade.finished
		fields_area.visible = false
		dawn_particles.emitting = false
	elif to_index == 5:
		bg_fade.tween_property(shop_area,"modulate", Color("#0059a800"),0.6)
		await bg_fade.finished
		shop_area.visible = false
	
	var slide_out = progression_map.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	slide_out.tween_property(progression_map, "offset:y", -screen_height, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	await slide_out.finished

	progression_map.visible = false



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
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	tween.parallel().tween_property(notif, "position:x", 0, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(notif, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.2)
	await tween.finished
	
	# Wait duration
	await get_tree().create_timer(duration, true).timeout
	
	# Fade out
	var tween_out = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
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
	
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	
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
		
	if player.has_pocket_money:
		trigger_passive("pocket_money", "POCKET MONEY")
		
	if player.has_inflation:
		trigger_passive("inflation", "INFLATION")
		
	if player.has_lending_charge:
		trigger_passive("lending_charge", "LENDING CHARGE")

	if player.has_deposit:
		trigger_passive("deposit", "DEPOSIT")



		
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
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
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

func _on_player_info_toggled(toggled_on: bool) -> void:
	print("toggled: ", toggled_on)
	if toggled_on:
		sound_manager.play_sound(SCROLL_OPEN)
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
	else:
		if player_info_menu != null and is_instance_valid(player_info_menu):
			player_info_menu.close()
			player_info_menu = null
			player_info.button_pressed = false

func _on_enemy_info_toggled(toggled_on: bool) -> void:
	print("toggled: ", toggled_on)
	if toggled_on:
		sound_manager.play_sound(SCROLL_OPEN)
		enemy_info_menu = ENEMY_INFORMATION_DISPLAY.instantiate()
		add_child(enemy_info_menu)
		enemy_info_menu.setup(enemy)
		
		await get_tree().process_frame
		var screen_size = get_viewport_rect().size
		var menu_size = enemy_info_menu.size
		enemy_info_menu.global_position = Vector2((screen_size.x - menu_size.x) / 2,
			(screen_size.y - menu_size.y) / 2)
		enemy_info_menu.z_index = 100
		enemy_info_menu.open()
	else:
		if enemy_info_menu != null and is_instance_valid(enemy_info_menu):
			enemy_info_menu.close()
			enemy_info_menu = null
			enemy_info.button_pressed = false

func _on_reserve_button_pressed() -> void:
	player.reserve()
	if player.current_reserve >= player.max_reserve:
		reserve_button.disabled = true
	else:
		reserve_button.disabled = false
		
	
func trigger_dramatic_slowdown() -> void:
	sound_manager.play_sound(SLOW)
	Engine.time_scale = 0.3 
	await get_tree().create_timer(1.0, true, false, true).timeout 
	Engine.time_scale = 1.0

func boss_dramatic_slowdown() -> void:
	is_boss_defeated = true
	player.toggle_button(flip_button,true)
	player.toggle_button(re_flip_button,true)
	player.toggle_button(endTurn_button,true)
	player.toggle_button(reserve_button,true)
	player_info.visible = false
	enemy_info.visible = false
	endTurn_button.visible = false
	flip_button.disabled = true
	re_flip_button.disabled = true
	reserve_button.disabled = true
	endTurn_button.disabled = false
	endTurn_button.mouse_default_cursor_shape = 8
	flip_button.mouse_default_cursor_shape = 8
	reserve_button.mouse_default_cursor_shape = 8
	re_flip_button.mouse_default_cursor_shape = 8
	camera_2d.add_trauma(4.0)
	sound_manager.play_sound(SLOW)
	sound_manager.play_sound(VOIDED)
	sound_manager.stop_music()
	Engine.time_scale = 0.1
	await get_tree().create_timer(1.0, true, false, true).timeout 
	Engine.time_scale = 1.0
	sound_manager.play_sound(BOSS_DEFEATED)
	boss_defeat_transition.self_modulate = Color("#ffffff00")
	boss_defeat_transition.visible = true
	boss_defeat_transition.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in range(20):
		sound_manager.play_sound(CRITICAL)
		particle_manager.spawn_particle(SPEND_EXPLOSION_PARTICLE,enemy_portrait.global_position)
		particle_manager.spawn_particle(GAIN_EFFECT_PARTICLE,Vector2(randi_range(0,1000),randi_range(0,1000)))
		particle_manager.spawn_particle(DEBT_DAMAGE_PARTICLE,Vector2(randi_range(0,1000),randi_range(0,1000)))
		particle_manager.spawn_particle(SPEND_DAMAGE_PARTICLE,Vector2(randi_range(0,1000),randi_range(0,1000)))
		particle_manager.spawn_particle(INFLATION_PARTICLE,Vector2(randi_range(0,1000),randi_range(0,1000)))
		particle_manager.spawn_particle(COIN_BARRAGE_PARTICLE,enemy_portrait.global_position)
		await get_tree().create_timer(0.2, true).timeout
		camera_2d.add_trauma(2.0)
	Engine.time_scale = 0.3 
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	tween.tween_property(boss_defeat_transition,"self_modulate",Color.WHITE,2)
	await get_tree().create_timer(3.0, true, false, true).timeout 
	Engine.time_scale = 1.0



func _on_player_info_passive_screen_toggled(toggled_on: bool) -> void:
	print("toggled: ", toggled_on)
	if toggled_on:
		sound_manager.play_sound(SCROLL_OPEN)
		player_info_menu = PLAYER_INFORMATION_DISPLAY.instantiate()
		card_manager.add_child(player_info_menu)
		player_info_menu.setup(player)
		
		await get_tree().process_frame
		var screen_size = get_viewport_rect().size
		var menu_size = player_info_menu.size
		player_info_menu.global_position = Vector2((screen_size.x - menu_size.x) / 2,
			(screen_size.y - menu_size.y) / 2)
		player_info_menu.z_index = 100
		player_info_menu.open()
	else:
		if player_info_menu != null and is_instance_valid(player_info_menu):
			player_info_menu.close()
			player_info_menu = null
			player_info.button_pressed = false


func _on_player_info_shop_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		sound_manager.play_sound(SCROLL_OPEN)
		player_info_menu = PLAYER_INFORMATION_DISPLAY.instantiate()
		shop_manager.add_child(player_info_menu)
		player_info_menu.setup(player)
		
		await get_tree().process_frame
		var screen_size = get_viewport_rect().size
		var menu_size = player_info_menu.size
		player_info_menu.global_position = Vector2((screen_size.x - menu_size.x) / 2,
			(screen_size.y - menu_size.y) / 2)
		player_info_menu.z_index = 100
		player_info_menu.open()
	else:
		if player_info_menu != null and is_instance_valid(player_info_menu):
			player_info_menu.close()
			player_info_menu = null
			player_info.button_pressed = false


func _on_keeper_info_toggled(toggled_on: bool) -> void:
	if toggled_on:
		sound_manager.play_sound(SCROLL_OPEN)
		keeper_info_menu = KEEPER_INFORMATION_DISPLAY.instantiate()
		add_child(keeper_info_menu)
		keeper_info_menu.setup(shopkeeper,player)
		
		await get_tree().process_frame
		var screen_size = get_viewport_rect().size
		var menu_size = keeper_info_menu.size
		keeper_info_menu.global_position = Vector2((screen_size.x - menu_size.x) / 2,
			(screen_size.y - menu_size.y) / 2)
		keeper_info_menu.z_index = 100
		keeper_info_menu.open()
	else:
		if keeper_info_menu != null and is_instance_valid(keeper_info_menu):
			keeper_info_menu.close()
			player_info_menu = null
			keeper_info.button_pressed = false


func _on_loan_shark_animation_finished() -> void:
	particle_manager.spawn_particle(DEBT_EFFECT_PARTICLE,loan_splash.global_position)
	particle_manager.spawn_particle(DEBT_DAMAGE_PARTICLE,loan_splash.global_position)
	particle_manager.spawn_particle(DEBT_EFFECT_PARTICLE,loan_splash.global_position)
	particle_manager.spawn_particle(DEBT_DAMAGE_PARTICLE,loan_splash.global_position)
			

func spin_reserve_rug(duration_per_spin: float) -> void:
	var tween = create_tween().set_loops()
	
	tween.tween_property(reserve_outside_texture, "rotation_degrees", 360.0, duration_per_spin)\
		.as_relative()\
		.set_trans(Tween.TRANS_LINEAR)


func _on_start_journey_pressed() -> void:
	var screen_height = get_viewport_rect().size.y 
	sound_manager.stop_music()
	sound_manager.play_sound(PASSIVE_PASSIVE_INCOME)
	var dramatic_pause = start_run.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	dramatic_pause.tween_interval(1.0)
	await dramatic_pause.finished

	
	var slide_out = progression_map.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_BOUND)
	slide_out.tween_property(start_run, "offset:y", -screen_height, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	await slide_out.finished

	progression_map.visible = false
	battle_start()
	
