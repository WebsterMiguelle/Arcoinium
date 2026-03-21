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
@onready var reward_manager = $CardManager
@onready var shop_manager = $ShopManager

#COIN
const COIN = preload("uid://ddet242jm5v23")

#CALCULATIONS
var damage = 0
var gain = 0
var debt = 0
var reserved_coin = null
var current_turn = Turn.PLAYER


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
#GENERAL PASSIVES
#B-Rank
@export var has_wishbone = false
@export var has_golden_clover = false
@export var has_solar_coin = false
@export var has_lunar_coin = false
@export var has_merchant_scroll = false
@export var has_impromptu_flip = false
@export var has_advanced_planning = false
@export var has_magic_trick = false
@export var has_sleight_of_hand = false


# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_ui.visible = false
	turn_ui.visible = false
	battle_start()
	print(reward_manager)
		
	if not flip_button.pressed.is_connected(_on_flip_pressed):
		flip_button.pressed.connect(_on_flip_pressed)
	if not endTurn_button.pressed.is_connected(_on_endturn_pressed):
		endTurn_button.pressed.connect(_on_endturn_pressed)
	if not re_flip_button.pressed.is_connected(_on_re_flip_pressed):
		re_flip_button.pressed.connect(_on_re_flip_pressed)      
	battle_start()
	
	
func battle_start():
	randomize()
	var enemy_id = randi() % 2
	match enemy_id:
		0: 
			enemy.setup(Enemy.MAGE)
			current_enemy_type = Enemy.MAGE
		1: 
			enemy.setup(Enemy.DWARF)
			current_enemy_type = Enemy.DWARF
	
	update_enemy_coin()
	update_player_coin()
	show_turn_ui("BATTLE START")
	
	#Battle Start Passives
	
	if has_wishbone: show_floating_label(player,0,LabelType.WISH_BONE) 
	if has_golden_clover: show_floating_label(player,0,LabelType.GOLDEN_CLOVER) 
	if has_sleight_of_hand: show_floating_label(player,0,LabelType.SLEIGHT_OF_HAND) 
	start_player_turn()

func show_turn_ui(text):
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
	player.current_flip = 0
	player.current_re_flip = 0

	current_turn = Turn.PLAYER
	flip_button.disabled = false
	re_flip_button.disabled = true
	endTurn_button.disabled = false
	turn_calculation.text = ""
	
	#Check Coin Reserve

	if reserved_coin != null:
		var coin = COIN.instantiate()
		player.current_flip += 1
		re_flip_button.disabled = false
		coin.setup(reserved_coin.state,coin_deck.get_vacant_slot(player.current_flip))
		coin.copy_coin(reserved_coin)
		coin.reserved = false
		coin.add_to_group("coins")
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
	endTurn_button.disabled = true
	
	#FLIP COINS
	await get_tree().create_timer(1.0).timeout
	while enemy.current_flip != enemy.max_flip:
		enemy_flip()
		await get_tree().create_timer(0.4).timeout
	await get_tree().create_timer(1.0).timeout
	
	end_enemy_turn()

func end_enemy_turn():
	player.take_damage(damage)
	if damage != 0: show_floating_label(player,damage,LabelType.DAMAGE)
	enemy.gain += gain
	if gain != 0: show_floating_label(enemy,gain,LabelType.TO_GAIN)
	var defeat = check_defeat()
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	for coin in coins:
		coin.queue_free()
	if defeat == null:
		await get_tree().create_timer(0.4).timeout
		show_turn_ui("Player Turn")
		start_player_turn()

func _on_endturn_pressed():
	
	#Activate End Turn Passives
	if has_impromptu_flip:
		show_floating_label(player,0,LabelType.IMPROMPTU_FLIP)
		if has_impromptu_flip and latest_coin != null:
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

	enemy.take_damage(damage)
	if damage != 0: show_floating_label(enemy,damage,LabelType.DAMAGE)
	player.gain += gain
	if gain != 0: show_floating_label(player,gain,LabelType.TO_GAIN)
	reserve_left_over_coin()
	var defeat = check_defeat()
	if defeat == null:
		if current_turn == Turn.PLAYER:
			start_enemy_turn()
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
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
	player.take_damage(1)
	show_floating_label(player,1,LabelType.DAMAGE)
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
	
	coin.add_to_group("coins")
	add_child(coin);
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
	
func trigger_game_over(player_won: bool):
	
	if player_won:
		reward_manager.show_rewards()
		shop_manager.show_shop(player)
	
	game_over_ui.visible = true
	
	flip_button.disabled = true
	re_flip_button.disabled = true
	endTurn_button.disabled = true
	
	
	set_process(false)
	
	var result_label = game_over_ui.get_node("ColorRect/Gameover")
	var enemy_label = game_over_ui.get_node("ColorRect/EnemyLabel")
	
	
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

func check_defeat():
	if player.coin <= 0:
		trigger_game_over(false)
		return true
		
	if enemy.coin <= 0:
		trigger_game_over(true)
		return false
	
	return null


func _on_re_flip_pressed():
	print("REFLIP")
	if has_advanced_planning: show_floating_label(player,0,LabelType.ADVANCED_PLANNING)
	player.current_re_flip += 1
	var index = 0
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		index += 1
		if index <= 3 and has_advanced_planning:
			pass
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
	if damage != 0 or gain != 0:
		var text = "DMG: " + str(damage) + " GAIN: " + str(gain)
		turn_calculation.text = text
		turn_calculation.add_theme_color_override("font_color", Color.BLACK)

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
	SLEIGHT_OF_HAND
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
			label.text = "+" + str(value) + " GAIN"
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
			label.add_theme_color_override("font_color",Color.SILVER)
			label.add_theme_font_size_override("font_size",22)
		LabelType.GOLDEN_CLOVER:
			label.text = "GOLDEN CLOVER: +5% Gold Flip Rate"
			label.add_theme_color_override("font_color",Color.DARK_GOLDENROD)
			label.add_theme_font_size_override("font_size",22)
		LabelType.SLEIGHT_OF_HAND:
			label.text = "SLEIGHT OF HAND: +6 Re-Flips"
			label.add_theme_color_override("font_color",Color.DARK_CYAN)
			label.add_theme_font_size_override("font_size",22)
		LabelType.SOLAR_COIN:
			label.text = "SOLAR COIN: Guaranteed Sun"
			label.add_theme_color_override("font_color",Color.ORANGE_RED)
			label.add_theme_font_size_override("font_size",22)
		LabelType.LUNAR_COIN:
			label.text = "LUNAR COIN: Guaranteed Moon"
			label.add_theme_color_override("font_color",Color.NAVY_BLUE)
			label.add_theme_font_size_override("font_size",22)
		LabelType.IMPROMPTU_FLIP:
			label.text = "IMPROMPTU FLIP: Last Coin Re-Flipped"
			label.add_theme_color_override("font_color",Color.CHOCOLATE)
			label.add_theme_font_size_override("font_size",22)
		LabelType.MAGIC_TRICK:
			label.text = "MAGIC TRICK: 1st Pair Duplicated"
			label.add_theme_color_override("font_color",Color.REBECCA_PURPLE)
			label.add_theme_font_size_override("font_size",22)
		LabelType.ADVANCED_PLANNING:
			label.text = "ADVANCED PLANNING: No Re-Flip to First 3 Coins" 
			label.add_theme_color_override("font_color",Color.MEDIUM_PURPLE)
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
		label.global_position.x -= 20
		label.global_position.y += 120
		target_pos = label.global_position.y + 100

	#FURTHER OFFSET
	match type:
		LabelType.TO_GAIN:
			label.global_position.x -= 70
		LabelType.SILVER_FLIP:
			label.global_position.x -= 70
			label.global_position.y -= 70
			target_pos = label.global_position.y - 100
		LabelType.GOLD_FLIP:
			label.global_position.x -= 70
			label.global_position.y -= 100
			target_pos = label.global_position.y - 100
		LabelType.WISH_BONE:
			label.global_position.x -= 100
			label.global_position.y -= 10
			target_pos = label.global_position.y - 100
		LabelType.GOLDEN_CLOVER:
			label.global_position.x -= 100
			label.global_position.y += 20
		LabelType.SLEIGHT_OF_HAND:
			label.global_position.x -= 100
			label.global_position.y -= 50
		LabelType.SOLAR_COIN:
			label.global_position.x -= 100
			label.global_position.y -= 100
			target_pos = label.global_position.y - 50
		LabelType.LUNAR_COIN:
			label.global_position.x -= 100
			label.global_position.y -= 80
			target_pos = label.global_position.y - 50
		LabelType.IMPROMPTU_FLIP:
			label.global_position.x -= 100
			label.global_position.y -= 10
			target_pos = label.global_position.y - 50
		LabelType.MAGIC_TRICK:
			label.global_position.x -= 100
			label.global_position.y -= 10
			target_pos = label.global_position.y - 50
		LabelType.ADVANCED_PLANNING:
			label.global_position.x -= 100
			label.global_position.y -= 10
			target_pos = label.global_position.y - 50
	
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
	


func _on_refresh_pressed() -> void:
	pass # Replace with function body.


func _on_back_pressed() -> void:
	pass # Replace with function body.
