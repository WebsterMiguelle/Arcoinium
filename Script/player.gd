extends Node2D

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

signal hp_changed(new_hp)
@onready var player_portrait: AnimatedSprite2D = $Player_Portrait

#SCENES
const COIN = preload("uid://ddet242jm5v23")
var main
@onready var particle_manager: Node2D = $"../ParticleManager"

#SOUNDS
const COIN_FLIP = preload("uid://bmscttmxwr782")
const COIN_REFLIP = preload("uid://qtxsmuntihe3")
const COIN_UPGRADE = preload("uid://c2sojoo67g7sq")
const COIN_ENDTURN = preload("uid://bfruqunt0uyuj")
const DAMAGE_LIGHT = preload("uid://ds0jngoq17iij")
const DAMAGE_MODERATE = preload("uid://b2rf2iy046cx2")
const DAMAGE_HEAVY = preload("uid://b8us2t16pmggo")
const PASSIVE_COIN_SNIPE = preload("uid://b0rkegpstg6g4")
const PASSIVE_REFUND = preload("uid://bubbbm2g4luge")
const PASSIVE_SPARE_CHANGE = preload("uid://dc4ftba55c4w8")
const PASSIVE_JAR_O_SAVINGS = preload("uid://ctageqytkfmgg")
const DEBT = preload("uid://cuwgygacdm7dj")
const PASSIVE_PAYBACK = preload("uid://bbsxs62yhirxa")

const COIN_ATTACK_PARTICLE = preload("uid://djmpd27qq4nn1")
const THRIFT = preload("uid://b34wg18n8eb0t")
const THRIFT_FLAME = preload("uid://kld7c6qpdho7")


#PARTICLES
const SINGLE_DAMAGE_PARTICLE = preload("uid://dgeahqxig4fqa")
const DAMAGE_PARTICLE = preload("uid://q4hytnmn2fbt")
const COIN_PLAY_PARTICLE = preload("uid://w5jgphq268vx")
const COIN_ADD_PARTICLE = preload("uid://s6va71jul34t")
const THRIFT_PARTICLE = preload("uid://b5x6b2q8jvqa5")


#PLAYER STATS
var max_coin = 1000 #Max Coin Capacity
var max_reserve = 6
var current_reserve = 0
var coin = 100:
	set(value):
		coin = clamp(value,0,max_coin)
		hp_changed.emit(coin)
var initial_max_playable_coins
var max_playable_coins: = 16 #Max Flips Per Turn
var current_played_coin: = 0: #Current Flip Count
	set(value):
		current_played_coin = clamp(value,0,max_playable_coins)
var max_re_flip = 6 #Max Re-Flips Per Turn
var current_re_flip = 0: #Current Re-Flip Count
	set(value):
		current_re_flip = clamp(value,0,max_re_flip)
var silver_flip_rate = 0.1: #Chance to Flip a Silver Coin
	set(value): 
		silver_flip_rate = clamp(value,0.0,100.0) 
var gold_flip_rate = 0.05: #Chance to Flip a Gold Coin
	set(value): 
		gold_flip_rate = clamp(value,0.0,100.0) 

#STATUS EFFECTS

var gain = 0: #Coin to be gained next turn
	set(value):
		gain = clamp(value,0,1000) 
var debt = 0: #Gain Blocked
	set(value):
		debt = clamp(value,0,1000) 
var thrift = 0: #Reduced Playable Coins
	set(value):
		thrift = clamp(value,0,16) 

#PASSIVES

#Passive Specific Variables
var flip_clicks = 0
var latest_coin = null
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
var has_extra_turn = false
var extra_turn_penalty = 1

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

#BANKER PASSIVES

@export var has_cash_out = true
@export var has_dividend = true
@export var has_withdraw = true
@export var has_deposit = true

#ENEMY PASSIVES

var has_value_added_tax = false
var has_fair_trade = false
var has_learn_to_save = false
var has_fully_paid = false
var has_sunlit_curse = false
var has_midnight_curse = false
var has_dusk_stance = false

var reflip_tween: Tween
var base_reflip_scale: Vector2
	
func setup(m):
	main = m
	base_reflip_scale = main.reflip_sprite.scale
func take_damage(amount):
	coin -= amount
	print("Player HP: ", coin)

func gain_coin():
	var temp = gain
	gain -= debt
	debt -= temp
	coin += gain
	gain = 0
	print("Player HP: ", coin)

func reset_stats():
	max_coin = 500 #Max Coin Capacity
	max_reserve = 4
	current_reserve = 0
	coin = 100
	max_playable_coins = 16 #Max Flips Per Turn
	current_played_coin = 0 #Current Flip Count
	max_re_flip = 3 #Max Re-Flips Per Turn
	current_re_flip = 0 #Current Re-Flip Count
	silver_flip_rate = 0.1 #Chance to Flip a Silver Coin 
	gold_flip_rate = 0.05 #Chance to Flip a Gold Coin

	#B-Rank
	has_wishbone = false
	has_golden_clover = false
	has_solar_coin = false
	has_lunar_coin = false
	has_merchant_scroll = false
	has_impromptu_flip = false
	has_advanced_planning = false

	#A-Rank
	has_magic_trick = false
	has_sleight_of_hand = false
	has_piggy = false

	#INNOVATOR PASSIVES

	has_inflation = false
	has_payback = false
	has_lucky_pair = false
	has_value_increase = false

	#SHOOTER PASSIVES

	has_spare_change = false
	has_triple_nickel = false
	has_refund = false
	has_coin_snipe = false

	#INVESTOR PASSIVES

	has_active_income = true
	has_pocket_money = true
	has_passive_income = true
	has_simple_interest = true

	#DEBTOR PASSIVES

	has_pay_down = false
	has_reimbursement = false
	has_loan_shark = false
	has_lending_charge = false

	has_cash_out = false
	has_dividend = false
	has_withdraw = false
	has_deposit = false

func refresh_start_of_battle_stats():
	has_extra_turn = false
	extra_turn_penalty = 1
	gain = 0
	debt = 0
	thrift = 0
	max_playable_coins = 16
	current_played_coin = 0
	current_reserve = 0
	latest_pair_left_coin = null
	latest_pair_right_coin = null
	latest_coin = null
	has_value_added_tax = false
	has_fair_trade = false
	has_learn_to_save = false
	has_fully_paid = false
	has_sunlit_curse = false
	has_midnight_curse = false
	has_dusk_stance = false
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	player_portrait.play("default")

func coin_calculation():
	var is_left = true # true - Left Coin, false - Right Coin
	var left_coin
	var right_coin
	var total_damage = 0
	var total_gain = 0
	var total_debt = 0
	var total_thrift = 0
	sun_count = 0
	moon_count = 0
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
				total_damage += (left_coin.base_value + right_coin.base_value)
			# 2. TAIL-TAIL PAIR
			elif left_coin.state == 1 and right_coin.state == 1:
				total_gain += (left_coin.base_value + right_coin.base_value)
			# 3. HEAD-TAIL PAIR
			elif left_coin.state == 0 and right_coin.state == 1:
				total_damage += (left_coin.base_value / 2)
				total_gain += (right_coin.base_value / 2)
				if has_lending_charge: total_debt += 3
			else:
				total_damage += (right_coin.base_value / 2)
				total_gain += (left_coin.base_value / 2)
				if has_lending_charge: total_debt += 3
			left_coin = null
			right_coin = null
		else:
			pass
		is_left = !is_left
	if has_active_income:
		total_thrift += (total_gain / 10) * 2
	var text = ""
	if coins != null:
		if total_damage != 0: 
			text += "\nDMG: " + str(total_damage)
		if total_gain != 0:
			text += "\nGAIN: " + str(total_gain)
		if total_debt != 0:
			text += "\nDEBT: " + str(total_debt)
		if total_thrift != 0:
			text += "\nTHRIFT: " + str(total_thrift)
		main.turn_calculation.text = text
		main.turn_calculation.add_theme_color_override("font_color", Color.WHITE)
	else: 
		main.turn_calculation.text = ""
	if text != "":
		main.turn_calculation_box.entrance(true)
	return [total_damage,total_gain,total_debt,total_thrift]

func flip():
	var is_deck_full = false
	main.sound_manager.play_sound(COIN_FLIP)
	print("FLIP")
	flip_clicks += 1
	if current_re_flip != max_re_flip: 
		toggle_button(main.re_flip_button,false)
		
	var state = randi() % 2
	
	if has_sunlit_curse:
		state = 0
	if has_midnight_curse:
		state = 1
		
	if (flip_clicks == 1 or flip_clicks == 3) and has_solar_coin:
		state = 0;
	if (flip_clicks == 2 or flip_clicks == 4) and has_lunar_coin:
		state = 1;
	
	if current_played_coin == max_playable_coins: is_deck_full = true	
	current_played_coin += 1
	var c = COIN.instantiate()
	if is_deck_full:
		c.setup(state,main.coin_deck.get_reserve_slot())
		c.reserved = true
		current_reserve += 1
		c.add_to_group("reserved coins")
	else:
		c.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
		c.add_to_group("coins")

	#Silver/Gold Flip Rate
	
	var upgrade_chance = randf()

	if upgrade_chance <= silver_flip_rate:
		c.upgrade_to_silver()
		
	upgrade_chance = randf() 
	if upgrade_chance <= gold_flip_rate:
		c.upgrade_to_gold()
	
	if has_lucky_pair and (flip_clicks == 7 or flip_clicks == 8):
		c.upgrade()
		
	
	if flip_clicks <= 3 and has_triple_nickel:
		c.upgrade_to_silver()
		
	if c.base_value > 2:
		main.sound_manager.play_sound(COIN_UPGRADE)
		if has_coin_snipe:
			main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
			main.enemy.take_damage(1)

	take_damage(1)
	add_child(c)
	if has_reimbursement:
		var debt_chance = randf()
		if debt_chance <= 0.3: main.enemy.debt += 1
	if c.reserved == false:
		latest_coin = c
		main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,latest_coin.global_position)

	print(current_played_coin)
	if (current_played_coin == max_playable_coins and current_reserve == max_reserve) or coin == 1:
		toggle_button(main.flip_button,true)
	coin_calculation()
	main.check_defeat()

func re_flip():

	main.sound_manager.play_sound(COIN_REFLIP)
	main.sound_manager.play_sound(COIN_FLIP)
	
	if reflip_tween:
		reflip_tween.kill()
	reflip_tween = create_tween()
	var swelled_scale: Vector2 = base_reflip_scale * 1.2 
	
	reflip_tween.tween_property(main.reflip_sprite, "scale", swelled_scale, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	reflip_tween.tween_property(main.reflip_sprite, "scale", base_reflip_scale, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	current_re_flip += 1
	main.reflip_label.text = str(max_re_flip - current_re_flip)
	var coins = get_tree().get_nodes_in_group("coins")
	var index = 0
	var refund_chance = randf()
	if has_refund and refund_chance <= 0.2:
		main.sound_manager.play_sound(PASSIVE_REFUND)
		current_re_flip = 0
	for c in coins:
		if !c.reserved:
			index += 1
		if index <= 2 and has_advanced_planning:
			pass
		else:
			if has_inflation:
				var upgrade_chance = randf()
				if upgrade_chance <= 0.3:
					c.upgrade()
				c.re_flip()
			if has_refund and refund_chance <= 0.1:
				coin += 1
				current_played_coin -= 1
				c.queue_free()
				toggle_button(main.flip_button,false)
			else:
				c.re_flip()
	if has_spare_change:
		main.sound_manager.play_sound(PASSIVE_SPARE_CHANGE)
		var reserved_coins = get_tree().get_nodes_in_group("reserved coins")
		for c in reserved_coins:
			coin += 1
			c.queue_free()
			toggle_button(main.flip_button,false)
			current_reserve -= 1
			
	if has_reimbursement:
		var debt_chance = randf()
		if debt_chance <= 0.5: main.enemy.debt += 1
		
	if current_re_flip == max_re_flip or current_played_coin == 0:
		toggle_button(main.re_flip_button,true)

	await get_tree().create_timer(0.1).timeout
	coin_calculation()
	
	
func start_turn():
	player_turn_count += 1
	
	#Initialize Global Stats
	flip_clicks = 0
	latest_coin = null
	current_played_coin = 0
	
	if thrift != 0:
		main.sound_manager.play_sound(THRIFT_FLAME)
		var index = 16
		var current_thrift = thrift
		while current_thrift != 0:
			var pos = main.coin_deck.get_vacant_slot(index)
			var global_pos = Vector2(pos[0],pos[1])
			particle_manager.spawn_emitting_particle(THRIFT_PARTICLE,global_pos)
			index -= 1
			current_thrift -= 1
	#THRIFT
	initial_max_playable_coins = max_playable_coins
	max_playable_coins -= thrift

	
	#Coin Gain Triggers

	if player_turn_count != 1:
		gain_coin()

	#Reset Player Stats
	current_played_coin = 0
	current_re_flip = 0
	latest_coin = null
	main.coin_deck.reset_sigils()

	toggle_button(main.flip_button,false)
	if current_played_coin == 0:
		toggle_button(main.re_flip_button,true)
		main.turn_calculation.text = ""
	
	#Activate Turn Start Passives
	await activate_player_turn_start_passives()
	
	main.reflip_label.text = str(max_re_flip - current_re_flip)
	current_reserve = 0
	
	if player_turn_count != 1:
		#Check Coin Reserve
		var coins = get_tree().get_nodes_in_group("reserved coins")
		var dividend_chance
		var has_withdraw_damage = false
		var is_deck_full = false
		for coin in coins:
			if coin.reserved:
				toggle_button(main.re_flip_button,false)
				var pos
				if current_played_coin == max_playable_coins: is_deck_full = true
				if is_deck_full:
					pos = main.coin_deck.get_reserve_slot()
					current_reserve += 1
				else:
					current_played_coin += 1
					pos = main.coin_deck.get_vacant_slot(current_played_coin)
					coin.global_position.x = pos[0]
					coin.global_position.y = pos[1]
					coin.reserved = false
				if has_value_increase:
					coin.upgrade()
				latest_coin = COIN.instantiate()
				latest_coin.setup(coin.state,pos)
				latest_coin.copy_coin(coin)
				coin.queue_free()
				latest_coin.add_to_group("coins")
				add_child(latest_coin)
				
				dividend_chance = randf()
				if has_dividend and dividend_chance <= 0.3:
					if current_played_coin == max_playable_coins: is_deck_full = true
					if is_deck_full:
						pos = main.coin_deck.get_reserve_slot()
						current_reserve += 1
					else:
						current_played_coin += 1
						pos = main.coin_deck.get_vacant_slot(current_played_coin)
						coin.global_position.x = pos[0]
						coin.global_position.y = pos[1]
						coin.reserved = false
					var dividend_coin = COIN.instantiate()
					dividend_coin.setup(latest_coin.state,pos)
					dividend_coin.copy_coin(latest_coin)
					dividend_coin.add_to_group("coins")
					add_child(dividend_coin)
					if has_simple_interest: gain += 1
					if has_withdraw:
						main.enemy.take_damage(2)
						has_withdraw_damage = true
	
					
				if has_simple_interest: gain += 1
				if has_withdraw: 
					main.enemy.take_damage(2)
					has_withdraw_damage = true
				latest_coin.refresh_sprite()
				if current_played_coin > 1:
					coin_calculation()
		if has_withdraw_damage:
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(DAMAGE_MODERATE)	
				#reserved_coin.queue_free()
	if coin == 1:
		toggle_button(main.flip_button,true)

func end_turn():
	toggle_button(main.re_flip_button,true)
	main.endTurn_button.disabled = true
	main.coin_deck.sigil_pressed();
	previous_player_flips = current_played_coin
	

	

	#Activate End Turn Passives
	await activate_player_turn_end_passives()

	
	main.sound_manager.play_sound(COIN_ENDTURN)
	
	var calculations = coin_calculation()
	print(calculations)
	var turn_damage = calculations[0]
	var turn_gain = calculations[1]
	var turn_debt = calculations[2]
	var turn_thrift = calculations[3]
	previous_player_gain = 0
	
	if turn_damage > 0:
		main.sound_manager.play_sound(COIN_ATTACK_PARTICLE)
		particle_manager.play_attack_animation(main.coin_deck, main.enemy_portrait, turn_damage)
		main.turn_calculation_box.exit()
		await get_tree().create_timer(1.0).timeout

	thrift = 0
	particle_manager.despawn_emitting_particles()

	main.reserve_left_over_coin()
	main.enemy.take_damage(turn_damage)
	if turn_damage == 0: pass
	elif turn_damage <= 10: main.sound_manager.play_sound(DAMAGE_LIGHT)
	elif turn_damage <= 20: main.sound_manager.play_sound(DAMAGE_MODERATE)
	else: main.sound_manager.play_sound(DAMAGE_HEAVY)
	previous_player_gain = turn_gain
	if turn_damage != 0: 
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
	gain += turn_gain
	if turn_debt != 0: 
		main.sound_manager.play_sound(DEBT)
		main.enemy.debt += turn_debt
	if turn_thrift != 0:
		main.enemy.thrift += turn_thrift
		main.sound_manager.play_sound(THRIFT)
		
	if main.enemy.type == Enemy.TWILIGHT_SAGE:
		if has_dusk_stance:
			main.enemy.gain += moon_count * 3
		else:
			main.enemy_portrait_sprite.play("TWILIGHT_SAGE_DAWN")
			debt += sun_count * 3

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
			main.particle_manager.spawn_particle(COIN_PLAY_PARTICLE,coin.global_position)
			coin.queue_free()
	
	main.total_damage_dealt += turn_damage
	if turn_damage > main.highest_damage_dealt:
		main.highest_damage_dealt = turn_damage
		
	main.total_gain += turn_gain
	if turn_gain > main.highest_gain:
		main.highest_gain = turn_gain

	
	if main.enemy.coin > 0 and has_cash_out and current_played_coin == max_playable_coins and current_reserve == max_reserve:
		has_extra_turn = true
	max_playable_coins = initial_max_playable_coins
	
func activate_pre_battle_passives():
	if has_value_added_tax:
		debt += 5
	passive_income_used = false
	payback_used = false
	payback_coins = 12
	pocket_money_coins = 8
	current_played_coin = 0
	if has_pocket_money:
		main.sound_manager.play_sound(COIN_FLIP)
		while pocket_money_coins != -1:
			var state = 1
			current_played_coin += 1
			var c = COIN.instantiate()
			print("POCKET MONEY: " + str(pocket_money_coins))
			c.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
			
			#Guaranteed Silver Flips
			
			c.upgrade_to_silver()
			c.add_to_group("coins")
			latest_coin = c
			main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,latest_coin.global_position)
			add_child(c);
			
			
			if (current_played_coin == max_playable_coins and current_reserve == max_reserve) or coin == 1:
				toggle_button(main.flip_button,true)
			coin_calculation()
			pocket_money_coins -= 1
			await get_tree().create_timer(0.1).timeout
		main.endTurn_button.disabled = false
		toggle_button(main.re_flip_button,false)

func activate_player_turn_start_passives():
	previous_player_flips = 0
	if payback_used and payback_coins != 0:
		payback_coins = 12
		main.endTurn_button.disabled = true
		toggle_button(main.re_flip_button,true)
		print("PAYBACK: " + str(payback_coins))
		main.sound_manager.play_sound(PASSIVE_PAYBACK)
		var is_deck_full = false
		while payback_coins != 0:
				
			var state = 0
			if current_played_coin == max_playable_coins: is_deck_full = true	
			current_played_coin += 1
			var c = COIN.instantiate()
			if is_deck_full:
				c.setup(state,main.coin_deck.get_reserve_slot())
				c.reserved = true
				current_reserve += 1
				c.add_to_group("reserved coins")
			else:
				c.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
				c.upgrade_to_gold()
				c.add_to_group("coins")

			#Guaranteed Silver Flips
			

			add_child(c);
			
			latest_coin = c

			main.sound_manager.play_sound(COIN_FLIP)
			main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,c.global_position)
			if (current_played_coin == max_playable_coins and current_reserve == max_reserve) or coin == 1:
				toggle_button(main.flip_button,true)
			coin_calculation()
			payback_coins -= 1
			await get_tree().create_timer(0.2).timeout
			latest_coin = coin
		main.endTurn_button.disabled = false
		toggle_button(main.re_flip_button,false)

	#Piggy Passive
	if latest_pair_left_coin != null and latest_pair_right_coin != null:
		var left_coin = COIN.instantiate()
		var pos
		current_played_coin += 1
		if current_played_coin >= max_playable_coins:
			pos = main.coin_deck.get_reserve_slot()
			left_coin.reserved = true
			current_reserve += 1
		else:
			pos = main.coin_deck.get_vacant_slot(current_played_coin)
			left_coin.reserved = false
		toggle_button(main.re_flip_button,false)
		left_coin.setup(latest_pair_left_coin.state,pos)
		left_coin.copy_coin(latest_pair_left_coin)
		left_coin.reserved = false
		left_coin.add_to_group("coins")
		add_child(left_coin);
		main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,left_coin.global_position)
		
		var right_coin = COIN.instantiate()
		current_played_coin += 1
		if current_played_coin >= max_playable_coins:
			pos = main.coin_deck.get_reserve_slot()
			right_coin.reserved = true
			current_reserve += 1
		else:
			pos = main.coin_deck.get_vacant_slot(current_played_coin)
			right_coin.reserved = false
		toggle_button(main.re_flip_button,false)
		right_coin.setup(latest_pair_right_coin.state,pos)
		right_coin.copy_coin(latest_pair_right_coin)
		right_coin.reserved = false
		right_coin.add_to_group("coins")
		add_child(right_coin);
		latest_coin = right_coin
		main.sound_manager.play_sound(COIN_FLIP)
		main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,right_coin.global_position)
	latest_pair_left_coin = null
	latest_pair_right_coin = null

		

func activate_player_turn_end_passives():
	main.endTurn_button.disabled = true
	if has_impromptu_flip and latest_coin != null:
		if latest_coin.state == 0:
			latest_coin.state = 1
		else:
			latest_coin.state = 0
		latest_coin.upgrade()
		latest_coin.refresh_sprite()
		main.sound_manager.play_sound(COIN_FLIP)
		coin_calculation()
		await get_tree().create_timer(0.6).timeout

	if has_advanced_planning:
		var coins = get_tree().get_nodes_in_group("coins")
		var index = 0
		for coin in coins:
			index += 1
			if index == 1 or index == 2:
				coin.upgrade()
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
		await get_tree().create_timer(0.6).timeout
		
	if has_magic_trick and current_played_coin >= 8:
		var coins = get_tree().get_nodes_in_group("coins")
		var index = 0
		var first_coin = null
		var second_coin = null
		for coin in coins:
			index += 1
			print("Checking Coin: " + str(index))
			if index == 1: first_coin = coin
			if index == 2: second_coin = coin
			if index == 3 or index == 5 or index == 7:
				coin.copy_coin(first_coin)
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
			if index == 4 or index == 6 or index == 8:
				coin.copy_coin(second_coin)
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
		coin_calculation()
		await get_tree().create_timer(1.0).timeout

func extra_turn():
	main.show_turn_ui("EXTRA TURN")
	extra_turn_penalty = 1
	start_turn()
	toggle_button(main.flip_button,true)
	current_re_flip = 0
	toggle_button(main.re_flip_button,true)
	
func toggle_button(btn: Button, make_disabled: bool) -> void:
	btn.disabled = make_disabled
	
	if make_disabled:
		btn.modulate = Color(0.5, 0.5, 0.5, 1.0) # Darken to 50%
		
		# NEW: If the button has a lifted coin, force it to drop!
		if "lifted_slot" in btn and btn.lifted_slot != null:
			btn._on_mouse_exited()
			
	else:
		btn.modulate = Color(1.0, 1.0, 1.0, 1.0) # Restore to normal brightness
