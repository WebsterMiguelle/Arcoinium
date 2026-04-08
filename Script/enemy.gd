#Enemy
extends Node

var main

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

const DEBT_EFFECT = preload("uid://d18qgeounkatf")
const GAIN_EFFECT = preload("uid://cr366klr6aivy")
const SPENDED_FLIP = preload("uid://dgu0hy8kwo343")
const SPEND = preload("uid://bvbtrait4prdi")




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
			max_coin = 200
			coin = 12
			max_playable_coins = 1
			silver_flip_rate = 0.0
			gold_flip_rate = 0.0
			bounty = 25
			type = Enemy.MAGE
		Enemy.DWARF:
			max_coin = 200
			coin = 12
			max_playable_coins = 2
			silver_flip_rate = 0.0
			gold_flip_rate = 0.0
			bounty = 25
			type = Enemy.DWARF
		Enemy.COLLECTOR:
			max_coin = 200
			coin = 36
			max_playable_coins = 6
			silver_flip_rate = 0.1
			gold_flip_rate = 0.0
			bounty = 50
			type = Enemy.COLLECTOR
			has_value_added_tax = true
			main.player.has_value_added_tax = true
			trigger_enemy_passive("The Tax Collector immediately applied 5 DEBT.", 3.0)
		Enemy.TRADER:
			max_coin = 200
			coin = 40
			max_playable_coins = 2
			silver_flip_rate = 0.05
			gold_flip_rate = 0.0
			bounty = 50
			type = Enemy.TRADER
			has_fair_trade = true
			trigger_enemy_passive("The Trader will Copy your Number of Played Coins.", 3.0)
		Enemy.THRIFTER:
			max_coin = 200
			coin = 90
			max_playable_coins = 8
			silver_flip_rate = 0.3
			gold_flip_rate = 0
			bounty = 75
			type = Enemy.THRIFTER
			has_learn_to_save = true
			main.player.has_learn_to_save = true
			main.player.thrift = 8
			trigger_enemy_passive("The Thrifter immediately applied 8 THRIFT.", 3.0)
		Enemy.ARISTOCRAT:
			max_coin = 200
			coin = 120
			max_playable_coins = 16
			silver_flip_rate = 1
			gold_flip_rate = 0
			bounty = 75
			type = Enemy.ARISTOCRAT
			has_fully_paid = true
			debt = 100
			trigger_enemy_passive("When The Aristocrat settled all her DEBT, Deal 100 Damage.", 3.0)
		Enemy.SUN_CASTER:
			max_coin = 200
			coin = 120
			max_playable_coins = 12
			silver_flip_rate = 1
			gold_flip_rate = 0
			bounty = 100
			type = Enemy.SUN_CASTER
			has_sunlit_curse = true
			main.player.has_sunlit_curse = true
			trigger_enemy_passive("You Have Guaranteed Sun Flips. Avoid Playing 9 or More Sun Coins.", 5.0)
		Enemy.MOON_CASTER:
			max_coin = 200
			coin = 100
			max_playable_coins = 12
			silver_flip_rate = 1
			gold_flip_rate = 0
			bounty = 100
			type = Enemy.MOON_CASTER
			has_midnight_curse = true
			main.player.has_midnight_curse = true
			trigger_enemy_passive("You Have Guaranteed Moon Flips. Avoid Playing 9 or More Moon Coins.", 5.0)
		Enemy.TWILIGHT_SAGE:
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
			trigger_enemy_passive("DAWN STANCE: Play as Many Moon Coins.", 3.0)


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
	@warning_ignore("confusable_local_usage", "shadowed_variable")
	var type = type
	var coins = get_tree().get_nodes_in_group("enemy_coins")
	match type:

		Enemy.MAGE:
			for coin in coins:
				if coin.state == 0: 
					total_damage += coin.base_value
					sun_count +=1
				else:
					moon_count +=1
		Enemy.DWARF:
			var can_attack = true
			var current_played_coin = 0
			for coin in coins:
				current_played_coin += 1
				if coin.state == 1: 
					can_attack = false
					moon_count += 1
				else: sun_count += 1
			if can_attack and current_played_coin == 2: total_damage += 4
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
						total_damage += (left_coin.base_value) / 2
						total_debt += (right_coin.base_value) / 2
					left_coin = null
					right_coin = null
				else:
					pass
				is_left = !is_left
		Enemy.TRADER:
			for coin in coins:
				if coin.state == 0: 
					total_spend += coin.base_value / 2
					sun_count +=1
				else:
					moon_count +=1
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
						total_thrift += 2
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
		Enemy.SUN_CASTER:
			var is_left = true # true - Left Coin, false - Right Coin
			var left_coin
			var right_coin
			for coin in coins:
				if coin.state == 0:
					total_spend += 1
					sun_count += 1
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
				else:
					sun_count += 1
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
				if coin.state == 0:
					sun_count +=1
				else: 
					moon_count += 1
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
		main.turn_calculation.text = text
		main.turn_calculation.add_theme_color_override("font_color", Color.WHITE)
	if text != "":
		sun_moon_count.text = "𖤓 " + str(sun_count) + " ☾ " + str(moon_count)
		main.turn_calculation_box.entrance(true)
	return [total_damage,total_gain,total_debt,total_thrift,total_spend]

func start_enemy_turn():
	toggle_button(main.flip_button,true)
	toggle_button(main.re_flip_button,true)
	main.endTurn_button.disabled = true


	if has_fair_trade:
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
		particle_manager.play_attack_animation(main.coin_deck, main.player_portrait, turn_damage)
		await get_tree().create_timer(1.0).timeout
		
		main.player.take_damage(100)
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.player_portrait.global_position)
	if main.player.has_loan_shark and debt > 1:
		var loan_damage = debt / 2
		debt /= 2
		take_damage(loan_damage)
		main.player.trigger_temp_passive("loan_shark","LOAN SHARK")
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		main.sound_manager.play_sound(PASSIVE_LOAN_SHARK)


	#Reset Enemy Stats
	current_played_coin = 0
	
	main.turn_calculation.text = ""

	#FLIP COINS
	if coin > 0:
		await get_tree().create_timer(1.0).timeout
		while current_played_coin != max_playable_coins:
			if coin > 0:
				flip()
				enemy_coin_calculation()
			else:
				main.sound_manager.play_sound(DEATH)
				break
			await get_tree().create_timer(0.4).timeout
		await get_tree().create_timer(1.0).timeout
		await end_enemy_turn()


func end_enemy_turn():
	main.coin_deck.sigil_pressed()
	var calculations = enemy_coin_calculation()
	var turn_damage = calculations[0]
	var turn_gain = calculations[1]
	var turn_debt = calculations[2]
	var turn_thrift = calculations[3]
	var turn_spend = calculations[4]
	
	if coin == 0:
		turn_damage = 0
		turn_gain = 0
		turn_debt = 0
		turn_thrift = 0
		turn_spend = 0
		main.turn_calculation.text = ""
		main.turn_calculation_box.exit()

	if current_played_coin > 0:
		main.sound_manager.play_sound(COIN_ENDTURN)
	if turn_damage != 0: 
		main.sound_manager.play_sound(COIN_ATTACK_PARTICLE)
		particle_manager.play_attack_animation(main.coin_deck, main.player_portrait, turn_damage)
		main.turn_calculation_box.exit()
		await get_tree().create_timer(1.0).timeout
		if main.player.has_passive_income and !main.player.passive_income_used:
			main.player.passive_income_used = true
			main.player.trigger_temp_passive("passive_income","PASSIVE INCOME")
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
	if turn_thrift != 0:
		main.player.thrift += turn_thrift
		main.sound_manager.play_sound(THRIFT)
	if turn_spend != 0:
		main.player.spend += turn_spend
		main.sound_manager.play_sound(SPEND)
		
	thrift = 0
	spend = 0
	max_playable_coins = initial_max_playable_coins
	particle_manager.despawn_emitting_particles()
	
	gain += turn_gain
	if main.player.has_pay_down:
		if debt > coin:
			coin = 0
			main.sound_manager.play_sound(PASSIVE_PAYDOWN)
			main.player.trigger_temp_passive("pay_down","PAY DOWN")
		else:
			debt += 5
		

	var coins = get_tree().get_nodes_in_group("enemy_coins")
	for coin in coins:
		main.particle_manager.spawn_particle(COIN_PLAY_PARTICLE,coin.global_position)
		coin.queue_free()
	
	#ACTIVATE PAYBACK
	if main.player.has_payback and !main.player.payback_used and main.player.coin == 0: 
		main.player.coin = 1
		main.player.payback_used = true
		main.player.payback_coins = 12
		
	if main.player.coin > 0:
		await get_tree().create_timer(1.0).timeout
		has_dusk_stance = !has_dusk_stance
		if type == Enemy.TWILIGHT_SAGE:
			if has_dusk_stance == true:
				dawn_particles.emitting = false
				dusk_particles.emitting = true
				switch_vignette_color(dusk_stance,0.4)
				trigger_enemy_passive("DUSK STANCE: Play As Many Sun Coins.", 3.0)
				main.enemy_portrait_sprite.play("TWILIGHT_SAGE_DUSK")
			else:
				dawn_particles.emitting = true
				dusk_particles.emitting = false
				switch_vignette_color(dawn_stance,0.4)
				trigger_enemy_passive("DAWN STANCE: Play as Many Moon Coins.", 3.0)
				main.enemy_portrait_sprite.play("TWILIGHT_SAGE_DAWN")	
			max_playable_coins += 4
	
	if type == Enemy.MOON_CASTER or type == Enemy.SUN_CASTER:
		switch_vignetter_color(vignetter_default,0.4)
	

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
