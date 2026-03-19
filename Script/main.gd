extends ColorRect

enum Turn {
	PLAYER,
	ENEMY
}

enum Enemy{
	MAGE,
	DWARF
}

#USER INTERFACE
@onready var player = $Player
@onready var enemy = $Enemy

@onready var player_portrait: ColorRect = $Player/Player_Portrait
@onready var enemy_portrait: ColorRect = $Enemy/Enemy_Portrait

@onready var endTurn_button = $"Battle UI/Endturn"
@onready var flip_button = $"Battle UI/PlayerHealthBar/Flip"
@onready var re_flip_button: Button = $"Battle UI/Re-Flip"
@onready var turn_calculation: Label = $"Battle UI/Turn Calculation"

@onready var player_health_bar = $"Battle UI/PlayerHealthBar"
@onready var player_health_label = $"Battle UI/PlayerHealthBar/HealthLabel"

@onready var enemy_health_bar = $"Battle UI/EnemyHealthBar"
@onready var enemy_health_label = $"Battle UI/EnemyHealthBar/EnemyHealthLabel"

@onready var turn_ui: ColorRect = $"Battle UI/Turn UI"
@onready var turn_ui_label: Label = $"Battle UI/Turn UI/Turn UI Label"

@onready var game_over_ui: CanvasLayer = $"Game Over UI"


#COIN DECK 
@onready var coin_deck: Node2D = $CoinDeck

#COIN
const COIN = preload("uid://ddet242jm5v23")

#CALCULATIONS
var damage = 0
var gain = 0
var debt = 0
var reserved_coin = null
var current_turn = Turn.PLAYER


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

@export var has_loyalty_contract = false
@export var has_triple_nickel = false
@export var has_refund = false
@export var has_coin_snipe = false

#INVESTOR PASSIVES

@export var has_active_income = false
@export var has_pocket_money = false
@export var has_passive_income = false
@export var has_simple_interest = false

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_ui.visible = false
	turn_ui.visible = false
	battle_start()

func activate_pre_battle_passives():
	passive_income_used = false
	payback_used = false
	payback_coins = 12
	pocket_money_coins = 6
	if has_simple_interest:
		show_floating_label(player,0,LabelType.SIMPLE_INTEREST)
		enemy.bounty *= 1.3
	if has_wishbone: show_floating_label(player,0,LabelType.WISH_BONE) 
	if has_golden_clover: show_floating_label(player,0,LabelType.GOLDEN_CLOVER) 
	if has_sleight_of_hand: show_floating_label(player,0,LabelType.SLEIGHT_OF_HAND) 
	if has_pocket_money:
		show_floating_label(player,0,LabelType.POCKET_MONEY) 
		while pocket_money_coins != -1:
			if player.current_re_flip != player.max_re_flip: 
				re_flip_button.disabled = false
			if current_turn != Turn.PLAYER:
				return
				
			var state = 1
			player.current_flip += 1
			var coin = COIN.instantiate()
			coin.setup(state,coin_deck.get_vacant_slot(player.current_flip))
			
			#Guaranteed Silver Flips
			
			coin.upgrade_to_silver()
			coin.add_to_group("coins")
			
			add_child(coin);
			latest_coin = coin
			coin_count += 1
			
			print(player.current_flip)
			if player.current_flip == player.max_flip or player.coin == 1:
				flip_button.disabled = true
			coin_calculation()
			pocket_money_coins -= 1
			await get_tree().create_timer(0.1).timeout
		endTurn_button.disabled = false
		re_flip_button.disabled = false

func activate_player_turn_start_passives():
	
	if payback_used:
		endTurn_button.disabled = true
		re_flip_button.disabled = true
		while payback_coins != 0:
			if player.current_re_flip != player.max_re_flip: 
				re_flip_button.disabled = false
			if current_turn != Turn.PLAYER:
				return
				
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
			
			print(player.current_flip)
			if player.current_flip == player.max_flip or player.coin == 1:
				flip_button.disabled = true
			coin_calculation()
			payback_coins -= 1
			await get_tree().create_timer(0.2).timeout
		endTurn_button.disabled = false
		re_flip_button.disabled = false

	#Piggy Passive
	if latest_pair_left_coin != null and latest_pair_right_coin != null:
		show_floating_label(player,0,LabelType.PIGGY)
		var left_coin = COIN.instantiate()
		player.current_flip += 1
		re_flip_button.disabled = false
		left_coin.setup(latest_pair_left_coin.state,coin_deck.get_vacant_slot(player.current_flip))
		left_coin.copy_coin(latest_pair_left_coin)
		left_coin.reserved = false
		left_coin.add_to_group("coins")
		add_child(left_coin);
		coin_count += 1
		
		var right_coin = COIN.instantiate()
		player.current_flip += 1
		re_flip_button.disabled = false
		right_coin.setup(latest_pair_right_coin.state,coin_deck.get_vacant_slot(player.current_flip))
		right_coin.copy_coin(latest_pair_right_coin)
		right_coin.reserved = false
		right_coin.add_to_group("coins")
		add_child(right_coin);
		coin_count += 1
	
	latest_pair_left_coin = null
	latest_pair_right_coin = null
	
	if has_active_income and previous_player_gain >= 25:
		var gain_damage = previous_player_gain / 2
		enemy.take_damage(gain_damage)
		show_floating_label(enemy,gain_damage,LabelType.DAMAGE)
		show_floating_label(player,gain_damage,LabelType.ACTIVE_INCOME)
		check_defeat()
		previous_player_gain = 0
		

func activate_player_turn_end_passives():
	endTurn_button.disabled = true
	if has_impromptu_flip:
		show_floating_label(player,0,LabelType.IMPROMPTU_FLIP)
		if latest_coin.state == 0:
			latest_coin.state = 1
		else:
			latest_coin.state = 0
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
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
			if index == 4 or index == 6:
				coin.copy_coin(second_coin)
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
		coin_calculation()
		await get_tree().create_timer(1.0).timeout
	
func battle_start():
	randomize()
	flip_button.pressed.connect(_on_flip_pressed)
	endTurn_button.pressed.connect(_on_endturn_pressed)
	re_flip_button.pressed.connect(_on_re_flip_pressed)
	var enemy_id = randi() % 2
	match enemy_id:
		0: enemy.setup(Enemy.MAGE)
		1: enemy.setup(Enemy.DWARF)
	
	update_enemy_coin()
	update_player_coin()
	show_turn_ui("BATTLE START")
	
	#Battle Start Passives
	activate_pre_battle_passives()
	start_player_turn()
	

func show_turn_ui(text):
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_player_coin()
	update_enemy_coin()


func start_player_turn():

	#Initialize Global Stats
	damage = 0
	gain = 0
	debt = 0
	flip_clicks = 0
	latest_coin = null
	coin_count = 0
	
	#Coin Gain Triggers
	if player.gain != 0: show_floating_label(player,player.gain,LabelType.GAIN)
	player.gain_coin()

	#Reset Player Stats
	
	if has_pocket_money and pocket_money_coins == 0:
		player.current_flip = 0
	else:
		player.current_flip = 0
	player.current_re_flip = 0

	current_turn = Turn.PLAYER
	flip_button.disabled = false
	re_flip_button.disabled = true
	turn_calculation.text = ""
	
	#Activate Turn Start Passives
	await activate_player_turn_start_passives()
	
	#Check Coin Reserve
	if reserved_coin != null:
		var coin = COIN.instantiate()
		player.current_flip += 1
		re_flip_button.disabled = false
		coin.setup(reserved_coin.state,coin_deck.get_vacant_slot(player.current_flip))
		coin.copy_coin(reserved_coin)
		coin.reserved = false
		coin.add_to_group("coins")
		if has_value_increase:
			coin.upgrade()
			show_floating_label(player,0,LabelType.VALUE_INCREASE)
		add_child(coin);
		coin_count += 1
		reserved_coin.queue_free()
	
func start_enemy_turn():
	
	show_turn_ui("Enemy Turn")
	#Initialize Stats
	damage = 0
	gain = 0
	debt = 0
	
	#Coin Gain Triggers
	if enemy.gain != 0: show_floating_label(enemy,enemy.gain,LabelType.GAIN)
	enemy.gain_coin()
	

	#Reset Enemy Stats
	enemy.current_flip = 0
	
	current_turn = Turn.ENEMY
	turn_calculation.text = ""
	
	flip_button.disabled = true
	re_flip_button.disabled = true
	
	#FLIP COINS
	await get_tree().create_timer(1.0).timeout
	while enemy.current_flip != enemy.max_flip:
		enemy_flip()
		await get_tree().create_timer(0.4).timeout
	await get_tree().create_timer(1.0).timeout
	
	end_enemy_turn()

func end_enemy_turn():
	if damage != 0: 
		if has_passive_income and !passive_income_used:
			passive_income_used = true
			show_floating_label(player,damage,LabelType.PASSIVE_INCOME)
			player.coin += damage
			update_player_coin()
		else:
			player.take_damage(damage)
			show_floating_label(player,damage,LabelType.DAMAGE)
	enemy.gain += gain
	if gain != 0: show_floating_label(enemy,gain,LabelType.TO_GAIN)
	var defeat = check_defeat()
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	for coin in coins:
		coin.queue_free()
	
	#ACTIVATE PAYBACK
	if has_payback and !payback_used and defeat: 
		show_floating_label(player,0,LabelType.PAYBACK)
		defeat = null
		player.coin = 1
		payback_used = true
		
	if defeat == null:
		await get_tree().create_timer(0.4).timeout
		show_turn_ui("Player Turn")
		start_player_turn()

func _on_endturn_pressed():
	
	#Activate End Turn Passives
	await activate_player_turn_end_passives()
	enemy.take_damage(damage)
	previous_player_gain = gain
	if damage != 0: show_floating_label(enemy,damage,LabelType.DAMAGE)
	player.gain += gain
	if gain != 0: show_floating_label(player,gain,LabelType.TO_GAIN)
	reserve_left_over_coin()
	var defeat = check_defeat()
	if defeat == null:
		if current_turn == Turn.PLAYER:
			start_enemy_turn()
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
			coin.queue_free()


func _on_flip_pressed():
	flip_clicks += 1
	if player.current_re_flip != player.max_re_flip: 
		re_flip_button.disabled = false
	if current_turn != Turn.PLAYER:
		return
		
	var state = randi() % 2
	
	if flip_clicks == 1 and has_solar_coin:
		state = 0;
		show_floating_label(player,0,LabelType.SOLAR_COIN)
	if flip_clicks == 2 and has_lunar_coin:
		state = 1;
		show_floating_label(player,0,LabelType.LUNAR_COIN)
	
	player.current_flip += 1
	var coin = COIN.instantiate()
	coin.setup(state,coin_deck.get_vacant_slot(player.current_flip))
	
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
		show_floating_label(player,0,LabelType.LUCKY_PAIR)
	
	if flip_clicks <= 3 and has_triple_nickel:
		coin.upgrade_to_silver()
		show_floating_label(player,0,LabelType.TRIPLE_NICKEL)
	if coin.base_value > 2 and has_coin_snipe:
		enemy.take_damage(1)
		show_floating_label(player,0,LabelType.COIN_SNIPE)
		show_floating_label(enemy,1,LabelType.DAMAGE)
		check_defeat()

	player.take_damage(coin.base_value / 2)
	show_floating_label(player,coin.base_value / 2,LabelType.DAMAGE)
	coin.add_to_group("coins")
	
	
	add_child(coin);
	
	var refund_chance = randf()
	if has_refund and latest_coin != null:
		if latest_coin.state == coin.state and refund_chance <= 0.2:
			player.coin += (latest_coin.base_value / 2) + (coin.base_value / 2)
			player.current_flip -= 2
			show_floating_label(player,0,LabelType.REFUND)
			latest_coin.queue_free()
			coin.queue_free()
			show_floating_label(player,2,LabelType.GAIN)
			coin_calculation()
	
	latest_coin = coin
	coin_count += 1
	
	print(player.current_flip)
	if player.current_flip == player.max_flip or player.coin == 1:
		flip_button.disabled = true
	coin_calculation()
	check_defeat()
	

func enemy_flip():
	
	var state = randi() % 2
	enemy.current_flip += 1
	enemy.take_damage(1)
	show_floating_label(enemy,1,LabelType.DAMAGE)
	var coin = COIN.instantiate()
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

	enemy_coin_calculation()
	check_defeat()
	

func check_defeat():
	if player.coin <= 0:
		if has_payback:
			if payback_used:
				game_over_ui.visible = true
		else:
			game_over_ui.visible = true
		return true
		
	if enemy.coin <= 0:
		game_over_ui.visible = true
		return false
	
	return null


func _on_re_flip_pressed():
	print("REFLIP")
	if has_advanced_planning: show_floating_label(player,0,LabelType.ADVANCED_PLANNING)
	player.current_re_flip += 1
	var index = 0
	var coins = get_tree().get_nodes_in_group("coins")
	var loyalty_chance = randf()
	var loyalty_success = false
	if loyalty_chance <= 0.2 and has_loyalty_contract:
		loyalty_success = true
		show_floating_label(player,0,LabelType.LOYALTY_CONTRACT)
	for coin in coins:
		index += 1
		if index <= 2 and has_advanced_planning:
			pass
		else:
			if has_inflation:
				coin.re_flip()
				var upgrade_chance = randf()
				if upgrade_chance <= 0.1:
					show_floating_label(player,0,LabelType.INFLATION)
					coin.upgrade()
			if has_loyalty_contract and loyalty_success:
				player.coin += coin.base_value / 2
				coin.remove_from_group("coins")
				coin.queue_free()
				player.current_flip -= 1
				flip_button.disabled = false
				re_flip_button.disabled = true
				coin_calculation()
				
			else:
				coin.re_flip()
	
	if player.current_re_flip == player.max_re_flip:
		re_flip_button.disabled = true
	coin_calculation()

func coin_calculation():
	var is_left = true # true - Left Coin, false - Right Coin
	var left_coin
	var right_coin
	damage = 0
	gain = 0
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if is_left == true:
			left_coin = coin
		if is_left == false:
			right_coin = coin
		
		if left_coin != null and right_coin != null:
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
	if (damage != 0 or gain != 0) and coins != null:
		var text = "DMG: " + str(damage) + " GAIN: " + str(gain)
		turn_calculation.text = text
		turn_calculation.add_theme_color_override("font_color", Color.BLACK)
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
		left_coin.global_position = coin_deck.get_reserve_slot()
		reserved_coin = left_coin

func update_player_coin():
	player_health_bar.value = player.coin
	player_health_label.text = "Coins: " + str(player.coin)
	
func update_enemy_coin():
	enemy_health_bar.value = enemy.coin
	enemy_health_label.text = "Coins: " + str(enemy.coin)

func enemy_coin_calculation():
	print("Calculating DMG and Gain of Enemy")
	damage = 0
	gain = 0
	var type = enemy.type
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	match type:
		Enemy.MAGE:
			for coin in coins:
				if coin.state == 0: damage += 2
		Enemy.DWARF:
			var can_attack = true
			var coin_count = 0
			for coin in coins:
				coin_count += 1
				if coin.state == 1: can_attack = false
			if can_attack and coin_count == 2: damage += 4
	if damage != 0 or gain != 0:
		var text = "DMG: " + str(damage) + " GAIN: " + str(gain)
		turn_calculation.text = text
		turn_calculation.add_theme_color_override("font_color", Color.DARK_RED)


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
	LOYALTY_CONTRACT,
	TRIPLE_NICKEL,
	REFUND,
	COIN_SNIPE,
	ACTIVE_INCOME,
	POCKET_MONEY,
	PASSIVE_INCOME,
	SIMPLE_INTEREST
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
			label.text = "COIN SNIPE: 1 DMG"
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
		LabelType.LOYALTY_CONTRACT:
			label.text = "LOYALTY CONTRACT: All Coins Retrieved" 
			label.add_theme_color_override("font_color",Color.SLATE_GRAY)
			label.add_theme_font_size_override("font_size",22)
		LabelType.SIMPLE_INTEREST:
			label.text = "SIMPLE INTEREST: Enemy Bounty +50%"
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
		label.global_position.x += 70
		label.global_position.y += 120
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
