#Enemy
extends Node

var main
const FLOATING_LABEL = preload("uid://dwf6g2wuj1oe3")

@onready var particle_manager: Node2D = $"../ParticleManager"
@onready var vignette: CanvasModulate = $"../Vignette"
@onready var vignetter: PointLight2D = $"../Vignetter"
@onready var sun_moon_count: Label = $"../Battle UI/Turn Calculation Box/Sun Moon Count"

const COIN = preload("uid://ddet242jm5v23")


#SOUNDS
const DEATH = preload("uid://bx1ttmouolx2q")
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
const THRIFT = preload("uid://b34wg18n8eb0t")
const THRIFT_FLAME = preload("uid://kld7c6qpdho7")
const RESERVE_LOCK = preload("uid://4lh30crpkf58")
const DEBT_EFFECT = preload("uid://d18qgeounkatf")
const GAIN_EFFECT = preload("uid://cr366klr6aivy")
const SPENDED_FLIP = preload("uid://dgu0hy8kwo343")
const SPEND = preload("uid://bvbtrait4prdi")
const SLOW = preload("uid://f5jmno7qyhek")

const DEBTED_ATTACK = preload("uid://ddf31ka4126fv")
const SPENDED_ATTACK = preload("uid://lfprp4w7saas")
const THRIFTED_ATTACK = preload("uid://dtx4a0j6atomh")


#PARTICLES
const COIN_ADD_PARTICLE = preload("uid://s6va71jul34t")
const COIN_PLAY_PARTICLE = preload("uid://w5jgphq268vx")
const DAMAGE_PARTICLE = preload("uid://q4hytnmn2fbt")
const SINGLE_DAMAGE_PARTICLE = preload("uid://dgeahqxig4fqa")
const THRIFT_PARTICLE = preload("uid://b5x6b2q8jvqa5")
const GAIN_EFFECT_PARTICLE = preload("uid://c5py6ekby1mnm")
const DEBT_EFFECT_PARTICLE = preload("uid://c52tpyupg2ynl")
const SPEND_EFFECT_PARTICLE = preload("uid://m3n67qiuvr7i")
const SPEND_EXPLOSION_PARTICLE = preload("uid://bgfgq2kw3njao")
const COIN_ATTACK_PARTICLE = preload("uid://djmpd27qq4nn1")

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
var greed = false
var bounty = 0 #Coin Drop on Death
var type #Enemy Type
var max_coin = 0 #Max Coin Capacity
var coin = 0:
	set(value):
		coin = clamp(value,0,max_coin)
var initial_max_playable_coins = 0
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
var thrift = 0: #Reduced Playable Coins
	set(value):
		thrift = clamp(value,0,16) 
var spend = 0: #Block Coin Flips
	set(value):
		spend = clamp(value,0,1000) 
		
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


var vignette_default = '#bdabb8'
var vignetter_default = '#ffe6909e'
var sun_caster_color = '#e56400'
var moon_caster_color = '#1a54fb'
var dawn_stance = '#ffcda0'
var dusk_stance = '#8dacf7'
@onready var battle_particles: GPUParticles2D = $"../ParticleManager/Battle Particles"
@onready var dusk_particles: GPUParticles2D = $"../ParticleManager/Dusk Particles"
@onready var dawn_particles: GPUParticles2D = $"../ParticleManager/Dawn Particles"

# Called when the node enters the scene tree for the first time.
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

func _ready():
	pass

func switch_vignette_color(to,duration):
	var tween = create_tween()
	tween.tween_property(vignette,"color",Color.from_string(to,Color.WHITE),duration)

func switch_vignetter_color(to,duration):
	var tween = create_tween()
	tween.tween_property(vignetter,"color",Color.from_string(to,Color.WHITE),duration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
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
	thrift = 0
	spend = 0
	current_played_coin = 0

func gain_coin():
	var temp = gain
	gain -= debt
	debt -= temp
	coin += gain
	if gain > 0:
		particle_manager.spawn_particle(GAIN_EFFECT_PARTICLE,main.enemy_gain.global_position)
		main.sound_manager.play_sound(GAIN_EFFECT)
		create_floating_label(gain,"GAIN","ENEMY")
	elif debt > 0:
		particle_manager.spawn_particle(DEBT_EFFECT_PARTICLE,main.enemy_debt.global_position)
		main.sound_manager.play_sound(DEBT_EFFECT)
	gain = 0
	print("Player HP: ", coin)

func setup(m,enemy):
	main = m
	print("Hello" + str(enemy))
	match enemy:
		Enemy.MAGE:
			if !greed:
				max_coin = 200
				coin = 12
				max_playable_coins = 1
				silver_flip_rate = 0.0
				gold_flip_rate = 0.0
				bounty = 25
			else:
				max_coin = 200
				coin = 30
				max_playable_coins = 6
				silver_flip_rate = 0.0
				gold_flip_rate = 0.0
				bounty = 50
			type = Enemy.MAGE
		Enemy.DWARF:
			if !greed:
				max_coin = 200
				coin = 12
				max_playable_coins = 2
				silver_flip_rate = 0.0
				gold_flip_rate = 0.0
				bounty = 25
			else:
				max_coin = 200
				coin = 40
				max_playable_coins = 8
				silver_flip_rate = 0.0
				gold_flip_rate = 0.0
				bounty = 50
			type = Enemy.DWARF
		Enemy.COLLECTOR:
			type = Enemy.COLLECTOR
			if !greed:
				max_coin = 200
				coin = 48
				max_playable_coins = 8
				silver_flip_rate = 0.5
				gold_flip_rate = 0.2
				bounty = 50
				has_value_added_tax = true
				main.player.has_value_added_tax = true
				trigger_enemy_passive("The Collector will apply 1 GAIN to self for each DEBT you settled.", 5.0)
			else:
				max_coin = 70
				coin = 70
				max_playable_coins = 16
				silver_flip_rate = 0.8
				gold_flip_rate = 0.0
				bounty = 100
				has_value_added_tax = true
				main.player.has_value_added_tax = true
				trigger_enemy_passive("The Collector will apply 1 GAIN to self for each DEBT you settled.", 5.0)
		Enemy.TRADER:
			if !greed:
				max_coin = 200
				coin = 48
				max_playable_coins = 2
				silver_flip_rate = 0.1
				gold_flip_rate = 0.0
				bounty = 50
				type = Enemy.TRADER
				has_fair_trade = true
				trigger_enemy_passive("The Trader will Copy your Number of Played Coins.", 3.0)
			else:
				max_coin = 200
				coin = 80
				max_playable_coins = 2
				silver_flip_rate = 1.0
				gold_flip_rate = 0.0
				bounty = 100
				type = Enemy.TRADER
				has_fair_trade = true
				trigger_enemy_passive("The Trader will Copy your Number of Played Coins.", 3.0)
		Enemy.THRIFTER:
			if !greed:
				max_coin = 200
				coin = 70
				max_playable_coins = 8
				silver_flip_rate = 0.5
				gold_flip_rate = 0.1
				bounty = 75
				type = Enemy.THRIFTER
				has_learn_to_save = true
				main.player.has_learn_to_save = true
			else:
				max_coin = 100
				coin = 100
				max_playable_coins = 12
				silver_flip_rate = 0
				gold_flip_rate = 1
				bounty = 150
				type = Enemy.THRIFTER
				has_learn_to_save = true
				main.player.has_learn_to_save = true
		Enemy.ARISTOCRAT:
			if !greed:
				max_coin = 200
				coin = 120
				max_playable_coins = 16
				silver_flip_rate = 1
				gold_flip_rate = 0
				bounty = 75
				type = Enemy.ARISTOCRAT
				has_fully_paid = true
				debt = 100
				trigger_enemy_passive("When The Aristocrat settled all her DEBT, Deal 100 Damage.", 4.0)
			else:
				max_coin = 180
				coin = 180
				max_playable_coins = 16
				silver_flip_rate = 0
				gold_flip_rate = 1
				bounty = 150
				type = Enemy.ARISTOCRAT
				has_fully_paid = true
				debt = 200
				trigger_enemy_passive("When The Aristocrat settled all her DEBT, Deal 500 Damage.", 4.0)
		Enemy.SUN_CASTER:
			if !greed:
				max_coin = 200
				coin = 120
				max_playable_coins = 12
				silver_flip_rate = 1
				gold_flip_rate = 0
				bounty = 100
				type = Enemy.SUN_CASTER
				has_sunlit_curse = true
				trigger_enemy_passive("Avoid Playing 9 or More SUN Coins.", 5.0)
			else:
				max_coin = 200
				coin = 200
				max_playable_coins = 16
				silver_flip_rate = 1
				gold_flip_rate = 0.5
				bounty = 200
				type = Enemy.SUN_CASTER
				has_sunlit_curse = true
				main.player.has_sunlit_curse = true
				trigger_enemy_passive("You have GUARANTEED SUN FLIPS. Avoid Playing 9 or More SUN Coins.", 5.0)
		Enemy.MOON_CASTER:
			if !greed:
				max_coin = 200
				coin = 120
				max_playable_coins = 12
				silver_flip_rate = 1
				gold_flip_rate = 0
				bounty = 100
				type = Enemy.MOON_CASTER
				has_midnight_curse = true
				trigger_enemy_passive("Avoid Playing 9 or More MOON Coins.", 5.0)
			else:
				max_coin = 200
				coin = 200
				max_playable_coins = 16
				silver_flip_rate = 1
				gold_flip_rate = 0.5
				bounty = 200
				type = Enemy.MOON_CASTER
				has_midnight_curse = true
				main.player.has_midnight_curse = true
				trigger_enemy_passive("You have GUARANTEED MOON FLIPS. Avoid Playing 9 or More MOON Coins.", 5.0)
		Enemy.TWILIGHT_SAGE:
			if !greed:
				max_coin = 250
				coin = 250
				max_playable_coins = 4
				silver_flip_rate = 1
				gold_flip_rate = 0.8
				bounty = 0
				type = Enemy.TWILIGHT_SAGE
				has_dusk_stance = false
				battle_particles.emitting = false
				dawn_particles.emitting = true
				switch_vignette_color(dawn_stance,0.4)
				trigger_enemy_passive("DAWN STANCE: Play as Many MOON Coins.", 5.0)
			else:
				max_coin = 400
				coin = 400
				max_playable_coins = 8
				silver_flip_rate = 0
				gold_flip_rate = 1
				bounty = 0
				type = Enemy.TWILIGHT_SAGE
				has_dusk_stance = false
				battle_particles.emitting = false
				dawn_particles.emitting = true
				switch_vignette_color(dawn_stance,0.4)
				trigger_enemy_passive("DAWN STANCE: Play as Many MOON Coins.", 5.0)
				


func flip():
	main.sound_manager.play_sound(COIN_FLIP)
	var state = randi() % 2
	
	if type == Enemy.SUN_CASTER and main.player.sun_count >= 9:
		state = 0
	if type == Enemy.MOON_CASTER and main.player.moon_count >= 9:
		state = 1

	take_damage(1)
	if spend > 0:
		spend -= 1
		take_damage(1)
		main.sound_manager.play_sound(DAMAGE_LIGHT)
		particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		create_floating_label(1,"DAMAGE","ENEMY")
		if spend == 0:
			main.sound_manager.play_sound(SPEND)
			particle_manager.spawn_particle(SPEND_EXPLOSION_PARTICLE,main.enemy_spend.global_position)
		else:
			particle_manager.spawn_particle(SPEND_EFFECT_PARTICLE,main.enemy_spend.global_position)
			main.sound_manager.play_sound(SPENDED_FLIP)
	
	current_played_coin += 1
	@warning_ignore("shadowed_variable")
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
	var total_thrift = 0
	var total_spend = 0
	var sun_count = 0
	var moon_count = 0
	var activate_lock = false
	var activate_slow = false
	@warning_ignore("confusable_local_usage", "shadowed_variable")
	var type = type
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	match type:

		Enemy.MAGE:
			for coin in coins:
				if coin.state == 0: 
					total_damage += coin.base_value
					if greed: total_spend += 1
					sun_count +=1
				else:
					moon_count +=1
		Enemy.DWARF:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if coin.state == 0:
					sun_count +=1
				else: 
					if greed: total_thrift += 1
					moon_count += 1
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
		Enemy.COLLECTOR:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if coin.state == 0:
					sun_count +=1
				else: 
					moon_count += 1
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin			
				if left_coin != null and right_coin != null:
					if left_coin.state != right_coin.state:
						total_damage += (left_coin.base_value)
						total_debt += (right_coin.base_value)
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
		Enemy.TRADER:
			for coin in coins:
				if coin.state == 0: 
					total_damage += coin.base_value / 2
					sun_count +=1
				else:
					total_gain += coin.base_value / 2
					moon_count +=1
			if greed and current_played_coin == 16:
				activate_lock = true
		Enemy.THRIFTER:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if coin.state == 0:
					sun_count +=1
				else: 
					moon_count += 1
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin
				if left_coin != null and right_coin != null:
					if left_coin.state == 1 and right_coin.state == 1:
						total_gain += (left_coin.base_value / 2) + (right_coin.base_value / 2)
					elif left_coin.state == 0 and right_coin.state == 0:
						total_damage += (left_coin.base_value) + (right_coin.base_value)
					else:
						if greed:
							total_thrift += 2
						else:
							total_thrift += 3
					if greed and total_thrift <= 6:
						activate_lock = true
					else:
						activate_lock = false
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
		Enemy.ARISTOCRAT:
			for coin in coins:
				if coin.state == 1: 
					total_gain += coin.base_value
					moon_count +=1
				else:
					sun_count +=1
				if greed and current_played_coin == 16:
					activate_slow = true
		Enemy.SUN_CASTER:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if coin.state == 0:
					total_spend += 2
					sun_count += 1
					if greed:
						total_damage += coin.base_value / 2
						if sun_count >= 8:
							activate_lock = true
				else:
					moon_count +=1
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin			
				if left_coin != null and right_coin != null:
					if left_coin.state == 0 and right_coin.state == 0:
						total_damage += (left_coin.base_value)/2 + (right_coin.base_value)/2
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
					moon_count += 1
					if greed:
						total_damage += coin.base_value / 2
						if moon_count >= 8:
							activate_slow = true
				else:
					sun_count += 1
				if is_left == true:
					left_coin = coin
				if is_left == false:
					right_coin = coin			
				if left_coin != null and right_coin != null:
					if left_coin.state == 1 and right_coin.state == 1:
						total_damage += left_coin.base_value/2 + right_coin.base_value/2
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
				if coin.state == 0:
					if greed:
						total_damage += 1
					sun_count +=1
				else: 
					if greed:
						total_gain += 1
					moon_count += 1
				if greed and sun_count >= 8:
					activate_lock = true
				if greed and moon_count >= 8:
					activate_slow = true
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
						total_debt +=  (left_coin.base_value/2 + right_coin.base_value/2)
					else:
						total_debt +=  (left_coin.base_value/2 + right_coin.base_value/2)
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
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
		if activate_lock:
			text += "\nCan LOCK"
		if activate_slow:
			text += "\nCan SLOW"
		main.turn_calculation.text = text
		main.turn_calculation.add_theme_color_override("font_color", Color.WHITE)
	if text != "":
		sun_moon_count.text = "𖤓 " + str(sun_count) + " ☾ " + str(moon_count)
		main.turn_calculation_box.entrance(true)
	return [total_damage,total_gain,total_debt,total_thrift,total_spend,activate_lock,activate_slow]

func start_enemy_turn():
	toggle_button(main.flip_button,true)
	toggle_button(main.re_flip_button,true)
	main.endTurn_button.disabled = true


	if has_fair_trade:
		if greed and main.player.previous_player_flips == 16:
			trigger_enemy_passive("Playing " + str(main.player.previous_player_flips) + " Coins will also apply LOCK.", 2.0)
		else:
			trigger_enemy_passive("The Trader will play " + str(main.player.previous_player_flips) + " Coins.", 2.0)
		max_playable_coins = main.player.previous_player_flips
		main.player.previous_player_flips = 0

	if type == Enemy.SUN_CASTER:
		if main.player.sun_count >= 9:
			gold_flip_rate = 1
			switch_vignetter_color(sun_caster_color,0.4)
			trigger_enemy_passive("You played " + str(main.player.sun_count) + " Sun Coins. Sun Caster powered up!", 3.0)
		else:
			gold_flip_rate = 0

	if type == Enemy.MOON_CASTER:
		if main.player.moon_count >= 9:
			gold_flip_rate = 1
			switch_vignetter_color(moon_caster_color,0.4)
			trigger_enemy_passive("You played " + str(main.player.moon_count) + " Moon Coins. Moon Caster powered up!", 3.0)
		else:
			gold_flip_rate = 0
	

	#Initialize Stats
	var turn_damage = 0
	var turn_gain = 0
	var turn_debt = 0
	var defeat
	
	#THRIFT
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
	initial_max_playable_coins = max_playable_coins
	max_playable_coins -= thrift
	#Coin Gain Triggers
	gain_coin()
	
	if has_fully_paid:
		if debt > 0:
			trigger_enemy_passive("Remaining DEBT: " + str(debt), 2.0)
		else:
			trigger_enemy_passive("FULLY PAID!", 2.0)
	
	if has_fully_paid and debt == 0:
		particle_manager.trigger_attack(main.coin_deck, main.player_portrait, turn_damage, "")
		await get_tree().create_timer(1.0).timeout
		if greed:
			main.player.take_damage(500)
		else:
			main.player.take_damage(100)
		main.sound_manager.play_sound(DAMAGE_HEAVY)
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.player_portrait.global_position)
	if main.player.has_loan_shark and debt > 1:
		var loan_damage = debt / 2
		debt /= 2
		take_damage(loan_damage)
		create_floating_label(loan_damage,"DAMAGE","ENEMY")
		main.player.trigger_temp_passive("loan_shark","LOAN SHARK")
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		main.sound_manager.play_sound(PASSIVE_LOAN_SHARK)


	#Reset Enemy Stats
	current_played_coin = 0
	
	main.turn_calculation.text = ""
	
	var flip_speed = 0.4
	if greed: flip_speed = 0.2
	#FLIP COINS
	if main.player.coin == 0:
		return
	if coin > 0:
		await get_tree().create_timer(1.0).timeout
		while current_played_coin != max_playable_coins:
			if coin > 0:
				flip()
				enemy_coin_calculation()
			else:
				main.sound_manager.play_sound(DEATH)
				break
			await get_tree().create_timer(flip_speed).timeout
		await get_tree().create_timer(1.0).timeout
		await end_enemy_turn()


func end_enemy_turn():
	main.coin_deck.sigil_pressed()
	
	# ==========================================
	# PHASE 1: MATH & LOGIC (Instantly calculate everything)
	# ==========================================
	var calculations = enemy_coin_calculation()
	var turn_damage = calculations[0]
	var turn_gain = calculations[1]
	var turn_debt = calculations[2]
	var turn_thrift = calculations[3]
	var turn_spend = calculations[4]
	var turn_lock = calculations[5]
	var turn_slow = calculations[6]
	
	# Check if Enemy is already dead
	if coin <= 0:
		turn_damage = 0; turn_gain = 0; turn_debt = 0; turn_thrift = 0
		turn_spend = 0; turn_lock = false; turn_slow = false
		main.turn_calculation.text = ""



	# 3. Apply Stats to Enemy
	thrift = 0
	spend = 0
	max_playable_coins = initial_max_playable_coins
	gain += turn_gain


	# 5. Player 'Payback' Revive Check
	if main.player.has_payback and !main.player.payback_used and main.player.coin <= 0: 
		main.player.coin = 1
		main.player.payback_used = true
		main.player.payback_coins = 12
		main.player.debt = 0
		main.player.spend = 0
		main.player.thrift = 0
		main.player.lock = false
		main.player.slow = false

	# 6. Twilight Sage Pre-Calc
	if main.player.coin > 0:
		has_dusk_stance = !has_dusk_stance
		if type == Enemy.TWILIGHT_SAGE:
			max_playable_coins += 4


	# ==========================================
	# PHASE 2: VISUALS & ANIMATIONS (Play all the eye-candy!)
	# ==========================================
	
	if current_played_coin > 0:
		main.sound_manager.play_sound(COIN_ENDTURN)

	particle_manager.despawn_emitting_particles()
	
	if turn_damage > 0 or turn_debt > 0 or turn_thrift > 0 or turn_spend > 0 or turn_lock or turn_slow:
		main.turn_calculation_box.exit()
	elif coin <= 0:
		# I combined your double-exit check here so the box doesn't glitch by trying to close twice!
		main.turn_calculation_box.exit()

	# -- Trigger Simultaneous Attacks (Firing out of the deck) --
	if turn_damage > 0:
		main.sound_manager.play_sound(COIN_ATTACK_PARTICLE) # The firing sound
		particle_manager.trigger_attack(main.coin_deck, main.player_portrait, turn_damage, "")
		

	if turn_debt != 0: 
		main.sound_manager.play_sound(DEBTED_ATTACK)
		particle_manager.trigger_attack(main.coin_deck,main.player_portrait, turn_debt, "DEBT")
	if turn_thrift != 0: 
		main.sound_manager.play_sound(THRIFTED_ATTACK)
		particle_manager.trigger_attack(main.coin_deck, main.player_portrait, turn_thrift, "THRIFT")
	if turn_spend != 0: 
		main.sound_manager.play_sound(SPENDED_ATTACK)
		particle_manager.trigger_attack(main.coin_deck, main.player_portrait, turn_spend, "SPEND")
	



	# Clean up the played coins visually
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	for c in coins:
		main.particle_manager.spawn_particle(COIN_PLAY_PARTICLE, c.global_position)
		c.queue_free()

	# -- The Pause --
	# Wait for the attack runes to travel across the screen
	if turn_damage > 0 or turn_debt > 0 or turn_thrift > 0 or turn_spend > 0 or turn_lock or turn_slow:
		await get_tree().create_timer(1.0).timeout

	# 1. Player Passive Income Check
	var passive_income_triggered = false
	var converted_income = 0
	if turn_damage > 0:
		if main.player.has_passive_income and !main.player.passive_income_used:
			main.player.trigger_temp_passive("passive_income","PASSIVE INCOME")
			main.sound_manager.play_sound(PASSIVE_PASSIVE_INCOME)
			main.player.passive_income_used = true
			passive_income_triggered = true
			converted_income = turn_damage
			if converted_income >= 30:
				converted_income = 30
			main.player.coin += converted_income
		else:
			main.player.take_damage(turn_damage)
	
	# -- Final Hit Impacts & Floating Labels (The runes have arrived!) --
	if turn_damage > 0:
		if passive_income_triggered:
			pass 
		else:
			# I MOVED THE HIT PARTICLES AND SOUNDS HERE!
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE, main.player_portrait.global_position)
			if turn_damage <= 10: main.sound_manager.play_sound(DAMAGE_LIGHT)
			elif turn_damage <= 20: main.sound_manager.play_sound(DAMAGE_MODERATE)
			else: main.sound_manager.play_sound(DAMAGE_HEAVY)
			
			create_floating_label(turn_damage, "DAMAGE", "PLAYER")
			
	if turn_debt != 0: 
		main.sound_manager.play_sound(DEBT)
		create_floating_label(turn_debt, "DEBT", "PLAYER")
	if turn_thrift != 0: 
		main.sound_manager.play_sound(THRIFT)
		create_floating_label(turn_thrift, "THRIFT", "PLAYER")
	if turn_spend != 0: 
		main.sound_manager.play_sound(SPEND)
		create_floating_label(turn_spend, "SPEND", "PLAYER")
	if turn_lock: 
		main.sound_manager.play_sound(RESERVE_LOCK)
		main.sound_manager.play_sound(PASSIVE_LOAN_SHARK)
		create_floating_label("", "LOCK", "PLAYER")
	if turn_slow: 
		main.sound_manager.play_sound(SLOW)
		main.sound_manager.play_sound(PASSIVE_PAYDOWN)
		create_floating_label("", "SLOW", "PLAYER")
	
	# 2. Apply Status Effects to Player
	if turn_debt != 0: main.player.debt += turn_debt
	if turn_thrift != 0: main.player.thrift += turn_thrift
	if turn_spend != 0: main.player.spend += turn_spend
	if turn_lock: main.player.lock = true
	if turn_slow: main.player.slow = true
	
	# 4. Player 'Pay Down' Passive Check
	var pay_down_killed = false
	var pay_down_debt_added = false
	if main.player.has_pay_down:
		if debt > coin:
			coin = 0
			pay_down_killed = true
	if pay_down_killed:
		main.sound_manager.play_sound(PASSIVE_PAYDOWN)
		main.player.trigger_temp_passive("pay_down","PAY DOWN")

	if pay_down_killed:
		create_floating_label(debt, "DAMAGE", "ENEMY")
	elif pay_down_debt_added:
		create_floating_label(5, "DEBT", "ENEMY")

	# -- Post-Turn Enemy Visuals (Stances & Vignettes) --
	if main.player.coin > 0:
		if type == Enemy.TWILIGHT_SAGE:
			if has_dusk_stance == true:
				dawn_particles.emitting = false
				dusk_particles.emitting = true
				switch_vignette_color(dusk_stance, 0.4)
				trigger_enemy_passive("DUSK STANCE: Play As Many SUN Coins.", 5.0)
				main.enemy_portrait_sprite.play("TWILIGHT_SAGE_DUSK")
			else:
				dawn_particles.emitting = true
				dusk_particles.emitting = false
				switch_vignette_color(dawn_stance, 0.4)
				trigger_enemy_passive("DAWN STANCE: Play as Many MOON Coins.", 5.0)
				main.enemy_portrait_sprite.play("TWILIGHT_SAGE_DAWN")	
				
	if type == Enemy.MOON_CASTER or type == Enemy.SUN_CASTER:
		switch_vignetter_color(vignetter_default, 0.4)
	
	main.coin_deck.sigil_unlight_()
	
	
func toggle_button(btn: Button, make_disabled: bool) -> void:
	btn.disabled = make_disabled
	
	if make_disabled:
		btn.modulate = Color(0.5, 0.5, 0.5, 1.0) # Darken to 50%
		
		# NEW: If the button has a lifted coin, force it to drop!
		if "lifted_slot" in btn and btn.lifted_slot != null:
			btn._on_mouse_exited()
			
	else:
		btn.modulate = Color(1.0, 1.0, 1.0, 1.0) # Restore to normal brightness


func trigger_enemy_passive(text: String, duration: float = 1.5):
	main.show_enemy_passive(text, duration)
	print("Hello") 
