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

const FLOATING_LABEL = preload("uid://dwf6g2wuj1oe3")
@onready var all_in: Label = $"../Battle UI/All In"
var vignette_default = '#bdabb8'
var vignetter_default = '#ffe6909e'
@onready var sun_moon_count: Label = $"../Battle UI/Turn Calculation Box/Sun Moon Count"

signal hp_changed(new_hp)
@onready var player_portrait: AnimatedSprite2D = $Player_Portrait
var active_temp_ids: Dictionary = {}
@onready var passives_bar: GridContainer = $"../Battle UI/PassivesBar"

#SCENES
const PASSIVE_BAR_ICON = preload("res://Scene/Passive_Bar_Icon.tscn")

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
const JAR_O_SAVINGS = preload("uid://cbg3ofct0pu0j")

const COIN_ATTACK_PARTICLE = preload("uid://djmpd27qq4nn1")
const THRIFT = preload("uid://b34wg18n8eb0t")
const THRIFT_FLAME = preload("uid://kld7c6qpdho7")
const SPEND = preload("uid://bvbtrait4prdi")
const SPENDED_FLIP = preload("uid://dgu0hy8kwo343")
const GAIN_EFFECT = preload("uid://cr366klr6aivy")
const DEBT_EFFECT = preload("uid://d18qgeounkatf")


#PARTICLES
const SINGLE_DAMAGE_PARTICLE = preload("uid://dgeahqxig4fqa")
const DAMAGE_PARTICLE = preload("uid://q4hytnmn2fbt")
const COIN_PLAY_PARTICLE = preload("uid://w5jgphq268vx")
const COIN_ADD_PARTICLE = preload("uid://s6va71jul34t")
const THRIFT_PARTICLE = preload("uid://b5x6b2q8jvqa5")
const GAIN_EFFECT_PARTICLE = preload("uid://c5py6ekby1mnm")
const DEBT_EFFECT_PARTICLE = preload("uid://c52tpyupg2ynl")
const SPEND_EFFECT_PARTICLE = preload("uid://m3n67qiuvr7i")
const SPEND_EXPLOSION_PARTICLE = preload("uid://bgfgq2kw3njao")

#PLAYER STATS
var greed = false
var max_coin = 1000 #Max Coin Capacity
var initial_max_reserve
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
var lock = false #Reserve is Locked
var slow = false #Re-Flip on each Coin only works 50% at a time.
var gain = 0: #Coin to be gained next turn
	set(value):
		gain = clamp(value,0,1000) 
var debt = 0: #Gain Blocked
	set(value):
		debt = clamp(value,0,1000) 
var thrift = 0: #Reduced Playable Coins
	set(value):
		thrift = clamp(value,0,16) 
var spend = 0: #Blocks Coin Flips
	set(value):
		spend = clamp(value,0,1000) 

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
var jar_o_savings_used = false
var jar_o_savings_coins = 16

var previous_player_flips = 0
var player_turn_count = 0
var sun_count = 0
var moon_count = 0
var has_extra_turn = false
var extra_turn_penalty = 1
var thrifted_attack = 0
var debted_attack = 0
var spended_attack = 0
var has_all_in = false

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

@export var has_cash_out = false
@export var has_dividend = false
@export var has_withdraw = false
@export var has_deposit = false

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

func create_floating_label(value,type, ent):
	var label = FLOATING_LABEL.instantiate()
	var pos
	if ent == "PLAYER":
		pos = main.player_portrait.global_position
		#pos = main.tutorial_area.global_position
	else:
		#pos = main.tutorial_area.global_position
		pos = main.enemy_portrait.global_position
	label.setup(value,type,ent,pos)
	add_child(label)
func setup(m):
	main = m
	base_reflip_scale = main.reflip_sprite.scale
func take_damage(amount):
	coin -= amount
	print("Player HP: ", coin)

func gain_coin():
	var temp = gain
	var temp2 = debt
	gain -= debt
	debt -= temp
	coin += gain
	if gain > 0:
		if temp2 != 0 and has_value_added_tax:
			main.enemy.gain += temp2
		particle_manager.spawn_particle(GAIN_EFFECT_PARTICLE,main.player_gain.global_position)
		main.sound_manager.play_sound(GAIN_EFFECT)
		create_floating_label(gain,"GAIN","PLAYER")
	elif debt > 0:
		if has_value_added_tax:
			main.enemy.gain += temp
		particle_manager.spawn_particle(DEBT_EFFECT_PARTICLE,main.player_debt.global_position)
		main.sound_manager.play_sound(DEBT_EFFECT)
	gain = 0
	print("Player HP: ", coin)

func reset_stats():
	greed = PlayerSingleton.greed
	max_coin = 500 #Max Coin Capacity
	max_reserve = 4
	current_reserve = 0
	coin = 15
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

	has_active_income = false
	has_pocket_money = false
	has_passive_income = false
	has_simple_interest = false

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
	initial_max_reserve = max_reserve
	lock = false
	slow = false
	has_all_in = false
	thrifted_attack = 0
	debted_attack = 0
	spended_attack = 0
	has_extra_turn = false
	extra_turn_penalty = 1
	gain = 0
	debt = 0
	thrift = 0
	spend = 0
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
	all_in.text = ""

func coin_calculation():
	var is_left = true # true - Left Coin, false - Right Coin
	var left_coin
	var right_coin
	var total_damage = 0
	var total_gain = 0
	var total_debt = 0
	var total_thrift = 0
	var total_spend = 0
	sun_count = 0
	moon_count = 0
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if has_inflation and coin.base_value > 4:
			total_spend += 1
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
	if thrifted_attack != 0:
		total_thrift += thrifted_attack
	if debted_attack != 0:
		total_debt += debted_attack	
	var text = ""
	if coins != null:
		if total_damage != 0: 
			text += "\nDAMAGE: " + str(total_damage)
		if total_gain != 0:
			text += "\nGAIN: " + str(total_gain)
		if total_debt != 0:
			text += "\nDEBT: " + str(total_debt)
		if total_thrift != 0:
			text += "\nTHRIFT: " + str(total_thrift)
		if total_spend != 0:
			text += "\nSPEND: " + str(total_spend)
		main.turn_calculation.text = text
		main.turn_calculation.add_theme_color_override("font_color", Color.WHITE)
	else: 
		main.turn_calculation.text = ""
	if text != "":
		sun_moon_count.text = "𖤓 " + str(sun_count) + " ☾ " + str(moon_count)
		main.turn_calculation_box.entrance(true)
	return [total_damage,total_gain,total_debt,total_thrift, total_spend]

func flip():
	
	var is_deck_full = false
	print("FLIP")
	flip_clicks += 1
	if current_re_flip != max_re_flip: 
		toggle_button(main.re_flip_button,false)
		
	var state = randi() % 2
	
	if greed and has_sunlit_curse: state = 0
	if greed and has_midnight_curse: state = 1

	if (flip_clicks == 1 or flip_clicks == 3) and has_solar_coin:
		state = 0;
		trigger_temp_passive("solar_coin","SOLAR COIN")
	if (flip_clicks == 2 or flip_clicks == 4) and has_lunar_coin:
		state = 1;
		trigger_temp_passive("lunar_coin","LUNAR COIN")
	
	if current_played_coin == max_playable_coins: is_deck_full = true	
	current_played_coin += 1
	var c = COIN.instantiate()
	if is_deck_full:
		if lock: return
		c.setup(state,main.coin_deck.get_reserve_slot())
		c.reserved = true
		current_reserve += 1
		c.add_to_group("reserved coins")
	else:
		c.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
		c.add_to_group("coins")
	main.sound_manager.play_sound(COIN_FLIP)
	#Silver/Gold Flip Rate
	
	var upgrade_chance = randf()

	if upgrade_chance <= silver_flip_rate:
		c.upgrade_to_silver()
		
	upgrade_chance = randf() 
	if upgrade_chance <= gold_flip_rate:
		c.upgrade_to_gold()
	
	if has_lucky_pair and (flip_clicks == 7 or flip_clicks == 8):
		c.upgrade()
		trigger_temp_passive("lucky_pair","LUCKY PAIR")
		
	
	if flip_clicks <= 3 and has_triple_nickel:
		trigger_temp_passive("triple_nickel","TRIPLE NICKEL")
		c.upgrade_to_silver()
		
	if has_all_in:
		toggle_button(main.re_flip_button,true)
		toggle_button(main.flip_button,true)
		c.upgrade()

	if c.base_value > 2:
		main.sound_manager.play_sound(COIN_UPGRADE)
		if has_coin_snipe:
			trigger_temp_passive("coin_snipe","COIN SNIPE")
			main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
			main.enemy.take_damage(1)
			create_floating_label(1,"DAMAGE","ENEMY")

	take_damage(1)
	if spend > 0:
		spend -= 1
		take_damage(1)
		main.sound_manager.play_sound(DAMAGE_LIGHT)
		particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.player_portrait.global_position)
		create_floating_label(1,"DAMAGE","PLAYER")
		if spend == 0:
			main.sound_manager.play_sound(SPEND)
			particle_manager.spawn_particle(SPEND_EXPLOSION_PARTICLE,main.player_spend.global_position)
		else:
			particle_manager.spawn_particle(SPEND_EFFECT_PARTICLE,main.player_spend.global_position)
			main.sound_manager.play_sound(SPENDED_FLIP)
	add_child(c)
	if has_reimbursement:
		var debt_chance = randf()
		if debt_chance <= 0.3: 
			debted_attack += 1
			trigger_temp_passive("reimbursement","REIMBURSEMENT")
	if c.reserved == false:
		latest_coin = c
		main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,latest_coin.global_position)

	print(current_played_coin)
	if (current_played_coin == max_playable_coins and current_reserve >= max_reserve) or coin == 1:
		toggle_button(main.flip_button,true)
	coin_calculation()
	if main.enemy.coin > 0:
		main.check_defeat()
	if current_played_coin != 0 and has_refund:
		all_in.text = ""



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
	var slow_chance
	for c in coins:
		if !c.reserved:
			index += 1
		if index <= 2 and has_advanced_planning:
			pass
		else:
			if slow:
				slow_chance = randf()
				if slow_chance <= 0.5:
					continue
			if has_inflation:
				var upgrade_chance = randf()
				if upgrade_chance <= 0.5:
					c.upgrade()
				c.re_flip()
			else:
				c.re_flip()
	if !lock and has_spare_change:
		var has_withdraw_damage = false
		var reserved_coins = get_tree().get_nodes_in_group("reserved coins")
		current_reserve = reserved_coins.size()
		if reserved_coins.size() != 0:
			trigger_temp_passive("spare_change","SPARE CHANGE")
			main.sound_manager.play_sound(PASSIVE_SPARE_CHANGE)
			if has_simple_interest: 
				trigger_temp_passive("simple_interest","SIMPLE INTEREST")
			if has_withdraw: 
				trigger_temp_passive("withdraw","WITHDRAW")
		for c in reserved_coins:
			coin += 1
			c.queue_free()
			toggle_button(main.flip_button,false)
			current_reserve -= 1
			if has_simple_interest: 
				gain += 1
			if has_withdraw: 
				create_floating_label(1,"DAMAGE","ENEMY")
				main.enemy.take_damage(1)
				has_withdraw_damage = true
		if has_withdraw_damage:
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(DAMAGE_MODERATE)	
			main.check_defeat()
			
	if has_reimbursement:
		var debt_chance = randf()
		if debt_chance <= 0.5: 
			debted_attack += 1
			trigger_temp_passive("reimbursement", "REIMBURSEMENT")
		
	if current_re_flip == max_re_flip or current_played_coin == 0:
		toggle_button(main.re_flip_button,true)

	await get_tree().create_timer(0.1).timeout
	coin_calculation()
	
	
func start_turn():
	if lock:
		max_reserve = 0
	player_turn_count += 1
	
	#Initialize Global Stats
	has_all_in = false
	flip_clicks = 0
	latest_coin = null
	
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
	if has_pocket_money and player_turn_count == 1:
		pass
	else:
		current_played_coin = 0
		main.coin_deck.reset_sigils()
	current_re_flip = 0
	latest_coin = null

	
	#Activate Turn Start Passives
	await activate_player_turn_start_passives()
	
	toggle_button(main.flip_button,false)
	if current_played_coin == 0:
		toggle_button(main.re_flip_button,true)
		main.turn_calculation.text = ""

	main.reflip_label.text = str(max_re_flip - current_re_flip)
	current_reserve = 0

	#Check Coin Reserve
	
	if !lock and player_turn_count != 1:
		var coins = get_tree().get_nodes_in_group("reserved coins")
		current_reserve = coins.size()
		var dividend_chance
		var has_withdraw_damage = false
		var is_deck_full = false
		if coins.size() != 0:
			if has_value_increase:
				trigger_temp_passive("value_increase","VALUE INCREASE")
			if has_simple_interest:
				trigger_temp_passive("simple_interest","SIMPLE INTEREST")
			if has_withdraw:
				trigger_temp_passive("withdraw","WITHDRAW")
				
		for coin in coins:
			print("coin!")
			if coin.reserved:
				toggle_button(main.re_flip_button,false)
				var pos
				if current_played_coin == max_playable_coins: is_deck_full = true
				if is_deck_full:
					pos = main.coin_deck.get_reserve_slot()
					current_reserve += 1
				else:
					current_reserve -= 1
					current_played_coin += 1
					pos = main.coin_deck.get_vacant_slot(current_played_coin)
					coin.global_position.x = pos[0]
					coin.global_position.y = pos[1]
					coin.reserved = false
					if has_simple_interest: gain += 1
					if has_withdraw: 
						create_floating_label(1,"DAMAGE","ENEMY")
						main.enemy.take_damage(1)
						has_withdraw_damage = true
				if has_value_increase:
					coin.upgrade()
				latest_coin = COIN.instantiate()
				latest_coin.setup(coin.state,pos)
				latest_coin.copy_coin(coin)
				if is_deck_full:
					latest_coin.reserved = true
					latest_coin.add_to_group("reserved coins")
				else:
					latest_coin.add_to_group("coins")
				coin.queue_free()
				add_child(latest_coin)
				
				dividend_chance = randf()
				if has_dividend and dividend_chance <= 0.3:
					trigger_temp_passive("dividend", "DIVIDEND")
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
						if has_simple_interest: gain += 1
						if has_withdraw:
							create_floating_label(1,"DAMAGE","ENEMY")
							main.enemy.take_damage(1)
							has_withdraw_damage = true
					var dividend_coin = COIN.instantiate()
					dividend_coin.setup(latest_coin.state,pos)
					dividend_coin.copy_coin(latest_coin)
					if is_deck_full:
						dividend_coin.reserved = true
						dividend_coin.add_to_group("reserved coins")
					else:
						dividend_coin.add_to_group("coins")
					add_child(dividend_coin)
	
					
				latest_coin.refresh_sprite()
				if current_played_coin > 1:
					coin_calculation()
		if has_withdraw_damage:
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(DAMAGE_MODERATE)	
				#reserved_coin.queue_free()
	if !lock and (coin == 1 or current_reserve >= max_reserve):
		toggle_button(main.flip_button,true)
	if current_played_coin == 0 :
		if has_refund:
			all_in.text = "ALL IN"
		toggle_button(main.re_flip_button,true)
	print(max_reserve)

func end_turn():
	all_in.text = ""
	toggle_button(main.re_flip_button,true)
	main.endTurn_button.disabled = true
	main.coin_deck.sigil_pressed();
	previous_player_flips = current_played_coin
	

	

	#Activate End Turn Passives
	await activate_player_turn_end_passives()

	if main.enemy.coin == 0: return

	main.sound_manager.play_sound(COIN_ENDTURN)
	
	var calculations = coin_calculation()
	print(calculations)
	var turn_damage = calculations[0]
	var turn_gain = calculations[1]
	var turn_debt = calculations[2]
	var turn_thrift = calculations[3]
	var turn_spend = calculations[4]
	previous_player_gain = 0
	
	if turn_damage > 0:
		main.sound_manager.play_sound(COIN_ATTACK_PARTICLE)
		particle_manager.play_attack_animation(main.coin_deck, main.enemy_portrait, turn_damage)
		main.turn_calculation_box.exit()
		await get_tree().create_timer(1.0).timeout
		create_floating_label(turn_damage,"DAMAGE","ENEMY")

	thrift = 0
	spend = 0
	particle_manager.despawn_emitting_particles()
	max_playable_coins = initial_max_playable_coins
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
		if (main.enemy.type == Enemy.COLLECTOR or main.enemy.type == Enemy.ARISTOCRAT) and greed:
			turn_debt = 0
			create_floating_label("DEBT","IMMUNE","ENEMY")
			main.sound_manager.play_sound(PASSIVE_REFUND)
		else:
			create_floating_label(turn_debt,"DEBT","ENEMY")
			main.sound_manager.play_sound(DEBT)
		main.enemy.debt += turn_debt
	if turn_thrift != 0:
		create_floating_label(turn_thrift,"THRIFT","ENEMY")
		main.enemy.thrift += turn_thrift
		main.sound_manager.play_sound(THRIFT)
	if turn_spend != 0:
		create_floating_label(turn_spend,"SPEND","ENEMY")
		main.enemy.spend += turn_spend
		main.sound_manager.play_sound(SPEND)
		
	if main.enemy.type == Enemy.TWILIGHT_SAGE:
		if main.enemy.has_dusk_stance:
			spend += moon_count
		else:
			thrift += sun_count

	if thrifted_attack != 0:
		thrifted_attack = 0
	if debted_attack != 0:
		debted_attack = 0
	if spended_attack != 0:
		spended_attack = 0
	main.reserve_left_over_coin()
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
			
	if has_piggy:
		trigger_temp_passive("piggy","PIGGY")
		var type = latest_pair_left_coin.type
		latest_pair_left_coin.setup(latest_pair_left_coin.state,main.coin_deck.get_reserve_slot())
		latest_pair_left_coin.reserved = true
		latest_pair_left_coin.type = type
		latest_pair_left_coin.add_to_group("reserved coins")
		add_child(latest_pair_left_coin)
		
		type = latest_pair_right_coin.type
		latest_pair_right_coin.setup(latest_pair_right_coin.state,main.coin_deck.get_reserve_slot())
		latest_pair_right_coin.reserved = true
		latest_pair_right_coin.type = type
		latest_pair_right_coin.add_to_group("reserved coins")
		add_child(latest_pair_right_coin)
		current_reserve += 2

	main.total_damage_dealt += turn_damage
	if turn_damage > main.highest_damage_dealt:
		main.highest_damage_dealt = turn_damage
		
	main.total_gain += turn_gain
	if turn_gain > main.highest_gain:
		main.highest_gain = turn_gain

	if has_active_income and player_turn_count == 1 and !jar_o_savings_used:
		jar_o_savings_used = true
		has_extra_turn = true
		return

	print(current_reserve)
	print(max_reserve)
	if !lock and main.enemy.coin > 0 and has_cash_out and current_reserve >= max_reserve:
		trigger_temp_passive("cash_out","CASH OUT")
		has_extra_turn = true
	
	if lock:	
		lock = false
		max_reserve = initial_max_reserve
		coins = get_tree().get_nodes_in_group("reserved coins")
		current_reserve = coins.size()
	if slow:
		slow = false
	
func activate_pre_battle_passives():
	
	passive_income_used = false
	payback_used = false
	jar_o_savings_used = false
	jar_o_savings_coins = 16
	payback_coins = 8
	pocket_money_coins = 8
	current_played_coin = 0
	if has_pocket_money:
		main.sound_manager.play_sound(COIN_FLIP)
		while pocket_money_coins != 0:
			var state = 1
			current_played_coin += 1
			var c = COIN.instantiate()
			print("POCKET MONEY: " + str(current_played_coin))
			c.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
			
			#Guaranteed Silver Flips
			c.upgrade_to_silver()
			c.add_to_group("coins")
			latest_coin = c
			main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,latest_coin.global_position)
			add_child(c);
			if has_coin_snipe:
				trigger_temp_passive("coin_snipe","COIN SNIPE")
				main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
				main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
				main.enemy.take_damage(1)
				create_floating_label(1,"DAMAGE","ENEMY")
			
			if (current_played_coin == max_playable_coins and current_reserve == max_reserve) or coin == 1:
				toggle_button(main.flip_button,true)
			coin_calculation()
			pocket_money_coins -= 1
			await get_tree().create_timer(0.1).timeout
		main.endTurn_button.disabled = false
		toggle_button(main.re_flip_button,false)

func activate_player_turn_start_passives():
	previous_player_flips = 0
	
	#JAR O SAVINGS
	if has_active_income and jar_o_savings_used and jar_o_savings_coins != 0:
		thrifted_attack = 16
		jar_o_savings_coins = 16
		main.sound_manager.play_sound(THRIFT)
		toggle_button(main.flip_button,true)
		toggle_button(main.re_flip_button,true)
		main.sound_manager.play_sound(JAR_O_SAVINGS)
		var is_deck_full = false
		while jar_o_savings_coins != 0:
			trigger_temp_passive("jar_o_savings","JAR O SAVINGS")
			var state = 1
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

			c.upgrade_to_silver()
			add_child(c);
			if has_coin_snipe:
				trigger_temp_passive("coin_snipe","COIN SNIPE")
				main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
				main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
				main.enemy.take_damage(1)
				create_floating_label(1,"DAMAGE","ENEMY")

			main.sound_manager.play_sound(COIN_FLIP)
			main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,c.global_position)
			coin_calculation()
			jar_o_savings_coins -= 1
			await get_tree().create_timer(0.1).timeout
			latest_coin = c

		main.endTurn_button.disabled = false
		toggle_button(main.re_flip_button,true)
		
	#PAYBACK
	if has_payback and payback_used and payback_coins != 0:
		trigger_temp_passive("payback","PAYBACK")
		payback_coins = 12
		main.sound_manager.play_sound(THRIFT)
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
				c.add_to_group("coins")

			#Guaranteed Silver Flips
			c.upgrade_to_gold()
			add_child(c);
			
			latest_coin = c

			main.sound_manager.play_sound(COIN_FLIP)
			main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,c.global_position)
			if (current_played_coin == max_playable_coins and current_reserve >= max_reserve) or coin == 1:
				toggle_button(main.flip_button,true)
			if has_coin_snipe:
				trigger_temp_passive("coin_snipe","COIN SNIPE")
				main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
				main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
				main.enemy.take_damage(1)
				create_floating_label(1,"DAMAGE","ENEMY")
			coin_calculation()
			payback_coins -= 1
			await get_tree().create_timer(0.2).timeout
			
		main.endTurn_button.disabled = false
		toggle_button(main.re_flip_button,false)


func activate_player_turn_end_passives():
	main.endTurn_button.disabled = true
	if has_refund and current_played_coin == 0 and !has_all_in:
		main.show_turn_ui("ALL IN")
		trigger_temp_passive("refund","ALL IN")
		has_all_in = true
		var all_in_coin = 24
		main.sound_manager.play_sound(PASSIVE_PAYBACK)
		while main.enemy.coin > 0 and all_in_coin != 0 and coin > 1:
			flip()
			coin_calculation()
			await get_tree().create_timer(0.1).timeout
			all_in_coin -= 1
		await get_tree().create_timer(1.0).timeout
	if has_impromptu_flip and latest_coin != null:
		if latest_coin.state == 0:
			latest_coin.state = 1
		else:
			latest_coin.state = 0
		latest_coin.upgrade()
		latest_coin.refresh_sprite()
		trigger_temp_passive("impromptu_flip","IMPROMPTU FLIP")
		main.sound_manager.play_sound(COIN_FLIP)
		coin_calculation()
		await get_tree().create_timer(0.6).timeout

	if has_advanced_planning:
		trigger_temp_passive("advanced_planning","ADVANCED PLANNING")
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
		trigger_temp_passive("magic_trick","MAGIC TRICK")
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
				coin.state = first_coin.state
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
			if index == 4 or index == 6 or index == 8:
				coin.state = second_coin.state
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
		coin_calculation()
		await get_tree().create_timer(1.0).timeout

func extra_turn():
	await start_turn()
	toggle_button(main.re_flip_button,true)
	toggle_button(main.flip_button,true)
	
func toggle_button(btn: Button, make_disabled: bool) -> void:
	btn.disabled = make_disabled
	
	if make_disabled:
		btn.modulate = Color(0.5, 0.5, 0.5, 1.0)
		
		if "lifted_slot" in btn and btn.lifted_slot != null:
			btn._on_mouse_exited()
			
	else:
		btn.modulate = Color(1.0, 1.0, 1.0, 1.0)


func trigger_temp_passive(id: String, text: String):
	if not main:
		return
		
	if active_temp_ids.has(id):
		return
	
	active_temp_ids[id] = true
	
	main.trigger_passive(id, text)
	
	await get_tree().create_timer(1.5).timeout
	active_temp_ids.erase(id)
