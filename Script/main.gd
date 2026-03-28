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
const COIN_ADD_PARTICLE = preload("uid://s6va71jul34t")
const COIN_PLAY_PARTICLE = preload("uid://w5jgphq268vx")
const DAMAGE_PARTICLE = preload("uid://q4hytnmn2fbt")
const SINGLE_DAMAGE_PARTICLE = preload("uid://dgeahqxig4fqa")

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
@onready var player_portrait: TextureRect = $Player/Player_Portrait

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
@onready var enemy_passive_label = $"Battle UI/EnemyLabelNotification"


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


#PASSIVES

#Passive Specific Variables
var flip_clicks = 0
var latest_coin = null
var coin_count = 0
var latest_pair_left_coin = null
var latest_pair_right_coin = null
var payback_used = false
var payback_coins = 10
var passive_income_used = false
var pocket_money_coins = 6
var previous_player_gain = 0

var previous_player_flips = 0
var player_turn_count = 0
var sun_count = 0
var moon_count = 0

var coins_array: Array = []

#GENERAL PASSIVES

#B-Rank
@export var has_wishbone = false
@export var has_golden_clover = false
@export var has_solar_coin = false
@export var has_lunar_coin = false
@export var has_merchant_scroll = false
@export var has_impromptu_flip = false
@export var has_advanced_planning = false

#A-Rank
@export var has_magic_trick = false
@export var has_sleight_of_hand = false
@export var has_piggy = false

#INNOVATOR PASSIVES

@export var has_inflation = false
@export var has_payback = false
@export var has_lucky_pair = false
@export var has_value_increase = false

#SHOOTER PASSIVES

@export var has_spare_change = false
@export var has_triple_nickel = false
@export var has_refund = false
@export var has_coin_snipe = false

#INVESTOR PASSIVES

@export var has_active_income = false
@export var has_pocket_money = false
@export var has_passive_income = false
@export var has_simple_interest = false

#DEBTOR PASSIVES

@export var has_pay_down = false
@export var has_reimbursement = false
@export var has_loan_shark = false
@export var has_lending_charge = false

#ENEMY PASSIVES

var has_value_added_tax = false
var has_fair_trade = false
var has_learn_to_save = false
var has_fully_paid = false
var has_sunlit_curse = false
var has_midnight_curse = false
var has_dusk_stance = false

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
	
	current_room = 0
	current_enemy_index = randi_range(0,1)
	passive_manager.setup(self)
	show_passive_notification("PASSIVE APPEAR HERE", 3.0)
	show_enemy_passive("ENEMY PASSIVE APPEAR HERE", 3.0)
	game_over_ui.visible = false
	pause_menu.visible = false
	turn_ui.visible = false
	print(reward_manager)
	
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
	#Refresh Enemy Passives
	
	has_value_added_tax = false
	has_fair_trade = false
	has_learn_to_save = false
	has_fully_paid = false
	has_sunlit_curse = false
	has_midnight_curse = false
	has_dusk_stance = false

	var coins = get_tree().get_nodes_in_group("enemy coins")
	for coin in coins:
		coin.queue_free()
		
	coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		coin.queue_free()

	coins = get_tree().get_nodes_in_group("reserved coins")
	for coin in coins:
		coin.queue_free()
		
	latest_pair_left_coin = null
	latest_pair_right_coin = null
	latest_coin = null
	reserved_coin = null
	enemy.debt = 0
	player.debt = 0
	enemy.gain = 0
	player.gain = 0
	player.max_flip = 16
	
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
			enemy.setup(Enemy.MAGE)
			enemy_portrait_sprite.play("MAGE")
		1: 
			enemy.setup(Enemy.DWARF)
			enemy_portrait_sprite.play("DWARF")
		2: 
			enemy.setup(Enemy.COLLECTOR)
			enemy_portrait_sprite.play("COLLECTOR")
			has_value_added_tax = true
		3: 
			enemy.setup(Enemy.TRADER)
			enemy_portrait_sprite.play("TRADER")
			has_fair_trade = true
		4: 
			enemy.setup(Enemy.THRIFTER)
			enemy_portrait_sprite.play("THRIFTER")
			has_learn_to_save = true
		5:
			enemy.setup(Enemy.ARISTOCRAT)
			enemy_portrait_sprite.play("ARISTOCRAT")
			has_fully_paid = true
			enemy.debt = 100
		6: 
			enemy.setup(Enemy.SUN_CASTER)
			enemy_portrait_sprite.play("SUN_CASTER")
			has_sunlit_curse = true
		7: 
			enemy.setup(Enemy.MOON_CASTER)
			enemy_portrait_sprite.play("MOON_CASTER")
			has_midnight_curse = true
		8:
			enemy.setup(Enemy.TWILIGHT_SAGE)
			enemy_portrait_sprite.play("TWILLIGHT_SAGE_DUSK")
			has_dusk_stance = true
	
	update_enemy_coin()
	update_player_coin()
	show_turn_ui("BATTLE START")
	flip_button.disabled = false
	
	#Battle Start Passives
	await activate_pre_battle_passives()
	player_turn_count = 0
	start_player_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_player_coin()
	update_enemy_coin()
	update_player_gain_debt()
	update_enemy_gain_debt()

func activate_pre_battle_passives():
	
	if has_value_added_tax:
		player.debt += 5
		show_floating_label(player,0,LabelType.VALUE_ADDED_TAX)
	passive_income_used = false
	payback_used = false
	payback_coins = 12
	pocket_money_coins = 8
	coin_count = 0
	player.current_flip = 0
	if has_passive_income:
		player.gain += 12
	if has_lending_charge: show_floating_label(player,0,LabelType.LENDING_CHARGE)
	if has_reimbursement: show_floating_label(player,0,LabelType.REIMBURSEMENT)
	if has_wishbone: show_floating_label(player,0,LabelType.WISH_BONE) 
	if has_golden_clover: show_floating_label(player,0,LabelType.GOLDEN_CLOVER) 
	if has_sleight_of_hand: show_floating_label(player,0,LabelType.SLEIGHT_OF_HAND) 
	if has_pocket_money:
		show_floating_label(player,0,LabelType.POCKET_MONEY) 
		while pocket_money_coins != 0:
			if current_turn != Turn.PLAYER:
				return
				
			var state = 1
			player.current_flip += 1
			var coin = COIN.instantiate()
			print("POCKET MONEY: " + str(pocket_money_coins))
			coin.setup(state,coin_deck.get_vacant_slot(player.current_flip))
			
			#Guaranteed Silver Flips
			
			coin.upgrade_to_silver()
			coin.add_to_group("coins")
			latest_coin = coin
			particle_manager.spawn_particle(COIN_ADD_PARTICLE,latest_coin.global_position)
			add_child(coin);
			
			coin_count += 1
			
			print(player.current_flip)
			if player.current_flip == player.max_flip or player.coin == 1:
				flip_button.disabled = true
			coin_calculation()
			pocket_money_coins -= 1
			sound_manager.play_sound(COIN_FLIP)
			await get_tree().create_timer(0.1).timeout
		endTurn_button.disabled = false
		re_flip_button.disabled = false

func activate_player_turn_start_passives():
	previous_player_flips = 0
	if payback_used and payback_coins != 0:
		if has_learn_to_save and coin_count >= 8:
			payback_coins = 8
			if has_piggy:
				payback_coins = 6
		else:
			payback_coins = 12
		endTurn_button.disabled = true
		re_flip_button.disabled = true
		print("PAYBACK: " + str(payback_coins))
		sound_manager.play_sound(PASSIVE_PAYBACK)
		while payback_coins != 0:
			if player.current_re_flip != player.max_re_flip: 
				re_flip_button.disabled = false
				
			var state = randi() % 2
			player.current_flip += 1
			var coin = COIN.instantiate()
			coin.setup(state,coin_deck.get_vacant_slot(player.current_flip))
			
			#Guaranteed Silver Flips
			
			coin.upgrade_to_gold()
			coin.add_to_group("coins")
			
			add_child(coin);
			
			latest_coin = coin
			coin_count += 1
			sound_manager.play_sound(COIN_FLIP)
			particle_manager.spawn_particle(COIN_ADD_PARTICLE,coin.global_position)
			if player.current_flip == player.max_flip or player.coin == 1:
				flip_button.disabled = true
			coin_calculation()
			payback_coins -= 1
			await get_tree().create_timer(0.2).timeout
			latest_coin = coin
		endTurn_button.disabled = false
		re_flip_button.disabled = false

	#Piggy Passive
	if latest_pair_left_coin != null and latest_pair_right_coin != null:
		show_floating_label(player,0,LabelType.PIGGY)
		var left_coin = COIN.instantiate()
		var pos
		player.current_flip += 1
		if coin_count >= player.max_flip:
			pos = coin_deck.get_reserve_slot()
			left_coin.reserved = true
			player.current_reserve += 1
		else:
			pos = coin_deck.get_vacant_slot(player.current_flip)
			coin_count += 1
			left_coin.reserved = false
		re_flip_button.disabled = false
		left_coin.setup(latest_pair_left_coin.state,pos)
		left_coin.copy_coin(latest_pair_left_coin)
		left_coin.reserved = false
		left_coin.add_to_group("coins")
		add_child(left_coin);
		particle_manager.spawn_particle(COIN_ADD_PARTICLE,left_coin.global_position)
		
		var right_coin = COIN.instantiate()
		player.current_flip += 1
		if coin_count >= player.max_flip:
			pos = coin_deck.get_reserve_slot()
			right_coin.reserved = true
			player.current_reserve += 1
		else:
			pos = coin_deck.get_vacant_slot(player.current_flip)
			coin_count += 1
			right_coin.reserved = false
		re_flip_button.disabled = false
		right_coin.setup(latest_pair_right_coin.state,pos)
		right_coin.copy_coin(latest_pair_right_coin)
		right_coin.reserved = false
		right_coin.add_to_group("coins")
		add_child(right_coin);
		latest_coin = right_coin
		sound_manager.play_sound(COIN_FLIP)
		particle_manager.spawn_particle(COIN_ADD_PARTICLE,right_coin.global_position)
	latest_pair_left_coin = null
	latest_pair_right_coin = null
	print(coin_count)
		

func activate_player_turn_end_passives():
	endTurn_button.disabled = true
	if has_impromptu_flip and latest_coin != null:
		show_floating_label(player,0,LabelType.IMPROMPTU_FLIP)
		if latest_coin.state == 0:
			latest_coin.state = 1
		else:
			latest_coin.state = 0
		latest_coin.refresh_sprite()
		sound_manager.play_sound(COIN_FLIP)
		coin_calculation()
		await get_tree().create_timer(1.0).timeout

	if has_magic_trick and coin_count >= 6:
		show_floating_label(player,0,LabelType.MAGIC_TRICK)
		var coins = get_tree().get_nodes_in_group("coins")
		var index = 0
		var first_coin = null
		var second_coin = null
		for coin in coins:
			index += 1
			print("Checking Coin: " + str(index))
			if index == 1: first_coin = coin
			if index == 2: second_coin = coin
			if index == 3 or index == 5:
				coin.copy_coin(first_coin)
				coin.refresh_sprite()
				sound_manager.play_sound(COIN_FLIP)
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
			if index == 4 or index == 6:
				coin.copy_coin(second_coin)
				coin.refresh_sprite()
				sound_manager.play_sound(COIN_FLIP)
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
		coin_calculation()
		await get_tree().create_timer(1.0).timeout

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
		if has_pocket_money:
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
	
	player_turn_count += 1
	
	#Initialize Global Stats
	damage = 0
	gain = 0
	debt = 0
	flip_clicks = 0
	latest_coin = null
	if has_passive_income and player_turn_count == 1:
		pass
	else:
		coin_count = 0
	
	#ACTIVE INCOME
	if has_active_income and player.gain >= 30:
		var gain_damage = player.gain
		enemy.take_damage(gain_damage)
		particle_manager.spawn_particle(DAMAGE_PARTICLE,enemy_portrait.global_position)
		sound_manager.play_sound(PASSIVE_JAR_O_SAVINGS)
		show_floating_label(enemy,gain_damage,LabelType.DAMAGE)
		show_floating_label(player,gain_damage,LabelType.ACTIVE_INCOME)
		check_defeat()
		previous_player_gain = 0
		player.debt = 0
	
	#Coin Gain Triggers
	if player.gain != 0 and player.gain > player.debt: 
		show_floating_label(player,player.gain-player.debt,LabelType.GAIN)
	if player_turn_count != 1:
		player.gain_coin()

	if has_simple_interest:
		var interest = int(previous_player_gain * 0.2)
		player.gain += interest
		gain += interest
		if interest != 0: show_floating_label(player,int(previous_player_gain * 0.2),LabelType.SIMPLE_INTEREST)

	#Reset Player Stats
	if has_pocket_money and player_turn_count == 1:
		pass
	else:
		coin_count = 0
		player.current_flip = 0
		player.current_re_flip = 0
		latest_coin = null
		coin_deck.reset_sigils()

	
	current_turn = Turn.PLAYER
	flip_button.disabled = false
	if player.current_flip == 0:
		re_flip_button.disabled = true
		turn_calculation.text = ""
	
	#Activate Turn Start Passives
	await activate_player_turn_start_passives()
	
	reflip_label.text = str(player.max_re_flip - player.current_re_flip)
	player.current_reserve = 0
	#Check Coin Reserve
	var coins = get_tree().get_nodes_in_group("reserved coins")
	for coin in coins:
		if coin.reserved:
			re_flip_button.disabled = false
			var pos
			if coin_count >= player.max_flip:
				pos = coin_deck.get_reserve_slot()
				player.current_reserve += 1
			else:
				player.current_flip += 1
				pos = coin_deck.get_vacant_slot(player.current_flip)
				coin.global_position.x = pos[0]
				coin.global_position.y = pos[1]
				coin_count += 1
				coin.reserved = false
			if has_value_increase:
				coin.upgrade()
				show_floating_label(player,0,LabelType.VALUE_INCREASE)
			latest_coin = COIN.instantiate()
			latest_coin.setup(coin.state,pos)
			latest_coin.copy_coin(coin)
			coin.queue_free()
			latest_coin.add_to_group("coins")
			add_child(latest_coin)
			latest_coin.refresh_sprite()
			#reserved_coin.queue_free()
	if has_learn_to_save and coin_count >= 8 or player.coin == 1:
		flip_button.disabled = true
		show_floating_label(player,0,LabelType.LEARN_TO_SAVE)
			
func start_enemy_turn():
	coin_deck.reset_sigils()
	endTurn_button.disabled = true
	
	if enemy.type == Enemy.SUN_CASTER:
		if sun_count >= 9:
			enemy.gold_flip_rate = 1
		else:
			enemy.gold_flip_rate = 0

	if enemy.type == Enemy.MOON_CASTER:
		if moon_count >= 9:
			enemy.gold_flip_rate = 1
		else:
			enemy.gold_flip_rate = 0
	
	show_turn_ui("Enemy Turn")
	#Initialize Stats
	damage = 0
	gain = 0
	debt = 0
	var defeat
	
	#Coin Gain Triggers
	if enemy.gain != 0 and enemy.gain > enemy.debt: show_floating_label(enemy,enemy.gain,LabelType.GAIN)
	enemy.gain_coin()
	if has_fully_paid and enemy.debt == 0:
		player.take_damage(100)
		particle_manager.spawn_particle(DAMAGE_PARTICLE,player_portrait.global_position)
		show_floating_label(player,100,LabelType.FULLY_PAID)
		defeat = await check_defeat()
	if has_loan_shark and enemy.debt > 1:
		var loan_damage = enemy.debt
		enemy.take_damage(loan_damage)
		particle_manager.spawn_particle(DAMAGE_PARTICLE,enemy_portrait.global_position)
		sound_manager.play_sound(PASSIVE_LOAN_SHARK)
		show_floating_label(enemy,loan_damage,LabelType.LOAN_SHARK)
		defeat = await check_defeat()


	#Reset Enemy Stats
	enemy.current_flip = 0
	
	if has_fair_trade:
		enemy.max_flip = previous_player_flips
		previous_player_flips = 0
		show_floating_label(enemy,0,LabelType.FAIR_TRADE)
		
	current_turn = Turn.ENEMY
	turn_calculation.text = ""
	

	flip_button.disabled = true
	re_flip_button.disabled = true
	endTurn_button.disabled = true

	#FLIP COINS
	if defeat == null:
		await get_tree().create_timer(1.0).timeout
		while enemy.current_flip != enemy.max_flip:
			if defeat == null:
				enemy_flip()
			await get_tree().create_timer(0.4).timeout
		await get_tree().create_timer(1.0).timeout
		end_enemy_turn()

func end_enemy_turn():
	coin_deck.sigil_pressed()
	
	if damage != 0: 
		if has_passive_income and !passive_income_used:
			passive_income_used = true
			if damage >= 30:
				damage = 30
			player.coin += damage
			sound_manager.play_sound(PASSIVE_PASSIVE_INCOME)
			show_floating_label(player,damage,LabelType.PASSIVE_INCOME)
		else:
			if damage <= 10: sound_manager.play_sound(DAMAGE_LIGHT)
			elif damage <= 20: sound_manager.play_sound(DAMAGE_MODERATE)
			else: sound_manager.play_sound(DAMAGE_HEAVY)
			player.take_damage(damage)
			particle_manager.spawn_particle(DAMAGE_PARTICLE,player_portrait.global_position)
			show_floating_label(player,damage,LabelType.DAMAGE)
	if debt != 0:
			player.debt += debt
			sound_manager.play_sound(DEBT)
			show_floating_label(player,debt,LabelType.DEBT)
	enemy.gain += gain
	if gain != 0: show_floating_label(enemy,gain,LabelType.TO_GAIN)
	if has_pay_down:
		if enemy.debt > enemy.coin:
			enemy.coin = 0
			sound_manager.play_sound(PASSIVE_PAYDOWN)
			show_floating_label(enemy,0,LabelType.PAY_DOWN)
		else:
			enemy.debt += 10
		
	var defeat = await check_defeat()
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	for coin in coins:
		particle_manager.spawn_particle(COIN_PLAY_PARTICLE,coin.global_position)
		coin.queue_free()
	
	#ACTIVATE PAYBACK
	if has_payback and !payback_used and defeat: 
		show_floating_label(player,0,LabelType.PAYBACK)
		defeat = null
		player.coin = 1
		payback_used = true
		payback_coins = 12
		
	if defeat == null:
		await get_tree().create_timer(1.0).timeout
		show_turn_ui("Player Turn")
		if enemy.type == Enemy.TWILIGHT_SAGE:
			has_dusk_stance = !has_dusk_stance
			enemy.max_flip += 4
		sound_manager.play_sound(TURN_PLAYER)
		start_player_turn()
	
	coin_deck.sigil_unlight_()

func _on_endturn_pressed():
	re_flip_button.disabled = true
	endTurn_button.disabled = true
	sound_manager.play_sound(COIN_ENDTURN)
	coin_deck.sigil_pressed();
	previous_player_flips = flip_clicks
	
	#Activate End Turn Passives
	await activate_player_turn_end_passives()
	enemy.take_damage(damage)
	
	if damage <= 10: sound_manager.play_sound(DAMAGE_LIGHT)
	elif damage <= 20: sound_manager.play_sound(DAMAGE_MODERATE)
	else: sound_manager.play_sound(DAMAGE_HEAVY)
	previous_player_gain += gain
	if damage != 0: 
		show_floating_label(enemy,damage,LabelType.DAMAGE)
		particle_manager.spawn_particle(DAMAGE_PARTICLE,enemy_portrait.global_position)
	player.gain += gain
	if gain != 0: show_floating_label(player,gain,LabelType.TO_GAIN)
	if debt != 0: 
		sound_manager.play_sound(DEBT)
		show_floating_label(enemy,debt,LabelType.DEBT)
		enemy.debt += debt

	if enemy.type == Enemy.TWILIGHT_SAGE:
		if has_dusk_stance:
			enemy.gain += moon_count * 3
			update_enemy_gain_debt()
		else:
			player.debt += sun_count * 3
			update_player_gain_debt()
	reserve_left_over_coin()
	var coins = get_tree().get_nodes_in_group("coins")
	var is_left = true
	if has_piggy:
		latest_pair_left_coin = COIN.instantiate()
		latest_pair_right_coin = COIN.instantiate()
	for coin in coins:
		if has_piggy and is_left and !coin.reserved:
			latest_pair_left_coin.copy_coin(coin)
			is_left = false
			print("Piggy Copying 1")
		elif has_piggy and !is_left and !coin.reserved:
			latest_pair_right_coin.copy_coin(coin)
			is_left = true
			print("Piggy Copying 2")
		if coin.reserved == false:
			particle_manager.spawn_particle(COIN_PLAY_PARTICLE,coin.global_position)
			coin.queue_free()
	

	var defeat = await check_defeat()
	if defeat == null:
		await get_tree().create_timer(1.0).timeout
		start_enemy_turn()
			
	total_damage_dealt += damage
	if damage > highest_damage_dealt:
		highest_damage_dealt = damage
		
	total_gain += gain
	if gain > highest_gain:
		highest_gain = gain
			
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
	
	var tween_out = create_tween()
	tween_out.tween_property(notif, "modulate:a", 0.0, 0.5)
	tween_out.tween_callback(func():
		notif.queue_free()
	)
	
func show_enemy_passive(text: String, duration: float = 1.5) -> void:
	if not is_instance_valid(enemy_passive_label):
		return
		
	enemy_passive_label.text = text
	enemy_passive_label.visible = true
	enemy_passive_label.modulate = Color(0.0, 0.0, 0.0, 1.0)
	enemy_passive_label.z_index = 100
	
	var tween = create_tween()
	tween.parallel().tween_property(enemy_passive_label, "modulate:a", 1.0, 0.2)
	tween.parallel().tween_property(enemy_passive_label, "position:y", enemy_passive_label.position.y - 20, 0.2)
	tween.parallel().tween_property(enemy_passive_label, "scale", Vector2(1, 1), 0.2)
	
	
	var tween_out = create_tween()
	tween_out.tween_property(enemy_passive_label, "modulate:a", 0.0, 0.5).set_delay(duration)
	tween_out.tween_callback(func():
		enemy_passive_label.visible = false
		enemy_passive_label.modulate.a = 1.0 
	)
	


func _on_flip_pressed():
	sound_manager.play_sound(COIN_FLIP)
	print("FLIP")
	flip_clicks += 1
	if player.current_re_flip != player.max_re_flip: 
		re_flip_button.disabled = false
	if current_turn != Turn.PLAYER:
		return
		
	var state = randi() % 2
	
	if has_sunlit_curse:
		state = 0
	if has_midnight_curse:
		state = 1
		
	if flip_clicks == 1 and has_solar_coin:
		state = 0;
		show_floating_label(player,0,LabelType.SOLAR_COIN)
	if flip_clicks == 2 and has_lunar_coin:
		state = 1;
		show_floating_label(player,0,LabelType.LUNAR_COIN)
	
	player.current_flip += 1
	var coin = COIN.instantiate()
	if coin_count >= player.max_flip:
		coin.setup(state,coin_deck.get_reserve_slot())
		coin.reserved = true
		player.current_reserve += 1
		coin.add_to_group("reserved coins")
	else:
		coin.setup(state,coin_deck.get_vacant_slot(player.current_flip))
		coin.add_to_group("coins")
	#Silver/Gold Flip Rate
	
	var upgrade_chance = randf()
	
	if upgrade_chance <= player.silver_flip_rate:
		coin.upgrade_to_silver()
		show_floating_label(player,0,LabelType.SILVER_FLIP)
		
	upgrade_chance = randf() 
	if upgrade_chance <= player.gold_flip_rate:
		coin.upgrade_to_gold()
		show_floating_label(player,0,LabelType.GOLD_FLIP) 
	
	if has_lucky_pair and (flip_clicks == 7 or flip_clicks == 8):
		coin.upgrade()
		sound_manager.play_sound(COIN_UPGRADE)
		show_floating_label(player,0,LabelType.LUCKY_PAIR)
	
	if flip_clicks <= 3 and has_triple_nickel:
		coin.upgrade_to_silver()
		show_floating_label(player,0,LabelType.TRIPLE_NICKEL)
	if has_coin_snipe and coin.base_value > 2:
		particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,enemy_portrait.global_position)
		sound_manager.play_sound(PASSIVE_COIN_SNIPE)
		enemy.take_damage(1)
		show_floating_label(player,1,LabelType.COIN_SNIPE)
		show_floating_label(enemy,1,LabelType.DAMAGE)
		check_defeat()

	player.take_damage(1)
	show_floating_label(player,1,LabelType.DAMAGE)
	add_child(coin)
	
	if coin.reserved == false:
		latest_coin = coin
		coin_count += 1
		particle_manager.spawn_particle(COIN_ADD_PARTICLE,latest_coin.global_position)

	print(coin_count)
	if coin_count == player.max_flip and (player.current_reserve == player.max_reserve or player.coin == 1):
		flip_button.disabled = true
	if has_learn_to_save and coin_count >= 8:
		flip_button.disabled = true
		show_floating_label(player,0,LabelType.LEARN_TO_SAVE)
	coin_calculation()
	check_defeat()

func enemy_flip():
	sound_manager.play_sound(COIN_FLIP)
	var state = randi() % 2
	
	if enemy.type == Enemy.SUN_CASTER and sun_count >= 9:
		state = 0
	if enemy.type == Enemy.MOON_CASTER and moon_count >= 9:
		state = 1

	enemy.take_damage(1)
	show_floating_label(enemy,1,LabelType.DAMAGE) 
	enemy_coin_calculation()
	var defeat = await check_defeat()

	
	enemy.current_flip += 1
	var coin = COIN.instantiate()
	if defeat == null:
		coin.setup(state,coin_deck.get_vacant_slot(enemy.current_flip))
	
	
	#Silver/Gold Flip Rate
	
	var upgrade_chance = randf()
	if upgrade_chance <= enemy.silver_flip_rate:
		coin.upgrade_to_silver()
		show_floating_label(enemy,0,LabelType.SILVER_FLIP)
	
	upgrade_chance = randf()  
	if upgrade_chance <= enemy.gold_flip_rate:
		coin.upgrade_to_gold()
		show_floating_label(enemy,0,LabelType.GOLD_FLIP) 
	

	coin.add_to_group("enemy_coins")
	add_child(coin);
	particle_manager.spawn_particle(COIN_ADD_PARTICLE,coin.global_position)
	
	
func trigger_game_over(player_won: bool):
	sound_manager.play_sound(DEATH)
	if player_won:
		enemy.max_flip = 0
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
		if has_payback:
			if payback_used:
				game_over_ui.visible = true
				trigger_game_over(false)
		else:
			game_over_ui.visible = true
			trigger_game_over(false)
		return true
		
	if enemy.coin <= 0:
		enemy.max_flip = 0
		enemies_defeated += 1
		await handle_victory_flow()
		return true
	
	return null

func handle_victory_flow():
	await show_turn_ui("VICTORY")
	await get_tree().create_timer(0.2).timeout
	
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
		proceed_to_next_enemy()

		
	
func _on_re_flip_pressed():
	sound_manager.play_sound(COIN_REFLIP)
	sound_manager.play_sound(COIN_FLIP)
	var tween = create_tween()
	var original_scale: Vector2 = reflip_sprite.scale
	var swelled_scale: Vector2 = original_scale * 1.2 
	tween.tween_property(reflip_sprite, "scale", swelled_scale, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(reflip_sprite, "scale", original_scale, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	print("REFLIP")
	print(coin_count)
	if has_advanced_planning: show_floating_label(player,0,LabelType.ADVANCED_PLANNING)
	player.current_re_flip += 1
	reflip_label.text = str(player.max_re_flip - player.current_re_flip)
	var coins = get_tree().get_nodes_in_group("coins")
	var index = 0
	var refund_chance = randf()
	if has_refund and refund_chance <= 0.1: sound_manager.play_sound(PASSIVE_REFUND)
	for coin in coins:
		if !coin.reserved:
			index += 1
		if index <= 2 and has_advanced_planning:
			pass
		else:
			if has_inflation:
				var upgrade_chance = randf()
				if upgrade_chance <= 0.3:
					show_floating_label(player,0,LabelType.INFLATION)
					coin.upgrade()
				coin.re_flip()
			if has_refund and refund_chance <= 0.1:
				player.coin += 1
				coin_count -= 1
				player.current_flip -= 1
				coin.queue_free()
				flip_button.disabled = false
				coin_calculation()
				show_floating_label(player,0,LabelType.REFUND)
				
			else:
				coin.re_flip()
	if has_spare_change:
		sound_manager.play_sound(PASSIVE_SPARE_CHANGE)
		var reserved_coins = get_tree().get_nodes_in_group("reserved coins")
		for coin in reserved_coins:
			player.coin += 1
			coin.queue_free()
			flip_button.disabled = false
			player.current_reserve -= 1
			show_floating_label(player,0,LabelType.SPARE_CHANGE)
	
	if player.current_re_flip == player.max_re_flip or coin_count == 0:
		re_flip_button.disabled = true

	coin_calculation()

func coin_calculation():
	var is_left = true # true - Left Coin, false - Right Coin
	var left_coin
	var right_coin
	damage = 0
	gain = 0
	debt = 0
	sun_count = 0
	moon_count = 0
	var head_tail_count = 0
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if is_left == true:
			left_coin = coin
		if is_left == false:
			right_coin = coin
		if coin.state == 0 and !coin.reserved:
			sun_count += 1
		else:
			moon_count +=1
		if left_coin != null and right_coin != null and left_coin.reserved == false and right_coin.reserved == false:
			# 1. HEAD-HEAD PAIR
			if left_coin.state == 0 and right_coin.state == 0:
				damage += (left_coin.base_value + right_coin.base_value)
			# 2. TAIL-TAIL PAIR
			elif left_coin.state == 1 and right_coin.state == 1:
				gain += (left_coin.base_value + right_coin.base_value)
			# 3. HEAD-TAIL PAIR
			elif left_coin.state == 0 and right_coin.state == 1:
				damage += (left_coin.base_value / 2)
				gain += (right_coin.base_value / 2)
				head_tail_count += 1
				if has_lending_charge: debt += 3
			else:
				damage += (right_coin.base_value / 2)
				gain += (left_coin.base_value / 2)
				if has_lending_charge: debt += 3
				head_tail_count += 1
			left_coin = null
			right_coin = null
		else:
			pass
		is_left = !is_left
	if has_reimbursement and head_tail_count == coin_count / 2:
		debt *= 2
	if (damage != 0 or gain != 0) and coins != null:
		var text = "DMG: " + str(damage) + "\nGAIN: " + str(gain)
		if debt != 0:
			text = "DMG: " + str(damage) + "\nGAIN: " + str(gain) + "\nDEBT: " + str(debt)
		turn_calculation.text = text
		turn_calculation.add_theme_color_override("font_color", Color.WHITE)
	else: 
		turn_calculation.text = ""

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
	

func enemy_coin_calculation():
	print("Calculating DMG and Gain of Enemy")
	damage = 0
	gain = 0
	debt = 0
	var type = enemy.type
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	match type:
		Enemy.MAGE:
			for coin in coins:
				if coin.state == 0: damage += coin.base_value
		Enemy.DWARF:
			var can_attack = true
			var coin_count = 0
			for coin in coins:
				coin_count += 1
				if coin.state == 1: can_attack = false
			if can_attack and coin_count == 2: damage += 4
		Enemy.COLLECTOR:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin			
				if left_coin != null and right_coin != null:
					if left_coin.state != right_coin.state:
						damage += (left_coin.base_value)
						gain += (right_coin.base_value)
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
		Enemy.TRADER:
			for coin in coins:
				if coin.state == 0: damage += coin.base_value / 2
		Enemy.THRIFTER:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin
				if left_coin != null and right_coin != null:
					if left_coin.state == 1 and right_coin.state == 1:
						gain += (left_coin.base_value) + (right_coin.base_value)
					if left_coin.state == 0 and right_coin.state == 0:
						damage += (left_coin.base_value) + (right_coin.base_value)
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
		Enemy.ARISTOCRAT:
			for coin in coins:
				if coin.state == 1: gain += coin.base_value
		Enemy.SUN_CASTER:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if coin.state == 0:
					gain += coin.base_value / 2
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin			
				if left_coin != null and right_coin != null:
					if left_coin.state == 0 and right_coin.state == 0:
						damage += (left_coin.base_value) + (right_coin.base_value)
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
		Enemy.MOON_CASTER:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if coin.state == 1:
					debt += coin.base_value / 2
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin			
				if left_coin != null and right_coin != null:
					if left_coin.state == 1 and right_coin.state == 1:
						damage += left_coin.base_value / 2 + right_coin.base_value / 2 
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
		Enemy.TWILIGHT_SAGE:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin
				if left_coin != null and right_coin != null and left_coin.reserved == false and right_coin.reserved == false:
					# 1. HEAD-HEAD PAIR
					if left_coin.state == 0 and right_coin.state == 0:
						damage += (left_coin.base_value + right_coin.base_value)
					# 2. TAIL-TAIL PAIR
					elif left_coin.state == 1 and right_coin.state == 1:
						gain += (left_coin.base_value + right_coin.base_value)
					# 3. HEAD-TAIL PAIR
					elif left_coin.state == 0 and right_coin.state == 1:
						damage += (left_coin.base_value / 2)
						gain += (right_coin.base_value / 2)
					else:
						damage += (right_coin.base_value / 2)
						gain += (left_coin.base_value / 2)
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
	if damage != 0 or debt != 0 or gain != 0:
		var text = "DMG: " + str(damage) + "\nGAIN: " + str(gain) + "\nDEBT: " + str(debt)
		turn_calculation.text = text
		turn_calculation.add_theme_color_override("font_color", Color.INDIAN_RED)


enum LabelType{
	DAMAGE,
	GAIN,
	TO_GAIN,
	DEBT,
	SILVER_FLIP,
	GOLD_FLIP,
	WISH_BONE,
	GOLDEN_CLOVER,
	SOLAR_COIN,
	LUNAR_COIN,
	MERCHANT_SCROLL,
	IMPROMPTU_FLIP,
	ADVANCED_PLANNING,
	MAGIC_TRICK,
	SLEIGHT_OF_HAND,
	PIGGY,
	INFLATION,
	PAYBACK,
	LUCKY_PAIR,
	VALUE_INCREASE,
	SPARE_CHANGE,
	TRIPLE_NICKEL,
	REFUND,
	COIN_SNIPE,
	ACTIVE_INCOME,
	POCKET_MONEY,
	PASSIVE_INCOME,
	SIMPLE_INTEREST,
	PAY_DOWN,
	REIMBURSEMENT,
	LOAN_SHARK,
	LENDING_CHARGE,
	
	VALUE_ADDED_TAX,
	FAIR_TRADE,
	LEARN_TO_SAVE,
	FULLY_PAID
}
func show_floating_label(entity, value, type):
	var label = Label.new()
	var target_pos
	label.add_theme_font_size_override("font_size",32)
	match type:
		LabelType.DAMAGE:
			label.text = "-" + str(value) + " DMG"
			label.add_theme_color_override("font_color",Color.RED)
			label.add_theme_font_size_override("font_size",18)
		LabelType.GAIN:
			label.text = "+" + str(value) + " COINS"
			label.add_theme_color_override("font_color",Color.GOLD)
			label.add_theme_font_size_override("font_size",18)
		LabelType.TO_GAIN:
			label.text = "To GAIN: " + str(value)
			label.add_theme_color_override("font_color",Color.DARK_GOLDENROD)
			label.add_theme_font_size_override("font_size",18)
		LabelType.DEBT:
			label.text = "+" + str(value) + " DEBT"
			label.add_theme_color_override("font_color",Color.REBECCA_PURPLE)
			label.add_theme_font_size_override("font_size",18)
		LabelType.SILVER_FLIP:
			label.text = "Silver FLIP"
			label.add_theme_color_override("font_color",Color.SILVER)
		LabelType.GOLD_FLIP:
			label.text = "Gold FLIP"
			label.add_theme_color_override("font_color",Color.GOLDENROD)
		LabelType.WISH_BONE:
			label.text = "WISH BONE: +10% Silver Flip Rate"
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.GOLDEN_CLOVER:
			label.text = "GOLDEN CLOVER: +5% Gold Flip Rate"
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.SLEIGHT_OF_HAND:
			label.text = "SLEIGHT OF HAND: +6 Re-Flips"
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.SOLAR_COIN:
			label.text = "SOLAR COIN: Guaranteed Sun"
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.LUNAR_COIN:
			label.text = "LUNAR COIN: Guaranteed Moon"
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.IMPROMPTU_FLIP:
			label.text = "IMPROMPTU FLIP: Last Coin Re-Flipped"
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.MAGIC_TRICK:
			label.text = "MAGIC TRICK: 1st Pair Duplicated"
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.ADVANCED_PLANNING:
			label.text = "ADVANCED PLANNING: No Re-Flip to First 2 Coins" 
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.PIGGY:
			label.text = "PIGGY: Generated 1st Pair" 
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.VALUE_INCREASE:
			label.text = "VALUE INCREASE: Reserved Coin Upgrade" 
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.LUCKY_PAIR:
			label.text = "LUCKY PAIR: Guaranteed Coin Upgrade" 
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.PAYBACK:
			label.text = "PAYBACK: +12 Gold Coins Next Turn" 
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",30)
		LabelType.INFLATION:
			label.text = "INFLATION: Coin Upgraded" 
			label.add_theme_color_override("font_color",Color.DARK_GOLDENROD)
			label.add_theme_font_size_override("font_size",22)
		LabelType.COIN_SNIPE:
			label.text = "COIN SNIPE: " + str(value) + " DMG"
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.REFUND:
			label.text = "REFUND: Retrieved 2 Coins" 
			label.add_theme_color_override("font_color",Color.DARK_GOLDENROD)
			label.add_theme_font_size_override("font_size",22)
		LabelType.TRIPLE_NICKEL:
			label.text = "TRIPLE NICKEL: Guaranteed Silver" 
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.SPARE_CHANGE:
			label.text = "SPARE CHANGE: Retrieved 1 Coin" 
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.SIMPLE_INTEREST:
			label.text = "SIMPLE INTEREST: +" + str(value) + " GAIN"
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.POCKET_MONEY:
			label.text = "POCKET MONEY: +8 Silver Moon Coins" 
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.PASSIVE_INCOME:
			label.text = "PASSIVE INCOME: +" + str(value) + " COINS"
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.ACTIVE_INCOME:
			label.text = "ACTIVE INCOME: " + str(value) + " DMG"
			label.add_theme_color_override("font_color",Color.DARK_GOLDENROD)
			label.add_theme_font_size_override("font_size",22)
		LabelType.PAY_DOWN:
			label.text = "PAY DOWN: Instant Death"
			label.add_theme_color_override("font_color",Color.DARK_GOLDENROD)
			label.add_theme_font_size_override("font_size",30)
		LabelType.REIMBURSEMENT:
			label.text = "REIMBURSEMENT: Double DEBT on All Sun-Moon"
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.LOAN_SHARK:
			label.text = "LOAN SHARK: -" + str(value) + " DMG"
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.LENDING_CHARGE:
			label.text = "LENDING CHARGE: Sun-Moon DEBT Application"
			label.add_theme_color_override("font_color",Color.SANDY_BROWN)
			label.add_theme_font_size_override("font_size",22)
		#ENEMY PASSIVES
		LabelType.VALUE_ADDED_TAX:
			label.text = "VALUE ADDED TAX: +5 DEBT"
			label.add_theme_color_override("font_color",Color.WEB_MAROON)
			label.add_theme_font_size_override("font_size",16)
		LabelType.FAIR_TRADE:
			label.text = "FAIR TRADE: Coin Count Copied"
			label.add_theme_color_override("font_color",Color.WEB_MAROON)
			label.add_theme_font_size_override("font_size",16)
		LabelType.LEARN_TO_SAVE:
			label.text = "LEARN TO SAVE: Only 8 Coins Allowed"
			label.add_theme_color_override("font_color",Color.WEB_MAROON)
			label.add_theme_font_size_override("font_size",16)
		LabelType.FULLY_PAID:
			label.text = "FULLY PAID: -" + str(value) + " DMG"
			label.add_theme_color_override("font_color",Color.WEB_MAROON)
			label.add_theme_font_size_override("font_size",16)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	
	if entity == player:
		var portrait = player_portrait
		label.global_position = portrait.global_position
		label.global_position.x += 100
		label.global_position.y -= 50
		target_pos = label.global_position.y - 100
	
	elif entity == enemy:
		var portrait = enemy_portrait
		label.global_position = portrait.global_position
		label.global_position.x += 50
		label.global_position.y += 160
		target_pos = label.global_position.y + 100

	#FURTHER OFFSET
	match type:
		LabelType.DAMAGE:
			label.global_position.x -= 10
		LabelType.GAIN:
			label.global_position.x -= 10
		LabelType.TO_GAIN:
			label.global_position.x -= 10
		LabelType.SILVER_FLIP:
			label.global_position.x -= 70
			label.global_position.y -= 70
		LabelType.GOLD_FLIP:
			label.global_position.x -= 70
			label.global_position.y -= 100
		LabelType.WISH_BONE:
			label.global_position.x -= 100
			label.global_position.y -= 10
		LabelType.GOLDEN_CLOVER:
			label.global_position.x -= 100
			label.global_position.y += 20
		LabelType.SLEIGHT_OF_HAND:
			label.global_position.x -= 100
			label.global_position.y -= 50
		_:
			label.global_position.x -= 100
			label.global_position.y -= 50
	
	#Random Offset
	label.global_position.x += randi_range(-20,20)
	label.global_position.y += randi_range(-40,40)
	if entity == player:
		target_pos = label.global_position.y - randi_range(70,200)
	else: 
		target_pos = label.global_position.y + randi_range(70,200)
	add_child(label)
	var tween = create_tween()
	tween.parallel().tween_property(label,"position:y",target_pos,2.0)
	tween.parallel().tween_property(label,"modulate",Color("ffffff00"),2.0)
	tween.tween_callback(label.queue_free)


func _on_restart_pressed():
	await get_tree().create_timer(0.2).timeout
	get_tree().reload_current_scene()
	
	
#func trigger_random_event():
	#if event_maps.empty():
	   #print("No maps to load!")
	   #return

	#Pick a random index
	#var index = randi() % event_maps.size()
	#var map_scene = event_maps[index]

	#Instantiate the map
	#var map_instance = map_scene.instantiate()
	#get_tree().current_scene.add_child(map_instance)

	#print("Random Event Triggered:", map_scene.resource_path)
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
