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
@onready var player = $Player
@onready var enemy = $Enemy

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
const COIN_GAIN = preload("uid://c3v64vs2uqtik")
const COIN_REFLIP = preload("uid://qtxsmuntihe3")
const DAMAGE_HEAVY = preload("uid://b8us2t16pmggo")
const DAMAGE_LIGHT = preload("uid://ds0jngoq17iij")
const DAMAGE_MODERATE = preload("uid://b2rf2iy046cx2")
const TURN_ENEMY = preload("uid://rncriov1quyx")
const TURN_PLAYER = preload("uid://dk7433d32rg52")
const TURN_REVEAL = preload("uid://boyjppal62qns")

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



#@onready var player_portrait: ColorRect = $Player/Player_Portrait
#@onready var enemy_portrait: ColorRect = $Enemy/Enemy_Portrait
@onready var enemy_portrait = $Enemy/Enemy_Portrait
@onready var enemy_portrait_sprite: AnimatedSprite2D = $Enemy/Enemy_Portrait/Enemy_Portrait_Sprite
@onready var player_portrait: AnimatedSprite2D = $Player/Player_Portrait

# --- PROGRESSION MAP ---
@onready var progression_map: CanvasLayer = $"Progression Map"
@onready var player_sprite: AnimatedSprite2D = $"Progression Map/Player_Sprite"
@onready var banner: TextureRect = $"Progression Map/MapBackground/Banner"

# Put your markers in the exact order they should be visited
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
@onready var turn_calculation: Label = $"Battle UI/Turn Calculation"

@onready var player_health_bar = $"Battle UI/PlayerHealthBar2"
@onready var player_gain: Label = $"Player/Player Gain"
@onready var player_debt: Label = $"Player/Player Debt"
@onready var player_health_label = $"Battle UI/HealthLabel"

@onready var enemy_health_bar = $"Battle UI/EnemyHealthBar"
@onready var enemy_health_label: Label = $"Battle UI/EnemyHealthLabel"
@onready var enemy_gain: Label = $"Enemy/Enemy Gain"
@onready var enemy_debt: Label = $"Enemy/Enemy Debt"

@onready var turn_ui: ColorRect = $"Battle UI/Turn UI"
@onready var turn_ui_label: Label = $"Battle UI/Turn UI/Turn UI Label"

@onready var passive_manager = $PassiveManager
@onready var passive_label = $"Battle UI/PassiveContainer"
@onready var enemy_passive_label = $"Battle UI/CenterContainer/Background/EnemyLabelNotification"
@onready var enemy_passive_bg = $"Battle UI/CenterContainer/Background"

var active_passive_notifs: Dictionary = {}
var active_temp_notifs: Array = []
var recent_triggers: Dictionary = {}
var active_temp_ids: Dictionary = {}
var passive_order: Array = []
var max_visible_passives = 2
var overflow_notif: Control = null

var enemy_notif_tween: Tween = null
var enemy_notif_base_pos: Vector2

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

#Random Events Selection Scene
var event_maps = [
   # preload("res://Events/###.tscn"),
   # preload("res://Events/###.tscn"),
   # preload("res://Events/###.tscn")
]


var current_enemy_index
var current_room
@onready var shop_manager: CanvasLayer = $ShopManager

func _on_item_purchased(card_id,price):
	update_player_coin()
	if shop_manager.visible:
		shop_manager.coin_label.text = "Coins: " + str(player.coin)
	


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.4).timeout
	await _play_fake_coin_intro()
	turn_ui.visible = false
	current_room = 0
	current_enemy_index = randi_range(0,1)
	passive_manager.setup(self)
	player.setup(self)
	game_over_ui.visible = false
	pause_menu.visible = false
	turn_ui.visible = false
	print(reward_manager)
	player.reset_stats()
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
	
func battle_start():
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
	update_enemy_gain_debt()
	update_player_gain_debt()
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
		1: 
			enemy.setup(self,Enemy.DWARF)
			enemy_portrait_sprite.play("DWARF")
		2: 
			enemy.setup(self,Enemy.COLLECTOR)
			enemy_portrait_sprite.play("COLLECTOR")
		3: 
			enemy.setup(self,Enemy.TRADER)
			enemy_portrait_sprite.play("TRADER")
		4: 
			enemy.setup(self,Enemy.THRIFTER)
			enemy_portrait_sprite.play("THRIFTER")
		5:
			enemy.setup(self,Enemy.ARISTOCRAT)
			enemy_portrait_sprite.play("ARISTOCRAT")
		6: 
			enemy.setup(self,Enemy.SUN_CASTER)
			enemy_portrait_sprite.play("SUN_CASTER")
		7: 
			enemy.setup(self,Enemy.MOON_CASTER)
			enemy_portrait_sprite.play("MOON_CASTER")
		8:
			enemy.setup(self,Enemy.TWILIGHT_SAGE)
			enemy_portrait_sprite.play("TWILIGHT_SAGE_DUSK")

	
	update_enemy_coin()
	update_player_coin()
	flip_button.disabled = false
	
	#Battle Start Passives
	player.activate_pre_battle_passives()
	player.player_turn_count = 0
	start_player_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_player_coin()
	update_enemy_coin()
	update_player_gain_debt()
	update_enemy_gain_debt()

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
	turn_ui.visible = false
	
func _on_end_run_pressed():
	print("Main Script: Received End Run")
	get_tree().paused = false
	pause_menu.visible = false
	trigger_game_over(false)
	
func start_player_turn():
	show_turn_ui("PLAYER TURN")
	coin_deck.reset_sigils()
	current_turn = Turn.PLAYER
	sound_manager.play_sound(TURN_PLAYER)
	player.start_turn()
			
func start_enemy_turn():
	check_defeat()
	if enemy.coin > 0:
		show_turn_ui("ENEMY'S TURN")
		coin_deck.reset_sigils()
		current_turn = Turn.ENEMY
		sound_manager.play_sound(TURN_ENEMY)
		await enemy.start_enemy_turn()
		start_player_turn()


func _on_endturn_pressed():
	await player.end_turn()
	var defeat = await check_defeat()
	if defeat == null:
		await get_tree().create_timer(1.0).timeout
		if !player.has_extra_turn:
			start_enemy_turn()
			player.extra_turn_penalty = 1
		else:
			player.extra_turn()
			player.has_extra_turn = false

func show_passive_notification(text: String, duration: float = 1.5) -> TextureRect:
	var notif: TextureRect = PASSIVE_SCENE.instantiate()
	passive_label.add_child(notif)
	
	notif.setup(text)#1
	notif.modulate.a = 0.0
	notif.scale = Vector2(0.9, 0.9)
	notif.z_index = 100
	
	var container_width = passive_label.size.x
	notif.position = Vector2(container_width + 200, 0)
	
	# Slide in and scale in
	var tween = create_tween()
	tween.parallel().tween_property(notif, "position:x", 0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(notif, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.3)
	await tween.finished
	
	# Wait for duration
	await get_tree().create_timer(duration).timeout
	
	# Fade out and queue free
	var tween_out = create_tween()
	tween_out.tween_property(notif, "modulate:a", 0.0, 0.4)
	tween_out.tween_callback(func():
		notif.queue_free()
	)
	
	return notif
	
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

	
	
func trigger_game_over(player_won: bool):
	sound_manager.play_sound(DEATH)
	if player_won:
		enemy.max_playable_coins = 0
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
	
	var is_surrender
	
	match current_enemy_type:
		Enemy.MAGE:
			if player_won:
				result_label.text = "ARCANE FALLEN"
				enemy_label.text = "Mage has been slain"
			else:
				result_label.text = "CONSUMED BY MAGIC"
				enemy_label.text = "Mage Wins"
			
			
		Enemy.DWARF:
			if player_won:
				result_label.text = "THE FORGE BREAKS"
				enemy_label.text = "Dwarf has been slain"
			else:
				result_label.text = "CRUSHED BY THE FORGE"
				enemy_label.text = "Dwarf Wins"
				
	enemy_label.modulate.a = 0.0
	
	await get_tree().create_timer(1.0).timeout
	
			
	var tween = create_tween()
	tween.tween_property(enemy_label, "modulate:a", 1.0, 1.0)
	
	if is_surrender:
		result_label.text = "RUN ABANDONED"
		enemy_label.text = "You gave up the fight..."

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
	await show_turn_ui("VICTORY")
	
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
		await reward_manager.show_card_selection_async()
		current_room += 1
		if current_room == 4:
			await shop_manager.show_shop_async(player)
			current_room += 1
			#map.background.global_position.y = 1000
			#add_child(map)
			#tween = create_tween()
			#tween.tween_property(map,"position:y",0,0.4)
		_play_progression_cutscene(current_room - 1, current_room)
		proceed_to_next_enemy()
		show_turn_ui("BATTLE START")
		
func _on_re_flip_pressed():
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

func update_player_coin():
	player_health_label.text = "Coins: " + str(player.coin)
	
func update_enemy_coin():
	enemy_health_label.text = "Coins: " + str(enemy.coin)
	
func update_player_gain_debt():
	player_gain.text = ""
	player_debt.text = ""
	if player.gain != 0:
		player_gain.text = "GAIN: " + str(player.gain)
	if player.debt != 0:
		player_debt.text = "DEBT: " + str(player.debt)
	
func update_enemy_gain_debt():
	enemy_gain.text = ""
	enemy_debt.text = ""
	if enemy.gain != 0:
		enemy_gain.text = "GAIN: " + str(enemy.gain)
	if enemy.debt != 0:
		enemy_debt.text = "DEBT: " + str(enemy.debt)

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
	var walk_duration = distance / 150.0 
	
	walk_tween.tween_property(player_sprite, "global_position", map_markers[to_index].global_position, walk_duration).set_trans(Tween.TRANS_LINEAR)
	await walk_tween.finished

	var dramatic_pause = progression_map.create_tween()
	dramatic_pause.tween_interval(3.0)
	await dramatic_pause.finished
	
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
	notif.position = Vector2(container_width + 200, 0)
	
	# Slide in and fade in
	var tween = create_tween()
	tween.parallel().tween_property(notif, "position:x", 0, 0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(notif, "modulate:a", 1.0, 0.35)
	tween.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.35)
	await tween.finished
	
	# Wait duration
	await get_tree().create_timer(duration).timeout
	
	# Fade out
	var tween_out = create_tween()
	tween_out.tween_property(notif, "modulate:a", 0.0, 0.4)
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
			tween.parallel().tween_property(notif, "position:y", target_y, 0.25)
			tween.parallel().tween_property(notif, "modulate:a", 1.0, 0.25)
			tween.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.25)
		
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
		tween.parallel().tween_property(overflow_notif, "position:y", target_y, 0.25)
		tween.parallel().tween_property(overflow_notif, "modulate:a", 0.6, 0.25)
		tween.parallel().tween_property(overflow_notif, "scale", Vector2(0.85, 0.85), 0.25)
	
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
		trigger_passive("wishbone", "WISH BONE ACTIVE")
		
	if player.has_golden_clover:
		trigger_passive("golden_clover", "GOLDEN CLOVER ACTIVE")
		
	if player.has_sleight_of_hand:
		trigger_passive("sleight_of_hand", "SLEIGHT OF HAND ACTIVE")
		
	if player.has_pocket_money:
		trigger_passive("pocket_money", "POCKET MONEY ACTIVE")
		
	if player.has_passive_income:
		trigger_passive("passive_income", "PASSIVE INCOME ACTIVE")
		
	if player.has_lending_charge:
		trigger_passive("lending_charge", "LENDING CHARGE ACTIVE")
		
	if player.has_reimbursement:
		trigger_passive("reimbursement", "REIMBURSEMENT ACTIVE")

	# --- SHOP PASSIVE (PERSISTENT) ---
	if player.has_merchant_scroll:
		trigger_passive("merchant_scroll", "MERCHANT SCROLL ACTIVE")


		
enum PassiveDisplayType {
	PERSISTENT,
	TEMPORARY
}

var passive_display_type = {
	# --- PERSISTENT ---
	"wishbone": PassiveDisplayType.PERSISTENT,
	"golden_clover": PassiveDisplayType.PERSISTENT,
	"deposit": PassiveDisplayType.PERSISTENT,
	"sleight_of_hand": PassiveDisplayType.PERSISTENT,
	"pocket_money": PassiveDisplayType.PERSISTENT,
	"passive_income": PassiveDisplayType.PERSISTENT,
	"lending_charge": PassiveDisplayType.PERSISTENT,
	"reimbursement": PassiveDisplayType.PERSISTENT,
	"merchant_scroll": PassiveDisplayType.PERSISTENT,

	# --- TEMPORARY ---
	"piggy": PassiveDisplayType.TEMPORARY,
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
			_show_temporary_passive(id, text, 1.5)
			
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
	tween.parallel().tween_property(notif, "position:x", 0, 0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(notif, "modulate:a", 1.0, 0.35)
	tween.parallel().tween_property(notif, "scale", Vector2(1, 1), 0.35)
	
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
