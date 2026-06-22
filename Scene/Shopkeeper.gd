#Enemy
extends Node

enum CoinStatus{
	NONE,
	SHINED,
	VOIDED,
	DAZZLED
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

@onready var keeper_shadow: TextureRect = $"Keeper Shadow"
@onready var solar_glow: TextureRect = $"../Player/Solar Blessing Icon/Solar Glow"
@onready var lunar_glow: TextureRect = $"../Player/Lunar Blessing Icon/Lunar Glow"

const SHOPKEEPER_VOICE = preload("uid://c86gce7j7tjey")

var main
const FLOATING_LABEL = preload("uid://dwf6g2wuj1oe3")
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var particle_manager: Node2D = $"../ParticleManager"
@onready var vignette: CanvasModulate = $"../Vignette"
@onready var vignetter: PointLight2D = $"../Vignetter"
@onready var sun_moon_counter: Label = $"../Battle UI/Turn Calculation Box/Sun Moon Count"
const SPEND_DAMAGE_PARTICLE = preload("uid://dmgnoylltbfre")
const THRIFT_DAMAGE_PARTICLE = preload("uid://bvrulyxw02bom")
const DEBT_DAMAGE_PARTICLE = preload("uid://1g21u656k60k")
@onready var status: Label = $Status

@onready var drowse_effect: TextureRect = $"../Drowse Effect"
@onready var dazzled_effect: TextureRect = $"../Dazzled Effect"
@onready var dazzled_light: PointLight2D = $"../Dazzled Effect/Dazzled Light"
@onready var pair_count: Label = $"../Battle UI/Turn Calculation Box/Pair Count"

var drowse_color = Color("#0059a89f")
var dazzle_color = Color("#fb16ff24")
@onready var player_reserve_rug: TextureRect = $"../Player/Player Reserve Rug"

const COIN = preload("uid://ddet242jm5v23")


#SOUNDS
const PASSIVE_REFUND = preload("uid://bubbbm2g4luge")
const CRITICAL = preload("uid://nnwjjtfxt47l")
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
const PASSIVE_COIN_SNIPE = preload("uid://b0rkegpstg6g4")
const SHOPKEEPER_BATTLE_VOICE = preload("uid://cec837paqvvj")
const PIGGY = preload("uid://hpygqai2v7qw")

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
const VOID_ADDED_PARTICLE = preload("uid://dwpakh5cjl3k5")

var sun_count = 0
var moon_count = 0


#ENEMY STATS
var has_fully_paid = false #Fully Paid Turn. Else, Scroll Counter Turn.
var has_scroll_turn = false #Merchant Scroll Turn
var has_keeper_turn = false #Gains a Turn after Coin Caster if this is true
var greed = false
var trust = 0 #The higher the trust, the more potent the attack.
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

var has_audit = false #For each DEBT Settled by the opposing side, apply 1 GAIN to self.
var has_radiant = false #At the end of each turn, each Coin has a 50% Chance to be SHINED.
var has_benchmark = false #Can only play the same amount of Coins by the opposing side.
var settle = 0 #Whenever a DEBT was cleared, detonate settle as Damage.

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
	
var flip_clicks = 0
var sun_sun_count = 0
var moon_moon_count = 0
var sun_moon_count = 0
var upgraded_flip_count = 0

var vignette_default = '#bdabb8'
var vignetter_default = '#ffe6909e'
var sun_caster_color = '#e56400'
var moon_caster_color = '#1a54fb'
var dawn_stance = '#ffcda0'
var dusk_stance = '#8dacf7'
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


func refresh_start_of_battle_stats():
	coin = 0
	has_audit = false
	has_benchmark = false
	has_radiant = false
	settle = 0
	gain = 0
	debt = 0
	thrift = 0
	spend = 0
	current_played_coin = 0
	status.text = "NO DEBT YET."
	max_playable_coins = 0

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

func setup(m):
	status.text = "TIME TO PREPARE."
	main = m
	max_coin = 999
	coin = 0
	max_playable_coins = 2
	silver_flip_rate = 0.0
	gold_flip_rate = 1.0
	


func flip():
	flip_clicks += 1
	main.sound_manager.play_sound(COIN_FLIP)
	var state = 0
	if !has_fully_paid and flip_clicks % 2 == 1:
		state = 1
	if main.player.solar_blessing and flip_clicks % 2 == 1:
		state = 0;
	if main.player.lunar_blessing and flip_clicks % 2 == 0:
		state = 1;
		
	take_damage(1)
	current_played_coin += 1
	
	var c = COIN.instantiate()
	c.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
		
	if has_fully_paid:
		c.upgrade_to_gold()
	else:
		c.is_stamped = true
	c.add_to_group("keeper_coins")
	add_child(c);
	main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,c.global_position)
	
	
	if main.player.has_coin_snipe and c.base_value > 2:
		main.player.trigger_temp_passive("coin_snipe","COIN SNIPE")
		main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
		main.enemy.take_damage(1)
		create_floating_label(1,"DAMAGE","ENEMY")

	if c.base_value > 2:
		upgraded_flip_count += 1
	
	if main.enemy.coin > 0 and main.player.has_triple_nickel and upgraded_flip_count % 10 == 0  and upgraded_flip_count != 0:
		main.player.trigger_temp_passive("triple_nickel","COIN BARRAGE")
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		main.sound_manager.play_sound(DAMAGE_HEAVY)
		main.enemy.take_damage(10)
		create_floating_label(10,"DAMAGE","ENEMY")
		upgraded_flip_count = 0

func keeper_coin_calculation():
	pair_count.text = ""
	var is_left = true # true - Left Coin, false - Right Coin
	var left_coin
	var right_coin
	var total_damage = 0
	var total_gain = 0
	var total_debt = 0
	var total_thrift = 0
	var total_spend = 0
	
	var all_sun_moon = true
	var shined_sun_boost = 0
	var shined_moon_boost = 0
	var void_count = 0
	
	sun_sun_count = 0
	moon_moon_count = 0
	sun_moon_count = 0
	
	sun_count = 0
	moon_count = 0
	
	if trust > 2:
		total_thrift += 2

	var coins = get_tree().get_nodes_in_group("keeper_coins")
	for coin in coins:
		if trust > 1:
			total_spend += 1
		if coin.status == CoinStatus.VOIDED:
			void_count += 1
		if is_left == true:
			left_coin = coin
		if is_left == false:
			right_coin = coin
		if coin.state == 0 and !coin.reserved:
			sun_count += 1
			if coin.status == CoinStatus.SHINED: 
				shined_sun_boost += 3 + coin.shine_stack
		elif coin.state == 1 and !coin.reserved:
			moon_count +=1
			if coin.status == CoinStatus.SHINED:
				shined_moon_boost += 3 + coin.shine_stack
		if coin.status == CoinStatus.VOIDED:
			coin.base_value = 0
		if left_coin != null and right_coin != null and left_coin.reserved == false and right_coin.reserved == false:
			# 1. HEAD-HEAD PAIR
			if left_coin.state == 0 and right_coin.state == 0:
				total_damage += (left_coin.base_value + right_coin.base_value)
				all_sun_moon = false
				sun_sun_count +=1
			# 2. TAIL-TAIL PAIR
			elif left_coin.state == 1 and right_coin.state == 1:
				total_gain += (left_coin.base_value + right_coin.base_value)
				all_sun_moon = false
				moon_moon_count += 1
			# 3. HEAD-TAIL PAIR
			elif left_coin.state == 0 and right_coin.state == 1:
				total_damage += (left_coin.base_value / 2)
				total_gain += (right_coin.base_value / 2)
				if main.player.has_lending_charge: total_debt += 3
				sun_moon_count += 1
			else:
				total_damage += (right_coin.base_value / 2)
				total_gain += (left_coin.base_value / 2)
				if main.player.has_lending_charge: total_debt += 3
				sun_moon_count += 1
			left_coin = null
			right_coin = null
		else:
			pass
		is_left = !is_left

	if main.player.has_lending_charge and all_sun_moon:
		total_debt *= 2
	var text = ""

	#TURN SPELL PARTICLES
	
	var damage_potency:int = ceil(total_damage / 5)
	var gain_potency:int = ceil(total_gain / 5)
	var debt_potency:int = ceil(total_debt / 5)
	var thrift_potency:int = total_thrift
	var spend_potency:int = ceil(total_spend/3)
	if damage_potency == 0:
		main.turn_damage_particle.emitting = false
	else:
		main.turn_damage_particle.emitting = true
	if gain_potency == 0:
		main.turn_gain_particle.emitting = false
	else:
		main.turn_gain_particle.emitting = true
	if debt_potency == 0:
		main.turn_debt_particle.emitting = false
	else:
		main.turn_debt_particle.emitting = true
	if thrift_potency == 0:
		main.turn_thrift_particle.emitting = false
	else:
		main.turn_thrift_particle.emitting = true
	if spend_potency == 0:
		main.turn_spend_particle.emitting = false
	else:
		main.turn_spend_particle.emitting = true
	main.turn_tally_particle.emitting = false
	main.turn_damage_particle.amount = 6 * (damage_potency)
	main.turn_gain_particle.amount = 6 * (gain_potency)
	main.turn_debt_particle.amount = 6 * (debt_potency)
	main.turn_thrift_particle.amount = 6 * (thrift_potency)
	main.turn_spend_particle.amount = 6 * (spend_potency)
	
	if coins != null:
		if total_damage != 0: 
			text += "\nDAMAGE: " + str(total_damage)
			if shined_sun_boost > 0:
				text += " (+" + str(shined_sun_boost) + ")"
		if total_gain != 0:
			text += "\nGAIN: " + str(total_gain)
			if shined_moon_boost > 0:
				text += " (+" + str(shined_moon_boost) + ")"
		if total_debt != 0:
			text += "\nDEBT: " + str(total_debt)
		if total_thrift != 0:
			text += "\nTHRIFT: " + str(total_thrift)
		if total_spend != 0:
			text += "\nSPEND: " + str(total_spend)
		if main.player.has_lucky_pair and sun_sun_count > 0:
			pair_count.text += "\n" + str(sun_sun_count) + " 𖤓 𖤓"
		if main.player.has_lending_charge and sun_moon_count > 0:
			pair_count.text += "\n" + str(sun_moon_count) + " 𖤓 ☾"
		if main.player.has_simple_interest and moon_moon_count > 0:
			pair_count.text += "\n" + str(moon_moon_count) + " ☾ ☾"
		main.turn_calculation.text = text
		main.turn_calculation.add_theme_color_override("font_color", Color.WHITE)
	else: 
		main.turn_calculation.text = ""
	if text != "":
		sun_moon_counter.text = "𖤓 " + str(sun_count) + " ☾ " + str(moon_count)
		main.turn_calculation_box.entrance(true)
	return [total_damage,total_gain,total_debt,total_thrift, total_spend, shined_sun_boost, shined_moon_boost, void_count]

func start_keeper_turn():
	main.sound_manager.play_sound(SHOPKEEPER_BATTLE_VOICE)
	flip_clicks = 0
	upgraded_flip_count = 0
	toggle_button(main.flip_button,true)
	toggle_button(main.re_flip_button,true)
	main.endTurn_button.disabled = true

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
	
	if settle > 0 and debt == 0:
		particle_manager.trigger_attack(main.coin_deck, main.player_portrait, turn_damage, "")
		await get_tree().create_timer(1.0).timeout
		main.player.take_damage(settle)
		main.sound_manager.play_sound(DAMAGE_HEAVY)
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.player_portrait.global_position)



	#Reset Keeper Stats
	current_played_coin = 0
	
	main.turn_calculation.text = ""
	
	var flip_speed = 0.2
	#FLIP COINS
	if main.player.coin == 0:
		return
	if coin > 0:
		await get_tree().create_timer(1.0).timeout
		while current_played_coin != max_playable_coins:
			if coin > 0:
				flip()
				keeper_coin_calculation()
			else:
				break
			await get_tree().create_timer(flip_speed).timeout
		await get_tree().create_timer(1.0).timeout
		await end_turn()


func activate_turn_end_passives():

	var has_dazzle = false
	var coins = get_tree().get_nodes_in_group("keeper_coins")
	for coin in coins:
		if coin.status == CoinStatus.DAZZLED:
			has_dazzle = true
			if coin.state == 0:
				coin.state = 1
			else:
				coin.state = 0
			coin.add_status(CoinStatus.NONE)
			coin.refresh_sprite()
			main.sound_manager.play_sound(COIN_FLIP)
			keeper_coin_calculation()
			if main.player.has_impromptu_flip:
				main.player.trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
				main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
				main.sound_manager.play_sound(DAMAGE_LIGHT)
				main.enemy.take_damage(1)
				create_floating_label(1,"DAMAGE","ENEMY")
			await get_tree().create_timer(0.1).timeout
	if has_dazzle:
		await get_tree().create_timer(0.6).timeout
	if main.enemy.coin == 0:
		return
		

	if main.player.has_magic_trick and current_played_coin >= 8:
		main.player.trigger_temp_passive("magic_trick","MAGIC TRICK")
		coins = get_tree().get_nodes_in_group("keeper_coins")
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
				if main.player.has_impromptu_flip:
					main.player.trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(1)
					create_floating_label(1,"DAMAGE","ENEMY")
				if main.player.has_coin_snipe:
					main.player.trigger_temp_passive("coin_snipe","COIN SNIPE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
					main.enemy.take_damage(3)
					create_floating_label(3,"DAMAGE","ENEMY")
				keeper_coin_calculation()
				await get_tree().create_timer(0.1).timeout
			if index == 4 or index == 6 or index == 8:
				coin.copy_coin(second_coin)
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				if main.player.has_impromptu_flip:
					main.player.trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(1)
					create_floating_label(1,"DAMAGE","ENEMY")
				if main.player.has_coin_snipe:
					main.player.trigger_temp_passive("coin_snipe","COIN SNIPE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
					main.enemy.take_damage(3)
					create_floating_label(3,"DAMAGE","ENEMY")
				keeper_coin_calculation()
				await get_tree().create_timer(0.1).timeout
		keeper_coin_calculation()
		await get_tree().create_timer(0.6).timeout
		if main.enemy.coin == 0:
			return
	if main.player.has_advanced_planning:
		main.player.trigger_temp_passive("advanced_planning","SEAL OF APPROVAL")
		coins = get_tree().get_nodes_in_group("keeper_coins")
		var index = 0
		for coin in coins:
			if coin.is_stamped:
				coin.is_stamped = false
				if main.player.has_inflation and coin.base_value == 6:
					if coin.status == CoinStatus.SHINED:
						coin.shine_stack += 1
					else:
						coin.add_status(CoinStatus.SHINED)
				coin.upgrade()
				if coin.status == CoinStatus.VOIDED:
					coin.status = coin.initial_status
					if main.player.has_pay_down:
						main.player.debted_attack += 2
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				if main.player.has_impromptu_flip:
					main.player.trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(1)
					create_floating_label(1,"DAMAGE","ENEMY")
				keeper_coin_calculation()
				await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(0.6).timeout
		if main.enemy.coin == 0:
			return
			
	if main.player.has_simple_interest and moon_moon_count > 0: 
		main.player.trigger_temp_passive("simple_interest","SIMPLE INTEREST")
		for coin in coins:
			#PRIORITY 1: UNSHINED MOON COINS
			if coin.state == 1 and moon_moon_count > 0 and coin.status != CoinStatus.SHINED:
				coin.add_status(CoinStatus.SHINED)
				moon_moon_count -= 1
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				if main.player.has_impromptu_flip:
					main.player.trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(1)
					create_floating_label(1,"DAMAGE","ENEMY")
				await get_tree().create_timer(0.1).timeout
			if moon_moon_count == 0: break
		
		if moon_moon_count > 0:
			for coin in coins:
				#PRIORITY 2: SHINED MOON COINS (No Remaining Unshined Left)
				if coin.state == 1 and moon_moon_count > 0:
					if main.player.has_inflation and coin.base_value == 6:
						coin.shine_stack += 1
					moon_moon_count -= 1
					coin.refresh_sprite()
					main.sound_manager.play_sound(COIN_FLIP)
					if main.player.has_impromptu_flip:
						main.player.trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
						main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
						main.sound_manager.play_sound(DAMAGE_LIGHT)
						main.enemy.take_damage(1)
						create_floating_label(1,"DAMAGE","ENEMY")
					await get_tree().create_timer(0.1).timeout
				if moon_moon_count == 0: break
		keeper_coin_calculation()
		await get_tree().create_timer(0.6).timeout
		if main.enemy.coin == 0:
			return

	if main.player.has_lucky_pair and sun_sun_count > 0:
		main.player.trigger_temp_passive("lucky_pair","GOLD RUSH")
		
		#PRIORITY 1: UNUPGRADED COINS
		for coin in coins:
			if  sun_sun_count > 0 and coin.base_value < 6:
				coin.upgrade_to_gold()
				sun_sun_count -= 1
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				if main.player.has_impromptu_flip:
					main.player.trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(1)
					create_floating_label(1,"DAMAGE","ENEMY")
				await get_tree().create_timer(0.1).timeout
			if sun_sun_count == 0: break
				
		#PRIORITY 2: UNSHINED GOLD COINS
		if sun_sun_count > 0:
			for coin in coins:
				if sun_sun_count > 0 and coin.status == CoinStatus.NONE:
					if main.player.has_inflation:
						coin.add_status(CoinStatus.SHINED)
					sun_sun_count -= 1
					coin.refresh_sprite()
					main.sound_manager.play_sound(COIN_FLIP)
					if main.player.has_impromptu_flip:
						main.player.trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
						main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
						main.sound_manager.play_sound(DAMAGE_LIGHT)
						main.enemy.take_damage(1)
						create_floating_label(1,"DAMAGE","ENEMY")
					await get_tree().create_timer(0.1).timeout
				if sun_sun_count == 0: break
		
		#PRIORITY 3: SHINED GOLD COINS
		if sun_sun_count > 0:
			for coin in coins:
				if coin.state == 0 and sun_sun_count > 0:
					if main.player.has_inflation:
						coin.shine_stack += 1
					sun_sun_count -= 1
					coin.refresh_sprite()
					main.sound_manager.play_sound(COIN_FLIP)
					if main.player.has_impromptu_flip:
						main.player.trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
						main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
						main.sound_manager.play_sound(DAMAGE_LIGHT)
						main.enemy.take_damage(1)
						create_floating_label(1,"DAMAGE","ENEMY")
					await get_tree().create_timer(0.1).timeout
				if sun_sun_count == 0: break
		keeper_coin_calculation()
		await get_tree().create_timer(0.6).timeout
		if main.enemy.coin == 0:
			return


func end_turn():
	
	main.turn_damage_particle.emitting = false
	main.turn_gain_particle.emitting = false
	main.turn_debt_particle.emitting = false
	main.turn_thrift_particle.emitting = false
	main.turn_spend_particle.emitting = false
	main.turn_tally_particle.emitting = false
	
	#TURN END PASSIVES
	await activate_turn_end_passives()
	
	
	var keeper_tween = create_tween()
	keeper_tween.tween_property(keeper_shadow,"self_modulate", Color("00000096"),0.6)

	main.coin_deck.sigil_pressed();
	if main.enemy.coin == 0: return
	
	# ==========================================
	# PHASE 1: MATH & LOGIC (Instantly calculate everything)
	# ==========================================
	var calculations = keeper_coin_calculation()
	var turn_damage:int = calculations[0] + calculations[5]
	var turn_gain:int = calculations[1] + calculations[6]
	var turn_debt = calculations[2]
	var turn_thrift = calculations[3]
	var turn_spend = calculations[4]
	var turn_void = calculations[7]
	
	# 1. Apply Stats to Player
	thrift = 0
	spend = 0
	
	
	main.player.gain += turn_gain
	max_playable_coins = initial_max_playable_coins
	
	
	# 3. Twilight Sage Logic

	# 4. Tracking / High Scores
	main.total_damage_dealt += turn_damage
	if turn_damage > main.highest_damage_dealt: main.highest_damage_dealt = turn_damage

	# 5. Piggy & Reserve Logic
	main.reserve_left_over_coin()
	var coins = get_tree().get_nodes_in_group("keeper_coins")
	var is_left = true
	var latest_pair_left_coin
	var latest_pair_right_coin
	if main.player.has_piggy:
		main.sound_manager.play_sound(PIGGY)
		latest_pair_left_coin = COIN.instantiate()
		latest_pair_right_coin = COIN.instantiate()
		
	for coin in coins:
		if main.player.has_piggy and is_left and !coin.reserved:
			latest_pair_left_coin.copy_coin(coin)
			is_left = false
		elif main.player.has_piggy and !is_left and !coin.reserved:
			latest_pair_right_coin.copy_coin(coin)
			is_left = true
		if coin.reserved == false:
			main.particle_manager.spawn_particle(COIN_PLAY_PARTICLE,coin.global_position)
			coin.queue_free()
			
	if main.player.has_piggy:
		main.player.trigger_temp_passive("piggy","PIGGY")
		var type = latest_pair_left_coin.type
		latest_pair_left_coin.setup(latest_pair_left_coin.state,main.coin_deck.get_reserve_slot())
		latest_pair_left_coin.reserved = true
		latest_pair_left_coin.type = type
		latest_pair_left_coin.status = CoinStatus.SHINED
		latest_pair_left_coin.initial_status = CoinStatus.SHINED
		latest_pair_left_coin.add_to_group("reserved coins")
		add_child(latest_pair_left_coin)
		
		if main.player.has_coin_snipe:
			main.player.trigger_temp_passive("coin_snipe","COIN SNIPE")
			main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
			main.enemy.take_damage(3)
			create_floating_label(3,"DAMAGE","ENEMY")

		type = latest_pair_right_coin.type
		latest_pair_right_coin.setup(latest_pair_right_coin.state,main.coin_deck.get_reserve_slot())
		latest_pair_right_coin.reserved = true
		latest_pair_right_coin.type = type
		latest_pair_right_coin.status = CoinStatus.SHINED
		latest_pair_right_coin.initial_status = CoinStatus.SHINED
		latest_pair_right_coin.add_to_group("reserved coins")
		add_child(latest_pair_right_coin)
		main.player.current_reserve += 2
		
		if main.player.has_simple_interest: 
			gain += 2
			main.player.trigger_temp_passive("simple_interest","SIMPLE INTEREST")
	
		if main.player.has_coin_snipe:
			main.player.trigger_temp_passive("coin_snipe","COIN SNIPE")
			main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
			main.enemy.take_damage(3)
			create_floating_label(3,"DAMAGE","ENEMY")

	#DOUBLE CHECK FOR LEFT OVERS
	if coins.size() > 0:
		for c in coins:
			c.queue_free()
			
	# Determine if enemy is immune to debt before applying
	var is_debt_immune = (main.enemy.type == Enemy.COLLECTOR) and greed
	
	# ==========================================
	# PHASE 2: VISUALS & ANIMATIONS (Play all the eye-candy!)
	# ==========================================
	
	main.sound_manager.play_sound(COIN_ENDTURN)
	particle_manager.despawn_emitting_particles()

	
	main.turn_calculation_box.exit()

	# -- 1. Trigger Simultaneous Firing (Shooting out of the deck) --
	if turn_damage > 0:
		main.sound_manager.play_sound(COIN_ATTACK_PARTICLE)
		particle_manager.trigger_attack(main.coin_deck, main.enemy_portrait, turn_damage, "")
		# I removed the hit particles and sound effects from here!

	if turn_debt > 0:
		main.sound_manager.play_sound(DEBTED_ATTACK)
		particle_manager.trigger_attack(main.coin_deck, main.enemy_portrait, turn_debt, "DEBT")
		# I moved the IMMUNE label to the bottom!

	if turn_thrift > 0:
		main.sound_manager.play_sound(THRIFTED_ATTACK)
		particle_manager.trigger_attack(main.coin_deck, main.enemy_portrait, turn_thrift, "THRIFT")

	if turn_spend > 0:
		main.sound_manager.play_sound(SPENDED_ATTACK)
		particle_manager.trigger_attack(main.coin_deck, main.enemy_portrait, turn_spend, "SPEND")
		
	# -- The Pause --
	# Wait 1 second for the particles to fly across the screen BEFORE showing the impacts
	if turn_damage > 0 or turn_debt > 0 or turn_thrift > 0 or turn_spend > 0:
		await get_tree().create_timer(1.0).timeout

	var shake_power = 0
	# -- 2. Final Hit Impacts & Floating Labels (The runes have arrived!) --
	if turn_damage > 0:
		
		# I pasted the hit particles and sounds here!
		main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		if turn_damage <= 10: 
			main.sound_manager.play_sound(DAMAGE_LIGHT)
			shake_power += 0.25
		elif turn_damage <= 20: 
			main.sound_manager.play_sound(DAMAGE_MODERATE)
			shake_power += 0.5
		else: 
			main.sound_manager.play_sound(DAMAGE_HEAVY)
			shake_power += 1
		create_floating_label(turn_damage,"DAMAGE","ENEMY")
		
	if turn_debt > 0:
		if is_debt_immune:
			create_floating_label("DEBT","IMMUNE","ENEMY")
			main.sound_manager.play_sound(PASSIVE_REFUND)
		else:
			main.particle_manager.spawn_particle(DEBT_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			shake_power += 0.5
			main.sound_manager.play_sound(DEBT)
			create_floating_label(turn_debt,"DEBT","ENEMY")
			
	if turn_thrift > 0:
		shake_power += 0.5
		main.particle_manager.spawn_particle(THRIFT_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		main.sound_manager.play_sound(THRIFT)
		create_floating_label(turn_thrift,"THRIFT","ENEMY")
		
	if turn_spend > 0:
		shake_power += 0.5
		main.particle_manager.spawn_particle(SPEND_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		main.sound_manager.play_sound(SPEND)
		create_floating_label(turn_spend,"SPEND","ENEMY")
	
	camera_2d.add_trauma(shake_power)
	if turn_damage >= 30:
		main.sound_manager.play_sound(CRITICAL)
		var slow_motion = create_tween()
		slow_motion.tween_property(Engine, "time_scale", 0.1, 0)
		slow_motion.tween_property(Engine, "time_scale", 1, 0.5)
	# 2. Apply Stats to Enemy
	main.enemy.take_damage(turn_damage)
	main.enemy.debt += turn_debt
	main.enemy.thrift += turn_thrift
	main.enemy.spend += turn_spend
	
	has_fully_paid = false
	
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
