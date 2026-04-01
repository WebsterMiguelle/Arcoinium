#Enemy
extends Node

var main

const COIN = preload("uid://ddet242jm5v23")


#SOUNDS
const COIN_FLIP = preload("uid://bmscttmxwr782")
const COIN_GAIN = preload("uid://c3v64vs2uqtik")
const COIN_ENDTURN = preload("uid://bfruqunt0uyuj")
const DAMAGE_HEAVY = preload("uid://b8us2t16pmggo")
const DAMAGE_LIGHT = preload("uid://ds0jngoq17iij")
const DAMAGE_MODERATE = preload("uid://b2rf2iy046cx2")
const DEBT = preload("uid://cuwgygacdm7dj")
const PASSIVE_LOAN_SHARK = preload("uid://6xxw4avoncr8")
const PASSIVE_PASSIVE_INCOME = preload("uid://cl4xnombcshkv")
const PASSIVE_PAYDOWN = preload("uid://djv3lp0l3aftb")


#PARTICLES
const COIN_ADD_PARTICLE = preload("uid://s6va71jul34t")
const COIN_PLAY_PARTICLE = preload("uid://w5jgphq268vx")
const DAMAGE_PARTICLE = preload("uid://q4hytnmn2fbt")
const SINGLE_DAMAGE_PARTICLE = preload("uid://dgeahqxig4fqa")


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

#ENEMY STATS
var bounty = 0 #Coin Drop on Death
var type #Enemy Type
var max_coin = 0 #Max Coin Capacity
var coin = 0:
	set(value):
		coin = clamp(value,0,max_coin)
var max_playable_coins: = 0: #Max Flips Per Turn
	set(value):
		max_playable_coins = clamp(value,0,16)
var current_played_coin: = 0: #Current Flip Count
	set(value):
		current_played_coin = clamp(value,0,max_playable_coins)
var silver_flip_rate = 0.0: #Chance to Flip a Silver Coin
	set(value): 
		silver_flip_rate = clamp(value,0.0,100.0) 
var gold_flip_rate = 0.00: #Chance to Flip a Gold Coin
	set(value): 
		gold_flip_rate = clamp(value,0.0,100.0) 

#STATUS EFFECTS

var gain = 0: #Coin to be gained next turn
	set(value):
		gain = clamp(value,0,1000) 
var debt = 0: #Gain Blocked
	set(value):
		debt = clamp(value,0,1000) 

func take_damage(amount):
	coin-= amount
	coin = max(coin, 0)
	print("Enemy HP: ", coin)
	

#ENEMY PASSIVES

var has_value_added_tax = false
var has_fair_trade = false
var has_learn_to_save = false
var has_fully_paid = false
var has_sunlit_curse = false
var has_midnight_curse = false
var has_dusk_stance = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_passives():
	has_value_added_tax = false
	has_fair_trade = false
	has_learn_to_save = false
	has_fully_paid = false
	has_sunlit_curse = false
	has_midnight_curse = false
	has_dusk_stance = false

func refresh_start_of_battle_stats():
	gain = 0
	debt = 0

func gain_coin():
	var temp = gain
	gain -= debt
	debt -= temp
	coin += gain
	gain = 0
	print("Player HP: ", coin)

func setup(m,enemy):
	main = m
	print("Hello" + str(enemy))
	match enemy:
		Enemy.MAGE:
			max_coin = 200
			coin = 10
			max_playable_coins = 1
			silver_flip_rate = 0.0
			gold_flip_rate = 0.0
			bounty = 20
			type = Enemy.MAGE
		Enemy.DWARF:
			max_coin = 200
			coin = 12
			max_playable_coins = 2
			silver_flip_rate = 0.0
			gold_flip_rate = 0.0
			bounty = 20
			type = Enemy.DWARF
		Enemy.COLLECTOR:
			max_coin = 200
			coin = 36
			max_playable_coins = 6
			silver_flip_rate = 0.1
			gold_flip_rate = 0.0
			bounty = 40
			type = Enemy.COLLECTOR
			has_value_added_tax = true
			main.player.has_value_added_tax = true
		Enemy.TRADER:
			max_coin = 200
			coin = 40
			max_playable_coins = 2
			silver_flip_rate = 0.05
			gold_flip_rate = 0.0
			bounty = 40
			type = Enemy.TRADER
			has_fair_trade = true
		Enemy.THRIFTER:
			max_coin = 200
			coin = 60
			max_playable_coins = 8
			silver_flip_rate = 0.3
			gold_flip_rate = 0
			bounty = 60
			type = Enemy.THRIFTER
			has_learn_to_save = true
			main.player.has_learn_to_save = true
			main.player.max_playable_coins = 8
		Enemy.ARISTOCRAT:
			max_coin = 200
			coin = 150
			max_playable_coins = 16
			silver_flip_rate = 1
			gold_flip_rate = 0
			bounty = 60
			type = Enemy.ARISTOCRAT
			has_fully_paid = true
			debt = 100
		Enemy.SUN_CASTER:
			max_coin = 200
			coin = 120
			max_playable_coins = 12
			silver_flip_rate = 1
			gold_flip_rate = 0
			bounty = 80
			type = Enemy.SUN_CASTER
			has_sunlit_curse = true
			main.player.has_sunlit_curse = true
		Enemy.MOON_CASTER:
			max_coin = 200
			coin = 100
			max_playable_coins = 12
			silver_flip_rate = 1
			gold_flip_rate = 0
			bounty = 80
			type = Enemy.MOON_CASTER
			has_midnight_curse = true
			main.player.has_midnight_curse = true
		Enemy.TWILIGHT_SAGE:
			max_coin = 200
			coin = 200
			max_playable_coins = 4
			silver_flip_rate = 0
			gold_flip_rate = 1
			bounty = 200
			type = Enemy.TWILIGHT_SAGE
			has_dusk_stance = true

func flip():
	main.sound_manager.play_sound(COIN_FLIP)
	var state = randi() % 2
	
	if type == Enemy.SUN_CASTER and main.player.sun_count >= 9:
		state = 0
	if type == Enemy.MOON_CASTER and main.player.moon_count >= 9:
		state = 1

	take_damage(1)
	

	
	current_played_coin += 1
	var coin = COIN.instantiate()
	coin.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
	
	#Silver/Gold Flip Rate
	
	var upgrade_chance = randf()
	if upgrade_chance <= silver_flip_rate:
		coin.upgrade_to_silver()
	
	upgrade_chance = randf()  
	if upgrade_chance <= gold_flip_rate:
		coin.upgrade_to_gold()

	coin.add_to_group("enemy_coins")
	add_child(coin);
	main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,coin.global_position)

func enemy_coin_calculation():
	print("Calculating DMG and Gain of Enemy")
	var total_damage = 0
	var total_gain = 0
	var total_debt = 0
	var type = type
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	match type:
		Enemy.MAGE:
			for coin in coins:
				if coin.state == 0: total_damage += coin.base_value
		Enemy.DWARF:
			var can_attack = true
			var current_played_coin = 0
			for coin in coins:
				current_played_coin += 1
				if coin.state == 1: 
					can_attack = false
			if can_attack and current_played_coin == 2: total_damage += 4
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
						total_damage += (left_coin.base_value)
						total_gain += (right_coin.base_value)
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
		Enemy.TRADER:
			for coin in coins:
				if coin.state == 0: total_damage += coin.base_value / 2
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
						total_gain += (left_coin.base_value) + (right_coin.base_value)
					if left_coin.state == 0 and right_coin.state == 0:
						total_damage += (left_coin.base_value) + (right_coin.base_value)
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
		Enemy.ARISTOCRAT:
			for coin in coins:
				if coin.state == 1: total_gain += coin.base_value
		Enemy.SUN_CASTER:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if coin.state == 0:
					total_gain += coin.base_value / 2
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin			
				if left_coin != null and right_coin != null:
					if left_coin.state == 0 and right_coin.state == 0:
						total_damage += (left_coin.base_value) + (right_coin.base_value)
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
					total_debt += coin.base_value / 2
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin			
				if left_coin != null and right_coin != null:
					if left_coin.state == 1 and right_coin.state == 1:
						total_damage += left_coin.base_value / 2 + right_coin.base_value / 2 
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
						total_damage += (left_coin.base_value + right_coin.base_value)
					# 2. TAIL-TAIL PAIR
					elif left_coin.state == 1 and right_coin.state == 1:
						total_gain += (left_coin.base_value + right_coin.base_value)
					# 3. HEAD-TAIL PAIR
					elif left_coin.state == 0 and right_coin.state == 1:
						total_damage += (left_coin.base_value / 2)
						total_gain += (right_coin.base_value / 2)
					else:
						total_damage += (right_coin.base_value / 2)
						total_gain += (left_coin.base_value / 2)
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
	if total_damage != 0 or total_debt != 0 or total_gain != 0:
		var text = "DMG: " + str(total_damage) + "\nGAIN: " + str(total_gain) + "\nDEBT: " + str(total_debt)
		main.turn_calculation.text = text
		main.turn_calculation.add_theme_color_override("font_color", Color.ORANGE)
	return [total_damage,total_gain,total_debt]

func start_enemy_turn():
	main.flip_button.disabled = true
	main.re_flip_button.disabled = true
	main.endTurn_button.disabled = true
	
	if type == Enemy.SUN_CASTER:
		if main.player.sun_count >= 9:
			gold_flip_rate = 1
		else:
			gold_flip_rate = 0

	if type == Enemy.MOON_CASTER:
		if main.player.moon_count >= 9:
			gold_flip_rate = 1
		else:
			gold_flip_rate = 0
	

	#Initialize Stats
	var turn_damage = 0
	var turn_gain = 0
	var turn_debt = 0
	var defeat
	
	#Coin Gain Triggers
	gain_coin()
	if has_fully_paid and debt == 0:
		main.player.take_damage(100)
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.player_portrait.global_position)
		defeat = await main.check_defeat()
	if main.player.has_loan_shark and debt > 1:
		var loan_damage = debt / 2
		take_damage(loan_damage)
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		main.sound_manager.play_sound(PASSIVE_LOAN_SHARK)
		defeat = await main.check_defeat()


	#Reset Enemy Stats
	current_played_coin = 0
	
	if has_fair_trade:
		max_playable_coins = main.player.previous_player_flips
		main.player.previous_player_flips = 0
		
	main.turn_calculation.text = ""

	#FLIP COINS
	if defeat == null:
		await get_tree().create_timer(1.0).timeout
		while current_played_coin != max_playable_coins:
			defeat = await main.check_defeat()
			#if coin <= 2:
				#print("Enemy has insufficient coins, ending turn early")
				#break
			if defeat == null:
				flip()
				enemy_coin_calculation()
			else:
				break
			await get_tree().create_timer(0.4).timeout
		await get_tree().create_timer(1.0).timeout
		if defeat == null:
			await end_enemy_turn()

func end_enemy_turn():
	main.coin_deck.sigil_pressed()
	var calculations = enemy_coin_calculation()
	var turn_damage = calculations[0]
	var turn_gain = calculations[1]
	var turn_debt = calculations[2]
	
	if coin == 0:
		turn_damage = 0
		turn_gain = 0
		turn_debt = 0
		main.turn_calculation.text = ""

	if turn_damage != 0: 
		if main.player.has_passive_income and !main.player.passive_income_used:
			main.player.passive_income_used = true
			if turn_damage >= 30:
				turn_damage = 30
			main.player.coin += turn_damage
			main.sound_manager.play_sound(PASSIVE_PASSIVE_INCOME)
		else:
			if turn_damage <= 10: main.sound_manager.play_sound(DAMAGE_LIGHT)
			elif turn_damage <= 20: main.sound_manager.play_sound(DAMAGE_MODERATE)
			else: main.sound_manager.play_sound(DAMAGE_HEAVY)
			main.player.take_damage(turn_damage)
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.player_portrait.global_position)
	if turn_debt != 0:
			main.player.debt += turn_debt
			main.sound_manager.play_sound(DEBT)
	gain += turn_gain
	if main.player.has_pay_down:
		if debt > coin:
			coin = 0
			main.sound_manager.play_sound(PASSIVE_PAYDOWN)
		else:
			debt += 5
		
	var defeat = await main.check_defeat()
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	for coin in coins:
		main.particle_manager.spawn_particle(COIN_PLAY_PARTICLE,coin.global_position)
		coin.queue_free()
	
	#ACTIVATE PAYBACK
	if main.player.has_payback and !main.player.payback_used and defeat: 
		defeat = null
		main.player.coin = 1
		main.player.payback_used = true
		main.player.payback_coins = 12
		
	if defeat == null:
		await get_tree().create_timer(1.0).timeout
		if type == Enemy.TWILIGHT_SAGE:
			if has_dusk_stance == true:
				main.enemy_portrait_sprite.play("TWILIGHT_SAGE_DUSK")
			else:
				main.enemy_portrait_sprite.play("TWILIGHT_SAGE_DAWN")	
			has_dusk_stance = !has_dusk_stance
			max_playable_coins += 4
	
	
	main.coin_deck.sigil_unlight_()
