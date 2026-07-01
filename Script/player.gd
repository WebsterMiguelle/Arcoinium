extends Node2D

enum Turn {
	PLAYER,
	ENEMY
}
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


@onready var keeper_shadow: TextureRect = $"../Shopkeeper/Keeper Shadow"
@onready var pair_count: Label = $"../Battle UI/Turn Calculation Box/Pair Count"

@onready var camera_2d: Camera2D = $"../Camera2D"
const FLOATING_LABEL = preload("uid://dwf6g2wuj1oe3")
@onready var all_in: Label = $"../Battle UI/All In"
var vignette_default = '#bdabb8'
var vignetter_default = '#ffe6909e'
@onready var sun_moon_counter: Label = $"../Battle UI/Turn Calculation Box/Sun Moon Count"

signal hp_changed(new_hp)
@onready var player_portrait: AnimatedSprite2D = $Player_Portrait
var active_temp_ids: Dictionary = {}
@onready var passives_bar: GridContainer = $"../Battle UI/PassivesBar"
@onready var player_health_bar_2: Button = $"../Battle UI/PlayerHealthBar2"
#SCENES
const PASSIVE_BAR_ICON = preload("res://Scene/Passive_Bar_Icon.tscn")
@onready var drowse_effect: TextureRect = $"../Drowse Effect"
@onready var dazzled_effect: TextureRect = $"../Dazzled Effect"
@onready var dazzled_light: PointLight2D = $"../Dazzled Effect/Dazzled Light"
@onready var tally_effect: TextureRect = $"../Tally Effect"
@onready var tally_flip_count: Label = $"../Tally Effect/Tally Flip Count"

@onready var solar_blessing_icon: AnimatedSprite2D = $"Solar Blessing Icon"
@onready var solar_glow: TextureRect = $"Solar Blessing Icon/Solar Glow"
@onready var lunar_blessing_icon: AnimatedSprite2D = $"Lunar Blessing Icon"
@onready var lunar_glow: TextureRect = $"Lunar Blessing Icon/Lunar Glow"
@onready var extra_turn_effect: TextureRect = $"../Extra Turn Effect"
@onready var all_in_effect: TextureRect = $"../All In Effect"
@onready var piggy: Node2D = $"../Piggy"

var piggy_x = 943.21
var piggy_y = 259.925

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
const DEBT = preload("uid://cuwgygacdm7dj")
const PASSIVE_PAYBACK = preload("uid://bbsxs62yhirxa")
const CRITICAL = preload("uid://nnwjjtfxt47l")

const COIN_ATTACK_PARTICLE = preload("uid://djmpd27qq4nn1")
const THRIFT = preload("uid://b34wg18n8eb0t")
const THRIFT_FLAME = preload("uid://kld7c6qpdho7")
const SPEND = preload("uid://bvbtrait4prdi")
const SPENDED_FLIP = preload("uid://dgu0hy8kwo343")
const GAIN_EFFECT = preload("uid://cr366klr6aivy")
const DEBT_EFFECT = preload("uid://d18qgeounkatf")
const DEBTED_ATTACK = preload("uid://ddf31ka4126fv")
const SPENDED_ATTACK = preload("uid://lfprp4w7saas")
const THRIFTED_ATTACK = preload("uid://dtx4a0j6atomh")
const SPEND_DAMAGE_PARTICLE = preload("uid://dmgnoylltbfre")
const THRIFT_DAMAGE_PARTICLE = preload("uid://bvrulyxw02bom")
const DEBT_DAMAGE_PARTICLE = preload("uid://1g21u656k60k")
const SLOW = preload("uid://f5jmno7qyhek")

const ALL_IN = preload("uid://lwuew0lbc6d7")
const ALL_IN_STAMP = preload("uid://bo7ip21oxj6eq")
const PIGGY = preload("uid://hpygqai2v7qw")
const VOIDED = preload("uid://ctvrb7nmqgd06")
const VOID_CLEANSE = preload("uid://bjqr2dvvwifnq")
const CASH_OUT = preload("uid://dm2mpsfe2sli8")
const DAZZLE = preload("uid://b3o76gt2qs7pj")


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
const VOID_REMOVED_PARTICLE = preload("uid://b360j7dt7jml1")
const INFLATION_PARTICLE = preload("uid://bq67mkmrnr14p")
const COIN_BARRAGE_PARTICLE = preload("uid://btjsmqynj8nhe")

const SPARE_CHANGE_PARTICLE = preload("uid://bn1a4qhm1md")
const SPARE_CHANGE_RE_FLIP_PARTICLE = preload("uid://1go5ifrar23k")
const PICKPOCKET_PARTICLE = preload("uid://gtmo80f6bhex")

@onready var pickpocket: Marker2D = $"../Pickpocket"
@onready var spare_change: Marker2D = $"../SpareChange"
@onready var spare_change_reflip: Marker2D = $"../SpareChangeReflip"

#PLAYER STATS
var greed = false
var max_coin = 1000 #Max Coin Capacity
var initial_max_reserve
var max_reserve = 6
var current_reserve = 0:
	set(value):
		current_reserve = clamp(value,0,999)
var coin = 100:
	set(value):
		coin = clamp(value,0,max_coin)
		hp_changed.emit(coin)
var initial_max_playable_coins
var max_playable_coins: = 16 #Max Flips Per Turn
var current_played_coin: = 0: #Current Flip Count
	set(value):
		current_played_coin = clamp(value,0,max_playable_coins)
var max_re_flip = 3 #Max Re-Flips Per Turn
var current_re_flip = 0 #Current Re-Flip Count
var silver_flip_rate = 0.1: #Chance to Flip a Silver Coin
	set(value): 
		silver_flip_rate = clamp(value,0.0,100.0) 
var gold_flip_rate = 0.05: #Chance to Flip a Gold Coin
	set(value): 
		gold_flip_rate = clamp(value,0.0,100.0) 

#STATUS EFFECTS
var settle = 0 #Whenever a DEBT was cleared, detonate settle as Damage.
var starstruck = false #Play Dazzled Coins
var tally = false #Enables Tally Counter
var tally_counter = 0 #If this reaches zero, automatically end the turn.
var lock = false #Reserve is Locked
var slow = false #Re-Flip on each Coin only works 50% at a time.
var sealed = false #Odd Flips are STAMPED
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

var previous_player_flips = 0
var player_turn_count = 0
var sun_count = 0
var moon_count = 0
var has_extra_turn = false
var thrifted_attack = 0
var debted_attack = 0
var spended_attack = 0
var has_all_in = false

var solar_blessing = false
var lunar_blessing = false

var sun_sun_count = 0
var moon_moon_count = 0
var sun_moon_count = 0
var upgraded_flip_count = 0

#GENERAL PASSIVES

#B-Rank
@export var has_wishbone = false
@export var has_golden_clover = false
@export var has_solar_coin = false
@export var has_lunar_coin = false
@export var has_merchant_scroll = false
@export var has_impromptu_flip = false
@export var has_advanced_planning = false #Note: This is SEAL OF APPROVAL

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
@export var has_refund = false #Note: This is ALL IN
@export var has_coin_snipe = false

#INVESTOR PASSIVES

@export var has_active_income = false  #Note: This is FULLY PAID
@export var has_pocket_money = false
@export var has_passive_income = false
@export var has_simple_interest = false

#DEBTOR PASSIVES

@export var has_pay_down = false #Note: This is BANKRUPT
@export var has_reimbursement = false #Note: This is TAX EVASION
@export var has_loan_shark = false
@export var has_lending_charge = false

#BANKER PASSIVES

@export var has_cash_out = false
@export var has_dividend = false
@export var has_withdraw = false
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
	var has_debt = false
	if has_active_income and debt > 0: has_debt = true
	gain -= debt
	debt -= temp
	coin += gain

	if has_active_income and has_debt and debt == 0 and main.enemy.coin > 0:
		has_debt = false
		main.shopkeeper.has_keeper_turn = true
		main.shopkeeper.status.text = "I AM READY TO FLIP."
		main.shopkeeper.coin = main.shopkeeper.max_playable_coins
		main.shopkeeper.has_fully_paid = true
		
		var keeper_tween = create_tween()
		keeper_tween.tween_property(keeper_shadow,"self_modulate", Color("85007396"),0.2)
	
	if gain > 0:
		if temp2 != 0 and main.enemy.has_audit:
			main.enemy.gain += temp2
		particle_manager.spawn_particle(GAIN_EFFECT_PARTICLE,main.player_gain.global_position)
		main.sound_manager.play_sound(GAIN_EFFECT)
	elif debt > 0:
		if has_active_income and !main.shopkeeper.has_keeper_turn:
			main.shopkeeper.status.text = "SETTLE YOUR DEBT."
		if greed and main.enemy.has_audit:
			main.enemy.gain += temp
		particle_manager.spawn_particle(DEBT_EFFECT_PARTICLE,main.player_debt.global_position)
		main.sound_manager.play_sound(DEBT_EFFECT)
	gain = 0
	print("Player HP: ", coin)

func reset_stats():
	greed = PlayerSingleton.greed
	max_coin = 999 #Max Coin Capacity
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
	has_solar_coin = false #Note: This is SOLAR BLESSING
	has_lunar_coin = false #Note: This is LUNAR BLESSING
	has_merchant_scroll = false #Note: This is KEEPER'S SCROLL
	has_impromptu_flip = false  #Note: This is FLIP SEQUENCE
	has_advanced_planning = false #Note: This is SEAL OF APPROVAL

	#A-Rank
	has_magic_trick = false
	has_sleight_of_hand = false #Note: This is PICKPOCKET
	has_piggy = false

	#INNOVATOR PASSIVES

	has_inflation = false
	has_payback = false
	has_lucky_pair = false #Note: This is Now Gold Rush
	has_value_increase = false

	#SHOOTER PASSIVES
	has_spare_change = false 
	has_triple_nickel = false #Note: This is COIN BARRAGE
	has_refund = false #Note: This is ALL IN
	has_coin_snipe = false

	#INVESTOR PASSIVES

	has_active_income = false #Note: This is FULLY PAID
	has_pocket_money = false
	has_passive_income = false
	has_simple_interest = false #Note: This is FULL MOON

	#DEBTOR PASSIVES

	has_pay_down = false #Note: This is BANKRUPT
	has_reimbursement = false #Note: This is TAX EVASION
	has_loan_shark = false
	has_lending_charge = false

	has_cash_out = false
	has_dividend = false
	has_withdraw = false
	has_deposit = false

func refresh_start_of_battle_stats():
	if has_piggy:
		piggy.visible = true
		piggy.setup(piggy_x,piggy_y,main)
	else:
		piggy.visible = false
	sealed = false
	settle = 15
	initial_max_reserve = max_reserve
	lock = false
	tally = false
	tally_effect.visible = false
	tally_counter = 0
	has_all_in = false
	thrifted_attack = 0
	debted_attack = 0
	spended_attack = 0
	has_extra_turn = false
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
	
	solar_blessing = false
	lunar_blessing = false
	solar_glow.visible = false
	lunar_glow.visible = false
	
	if has_solar_coin:
		solar_blessing_icon.visible = true
	else:
		solar_blessing_icon.visible = false
	
	if has_lunar_coin:
		lunar_blessing_icon.visible = true
	else:
		lunar_blessing_icon.visible = false
		
	if has_pay_down:
		player_health_bar_2.change_to_void()
	starstruck = false
	
	has_all_in = false
	var all_in_tween = create_tween()
	all_in_tween.tween_property(all_in_effect,"self_modulate", Color("ffffff00"),0.6)
	await all_in_tween.finished
	all_in_effect.visible = false
	
	var keeper_tween = create_tween()
	keeper_tween.tween_property(keeper_shadow,"self_modulate", Color("00000096"),0.6)
	
	var dazzled_tween = create_tween()
	dazzled_tween.parallel().tween_property(dazzled_effect,"self_modulate", Color("#0059a800"),0.6)
	dazzled_tween.parallel().tween_property(dazzled_light,"color", Color("#0059a800"),0.6)
	await dazzled_tween.finished
	dazzled_effect.visible = false
	dazzled_light.visible = false
	
	slow = false
	var drowse_tween = create_tween()
	drowse_tween.tween_property(drowse_effect,"self_modulate", Color("#0059a800"),0.6)
	await drowse_tween.finished
	drowse_effect.visible = false
	
	has_extra_turn = false
	var extra_tween = create_tween()
	extra_tween.tween_property(extra_turn_effect,"self_modulate", Color("ffffff00"),0.6)
	await extra_tween.finished
	extra_turn_effect.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player_portrait.play("default")
	all_in.text = ""

	var pulse_timer = Timer.new()
	pulse_timer.wait_time = 8.0 
	
	pulse_timer.autostart = true
	pulse_timer.timeout.connect(trigger_board_pulse)
	add_child(pulse_timer)


func coin_calculation():
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
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if coin.status == CoinStatus.VOIDED:
			void_count += 1
		if is_left == true:
			left_coin = coin
		if is_left == false:
			right_coin = coin
		if coin.state == 0 and !coin.reserved:
			sun_count += 1
			if coin.status == CoinStatus.SHINED: 
				shined_sun_boost += 3 * coin.shine_stack
		elif coin.state == 1 and !coin.reserved:
			moon_count +=1
			if coin.status == CoinStatus.SHINED:
				shined_moon_boost += 3 * coin.shine_stack
		if coin.status == CoinStatus.VOIDED:
			coin.base_value = 0
		if left_coin != null and right_coin != null and left_coin.reserved == false and right_coin.reserved == false:
			# 1. HEAD-HEAD PAIR
			if left_coin.state == 0 and right_coin.state == 0:
				total_damage += (left_coin.base_value + right_coin.base_value)
				all_sun_moon = false
				sun_sun_count += 1
			# 2. TAIL-TAIL PAIR
			elif left_coin.state == 1 and right_coin.state == 1:
				total_gain += (left_coin.base_value + right_coin.base_value)
				all_sun_moon = false
				moon_moon_count += 1
			# 3. HEAD-TAIL PAIR
			elif left_coin.state == 0 and right_coin.state == 1:
				total_damage += (left_coin.base_value / 2)
				total_gain += (right_coin.base_value / 2)
				if has_lending_charge: total_debt += 3
				sun_moon_count += 1
			else:
				total_damage += (right_coin.base_value / 2)
				total_gain += (left_coin.base_value / 2)
				if has_lending_charge: total_debt += 3
				sun_moon_count += 1
			left_coin = null
			right_coin = null
		else:
			pass
		is_left = !is_left
	if thrifted_attack != 0:
		total_thrift += thrifted_attack
	if debted_attack != 0:
		total_debt += debted_attack
	if spended_attack != 0:
		total_spend += spended_attack
		
	if has_lending_charge and all_sun_moon:
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
	pair_count.text = ""
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
		
		if has_lucky_pair and sun_sun_count > 0:
			pair_count.text += "\n" + str(sun_sun_count) + " 𖤓 𖤓"
		if has_lending_charge and sun_moon_count > 0:
			pair_count.text += "\n" + str(sun_moon_count) + " 𖤓 ☾"
		if has_simple_interest and moon_moon_count > 0:
			pair_count.text += "\n" + str(moon_moon_count) + " ☾ ☾"
		main.turn_calculation.text = text
		main.turn_calculation.add_theme_color_override("font_color", Color.WHITE)
	else: 
		main.turn_calculation.text = ""
	if text != "":
		sun_moon_counter.text = "𖤓 " + str(sun_count) + " ☾ " + str(moon_count)
		main.turn_calculation_box.entrance(true)
	return [total_damage,total_gain,total_debt,total_thrift, total_spend, shined_sun_boost, shined_moon_boost, void_count]

func reserve(is_generated = false, pickpocketed = false, dazzled = false):
	if !is_generated and coin == 1:
		return
	
	main.overall_reserved_coins += 1
	print("RESERVE")
	main.sound_manager.play_sound(COIN_FLIP)
	flip_clicks += 1
		
	var state = randi() % 2
	
	if greed and has_sunlit_curse: state = 0
	if greed and has_midnight_curse: state = 1

	if solar_blessing and flip_clicks % 2 == 1:
		state = 0;
	if lunar_blessing and flip_clicks % 2 == 0:
		state = 1;
	if state == 0:
		main.total_heads += 1
	else:
		main.total_tails += 1
	
	var c = COIN.instantiate()
	
	if lock: return
	c.setup(state,main.coin_deck.get_reserve_slot())
	c.reserved = true
	current_reserve += 1
	if pickpocketed:
		var status = randi_range(1,3)
		if status != 2:
			c.add_status(status)
			var void_chance = randi_range(0,1)
			if void_chance == 1:
				c.add_status(CoinStatus.VOIDED)
		else:
			c.add_status(status)
			
		var stamped_chance = randi_range(0,3)
		if stamped_chance == 1:
			c.is_stamped = true
	if sealed and flip_clicks % 2 == 1:
		c.is_stamped = true
	
	if starstruck:
		var dazzle_chance = randi_range(0,1)
		if dazzle_chance == 1:
			c.add_status(CoinStatus.DAZZLED)
			
	
	c.add_to_group("reserved coins")
	#Silver/Gold Flip Rate
	
	var upgrade_chance = randf()

	if upgrade_chance <= silver_flip_rate:
		c.upgrade_to_silver()
		
	upgrade_chance = randf() 
	if upgrade_chance <= gold_flip_rate:
		c.upgrade_to_gold()
	
		
		
	if c.base_value > 2:
		main.sound_manager.play_sound(COIN_UPGRADE)
		if main.enemy.coin > 0 and has_coin_snipe:
			trigger_temp_passive("coin_snipe","COIN SNIPE")
			main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
			if is_generated:
				main.enemy.take_damage(3)
				create_floating_label(3,"DAMAGE","ENEMY")
				main.total_damage_dealt += 3
			else:
				main.enemy.take_damage(1)
				create_floating_label(1,"DAMAGE","ENEMY")
				main.total_damage_dealt += 1

	if !is_generated:
		take_damage(1)
		if has_pay_down:
			c.add_status(CoinStatus.VOIDED)
		if c.base_value > 2:
			upgraded_flip_count += 1
		
		if main.enemy.coin > 0 and has_triple_nickel and upgraded_flip_count % 10 == 0 and upgraded_flip_count != 0:
			trigger_temp_passive("triple_nickel","COIN BARRAGE")
			main.particle_manager.spawn_particle(COIN_BARRAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(DAMAGE_HEAVY)
			main.enemy.take_damage(10)
			main.total_damage_dealt += 10
			create_floating_label(10,"DAMAGE","ENEMY")
			upgraded_flip_count = 0
	
	if dazzled:
		c.add_status(CoinStatus.DAZZLED)
		
	if has_deposit:
		trigger_temp_passive("deposit","DEPOSIT")
		if randi_range(1,5) == 1:
			c.is_stamped = true
		create_floating_label(2,"GAIN","PLAYER")
		gain += 2
		
	main.add_child(c)


	print(current_played_coin)
	if (current_reserve >= max_reserve) or coin == 1:
		toggle_button(main.reserve_button,true)
	if coin == 1 or (current_reserve >= max_reserve and current_played_coin == max_playable_coins):
		toggle_button(main.flip_button,true)
	coin_calculation()
	
	if main.enemy.coin == 0:
		main.check_defeat()
		return
	
	if !is_generated and tally and main.enemy.coin > 0:
		if tally_counter > 0:
			tally_counter -= 1
			if tally_counter == 0:
				await get_tree().create_timer(0.1).timeout
				main.tally_end_turn()
				tally = false
				return
	if coin == 1:
		toggle_button(main.reserve_button,true)
		toggle_button(main.flip_button,true)

func flip():
	
	var is_deck_full = false
	print("FLIP")
	flip_clicks += 1
	if current_re_flip != max_re_flip: 
		toggle_button(main.re_flip_button,false)
		
	var state = randi() % 2
	
	if greed and has_sunlit_curse: state = 0
	if greed and has_midnight_curse: state = 1
	
	if solar_blessing and flip_clicks % 2 == 1:
		state = 0;
	if lunar_blessing and flip_clicks % 2 == 0:
		state = 1;
	if state == 0:
		main.total_heads += 1
	else:
		main.total_tails += 1
	
	if current_played_coin == max_playable_coins: 
		is_deck_full = true	
	current_played_coin += 1
	var c = COIN.instantiate()
	if is_deck_full:
		if lock: return
		c.setup(state,main.coin_deck.get_reserve_slot())
		if sealed and flip_clicks % 2 == 1:
			c.is_stamped = true
		c.reserved = true
		current_reserve += 1
		if starstruck:
			var dazzle_chance = randi_range(0,1)
			if dazzle_chance == 1:
				c.add_status(CoinStatus.DAZZLED)
		c.add_to_group("reserved coins")
		if has_deposit:
			trigger_temp_passive("deposit","DEPOSIT")
			if randi_range(1,5) == 1:
				c.is_stamped = true
			create_floating_label(2,"GAIN","PLAYER")
			gain += 2
	else:
		c.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
		if starstruck:
			var dazzle_chance = randi_range(0,1)
			if dazzle_chance == 1:
				c.add_status(CoinStatus.DAZZLED)
		c.add_to_group("coins")
		if sealed and flip_clicks % 2 == 1:
			c.is_stamped = true
	main.sound_manager.play_sound(COIN_FLIP)

	if current_played_coin <= 2 and has_advanced_planning:
		c.is_stamped = true
	#Silver/Gold Flip Rate
	
	var upgrade_chance = randf()

	if upgrade_chance <= silver_flip_rate:
		c.upgrade_to_silver()
		
	upgrade_chance = randf() 
	if upgrade_chance <= gold_flip_rate:
		c.upgrade_to_gold()
	
		
	if has_pay_down:
		c.add_status(CoinStatus.VOIDED)
	if has_all_in:
		toggle_button(main.re_flip_button,true)
		toggle_button(main.reserve_button,true)
		c.upgrade_to_silver()
		var stamp_chance = randi_range(0,1)
		if stamp_chance == 1: c.is_stamped = true
		
		if main.enemy.coin > 0 and (c.status != CoinStatus.NONE or c.is_stamped):
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(ALL_IN_STAMP)
			main.enemy.take_damage(3)
			main.total_damage_dealt += 3
			create_floating_label(3,"DAMAGE","ENEMY")
		
		if main.enemy.coin > 0 and has_impromptu_flip:
			trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(GAIN_EFFECT)
			main.enemy.take_damage(2)
			main.total_damage_dealt += 2
			create_floating_label(2,"DAMAGE","ENEMY")


	if c.base_value > 2:
		main.sound_manager.play_sound(COIN_UPGRADE)
		if main.enemy.coin > 0 and has_coin_snipe:
			trigger_temp_passive("coin_snipe","COIN SNIPE")
			main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
			main.enemy.take_damage(1)
			main.total_damage_dealt += 1
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
	
	if c.base_value > 2:
		upgraded_flip_count += 1
	
	if main.enemy.coin > 0 and has_triple_nickel and upgraded_flip_count % 10 == 0  and upgraded_flip_count != 0:
		trigger_temp_passive("triple_nickel","COIN BARRAGE")
		main.particle_manager.spawn_particle(COIN_BARRAGE_PARTICLE,main.enemy_portrait.global_position)
		main.sound_manager.play_sound(DAMAGE_HEAVY)
		main.enemy.take_damage(10)
		main.total_damage_dealt += 10
		create_floating_label(10,"DAMAGE","ENEMY")
		upgraded_flip_count = 0
		
	main.add_child(c)
	print("Coin parent: ", c.get_parent().name, " process_mode: ", c.get_parent().process_mode)
	if c.reserved == false:
		latest_coin = c
		main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,latest_coin.global_position)

	print(current_played_coin)
	if (current_played_coin == max_playable_coins and current_reserve >= max_reserve) or coin == 1:
		toggle_button(main.flip_button,true)
		toggle_button(main.reserve_button,true)
	coin_calculation()
	
	
	if current_played_coin != 0 and has_refund:
		all_in.text = ""

	if current_reserve >= max_reserve:
		toggle_button(main.reserve_button,true)
	
	if !has_all_in and main.enemy.coin == 0:
		main.check_defeat()
		return
		
	if tally and main.enemy.coin > 0:
		if tally_counter > 0:
			tally_counter -= 1
			if tally_counter == 0:
				await get_tree().create_timer(0.1).timeout
				main.tally_end_turn()
				tally = false
				return
	
	if has_inflation and current_played_coin >= max_playable_coins:
		toggle_button(main.flip_button,true)
	
	
	if coin == 0:
		main.check_defeat()



func re_flip():

	main.sound_manager.play_sound(COIN_REFLIP)
	main.sound_manager.play_sound(COIN_FLIP)
	
	if has_inflation:
		main.particle_manager.spawn_particle(INFLATION_PARTICLE,main.re_flip_button.global_position)
	
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
	var has_inflation_damage = false
	for c in coins:
		if c.is_stamped:
			continue
		if c.status == CoinStatus.VOIDED:
			c.status = c.initial_status
			main.sound_manager.play_sound(VOID_CLEANSE)
			main.particle_manager.spawn_particle(VOID_REMOVED_PARTICLE,c.global_position)
			if has_pay_down:
				debted_attack += 2
		if slow:
			slow_chance = randf()
			if slow_chance <= 0.3:
				continue
		if has_inflation:
			var upgrade_chance = randf()
			if upgrade_chance <= 0.5:
				if c.base_value < 6:
					c.upgrade()
				elif coin > 1:
					coin -= 1
					if c.status != CoinStatus.SHINED:
						c.add_status(CoinStatus.SHINED)
					else:
						c.shine_stack += 1
			c.re_flip()
		else:
			c.re_flip()
	if !lock and has_spare_change:
		if !has_inflation:
			toggle_button(main.reserve_button,false)
			toggle_button(main.flip_button,false)
		if has_extra_turn:
			toggle_button(main.reserve_button,true)
			toggle_button(main.flip_button,true)
		var has_withdraw_damage = false
		var reserved_coins = get_tree().get_nodes_in_group("reserved coins")
		current_reserve = reserved_coins.size()
		if reserved_coins.size() != 0:
			main.particle_manager.spawn_particle(SPARE_CHANGE_PARTICLE,spare_change.global_position)
			trigger_temp_passive("spare_change","SPARE CHANGE")
			main.sound_manager.play_sound(PASSIVE_SPARE_CHANGE)
			if has_withdraw: 
				trigger_temp_passive("withdraw","WITHDRAW")
		for c in reserved_coins:
			coin += 1
			if c.is_stamped:
				main.particle_manager.spawn_particle(SPARE_CHANGE_RE_FLIP_PARTICLE,spare_change_reflip.global_position)
				current_re_flip -= 1
			c.queue_free()
			current_reserve -= 1
			if main.enemy.coin > 0 and has_withdraw: 
				if c.status != CoinStatus.NONE:
					create_floating_label(3,"DAMAGE","ENEMY")
					main.enemy.take_damage(3)
					main.total_damage_dealt += 3
				else:
					create_floating_label(1,"DAMAGE","ENEMY")
					main.enemy.take_damage(1)
					main.total_damage_dealt += 1
				has_withdraw_damage = true
		if has_withdraw_damage:
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(DAMAGE_MODERATE)
			
	if main.enemy.coin > 0 and !lock and has_sleight_of_hand:
			main.particle_manager.spawn_particle(PICKPOCKET_PARTICLE,pickpocket.global_position)
			trigger_temp_passive("pickpocket","PICKPOCKET")
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(DAMAGE_LIGHT)
			main.enemy.take_damage(1)
			main.total_damage_dealt += 1
			create_floating_label(1,"DAMAGE","ENEMY")
			reserve(true, true)
			if main.enemy.coin > 0 and has_coin_snipe:
				trigger_temp_passive("coin_snipe","COIN SNIPE")
				main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
				main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
				main.enemy.take_damage(3)
				main.total_damage_dealt += 3
				create_floating_label(3,"DAMAGE","ENEMY")
		
	if current_re_flip == max_re_flip or current_played_coin == 0:
		toggle_button(main.re_flip_button,true)



	await get_tree().create_timer(0.1).timeout
	coin_calculation()
	
	
func start_turn():
	print("CURRENT PLAYED COIN " + str(current_played_coin))
	if lock:
		max_reserve = 0
	if tally:
		show_tally_ui()
		
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
		current_reserve = 0
		upgraded_flip_count = 0
		main.coin_deck.reset_sigils()
	current_re_flip = 0
	latest_coin = null

	
	#Activate Turn Start Passives
	await activate_player_turn_start_passives()
	
	toggle_button(main.flip_button,false)
	toggle_button(main.reserve_button,false)
	if current_played_coin == 0:
		toggle_button(main.re_flip_button,true)
		main.turn_calculation.text = ""

	main.reflip_label.text = str(max_re_flip - current_re_flip)

	

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
					if current_played_coin <= 2 and has_advanced_planning:
						coin.is_stamped = true
					pos = main.coin_deck.get_vacant_slot(current_played_coin)
					coin.global_position.x = pos[0]
					coin.global_position.y = pos[1]
					coin.reserved = false
					if has_withdraw: 
						if coin.status != CoinStatus.NONE:
							create_floating_label(3,"DAMAGE","ENEMY")
							main.enemy.take_damage(3)
							main.total_damage_dealt += 3
						else:
							create_floating_label(1,"DAMAGE","ENEMY")
							main.enemy.take_damage(1)
							main.total_damage_dealt += 1
						has_withdraw_damage = true
				if has_value_increase:
					if coin.base_value < 6:
						coin.upgrade()
					else:
						if has_inflation and coin.status == CoinStatus.SHINED:
							coin.shine_stack += 1
						elif coin.initial_status == CoinStatus.NONE:
							coin.add_status(CoinStatus.SHINED)
				latest_coin = COIN.instantiate()
				latest_coin.setup(coin.state,pos)
				latest_coin.copy_coin(coin)
				if is_deck_full:
					latest_coin.reserved = true
					latest_coin.add_to_group("reserved coins")
				else:
					latest_coin.add_to_group("coins")
				coin.queue_free()
				main.add_child(latest_coin)
				
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
						if has_withdraw:
							if coin.status != CoinStatus.NONE:
								create_floating_label(3,"DAMAGE","ENEMY")
								main.enemy.take_damage(3)
								main.total_damage_dealt += 3
							else:
								create_floating_label(1,"DAMAGE","ENEMY")
								main.enemy.take_damage(1)
								main.total_damage_dealt += 1
							has_withdraw_damage = true
					var dividend_coin = COIN.instantiate()
					dividend_coin.setup(latest_coin.state,pos)
					dividend_coin.copy_coin(latest_coin)
					if is_deck_full:
						dividend_coin.reserved = true
						dividend_coin.add_to_group("reserved coins")
					else:
						dividend_coin.add_to_group("coins")
					main.add_child(dividend_coin)
					if has_coin_snipe:
						trigger_temp_passive("coin_snipe","COIN SNIPE")
						main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
						main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
						main.enemy.take_damage(3)
						main.total_damage_dealt += 3
						create_floating_label(3,"DAMAGE","ENEMY")
	
				latest_coin.refresh_sprite()
				if current_played_coin > 1:
					coin_calculation()
		if has_withdraw_damage:
			main.particle_manager.spawn_particle(DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(DAMAGE_MODERATE)	
				#reserved_coin.queue_free()
	if !lock and (coin == 1 or current_reserve >= max_reserve):
		toggle_button(main.reserve_button,true)
		if current_played_coin == max_playable_coins:
			toggle_button(main.flip_button,true)
	if current_played_coin == 0:
		if has_refund:
			all_in.text = "ALL IN"
		toggle_button(main.re_flip_button,true)
	print(max_reserve)
	if has_inflation:
		toggle_button(main.reserve_button,true)
		main.reserve_button.visible = false
	if main.enemy.coin == 0:
		main.check_defeat()
	

func end_turn():
	
	if has_extra_turn:
		var extra_tween = create_tween()
		extra_tween.tween_property(extra_turn_effect,"self_modulate", Color("00000000"),0.6)
	
	main.turn_damage_particle.emitting = false
	main.turn_gain_particle.emitting = false
	main.turn_debt_particle.emitting = false
	main.turn_thrift_particle.emitting = false
	main.turn_spend_particle.emitting = false
	main.turn_tally_particle.emitting = false
	
	if tally:
		hide_tally_ui()
	print("ENDED TURN!?")
	all_in.text = ""
	toggle_button(main.re_flip_button,true)
	toggle_button(main.endTurn_button, true)
	toggle_button(main.flip_button,true)
	toggle_button(main.reserve_button,true)
	main.coin_deck.sigil_pressed();
	previous_player_flips = current_played_coin

	await activate_player_turn_end_passives()
	
	
	if has_all_in:
		var all_in_tween = create_tween()
		all_in_tween.tween_property(all_in_effect,"self_modulate", Color("ffffff00"),0.6)
		
	if main.enemy.coin == 0: return

	# ==========================================
	# PHASE 1: MATH & LOGIC (Instantly calculate everything)
	# ==========================================
	var calculations = coin_calculation()
	var turn_damage:int = calculations[0] + calculations[5]
	var turn_gain:int = calculations[1] + calculations[6]
	var turn_debt = calculations[2]
	var turn_thrift = calculations[3]
	var turn_spend = calculations[4]
	var turn_void = calculations[7]
	previous_player_gain = turn_gain
	
	if has_pay_down and turn_void != 0:
		turn_void *= 2
		if has_reimbursement:
			turn_void /= 2
			if greed and (main.enemy.type == Enemy.COLLECTOR):
				create_floating_label("DEBT", "IMMUNE", "ENEMY")
			else:
				main.enemy.debt += turn_void
				create_floating_label(turn_void, "DEBT", "ENEMY")
			main.enemy.take_damage(turn_void)
			main.total_damage_dealt += turn_void
			main.sound_manager.play_sound(DAMAGE_MODERATE)
			main.sound_manager.play_sound(DEBTED_ATTACK)
			create_floating_label(turn_void, "DAMAGE", "ENEMY")
		debt += turn_void
		if has_active_income:
			main.shopkeeper.status.text = "SETTLE YOUR DEBT."

			
	# Determine if enemy is immune to debt before applying
	var is_debt_immune = (main.enemy.type == Enemy.COLLECTOR) and greed
	var actual_debt_applied = 0 if is_debt_immune else turn_debt

	# 1. Apply Stats to Player
	thrift = 0
	spend = 0
	if lock:	
		lock = false
		max_reserve = initial_max_reserve
		var coins = get_tree().get_nodes_in_group("reserved coins")
		current_reserve = coins.size()
	if slow: 
		slow = false
		var drowse_tween = create_tween()
		drowse_tween.tween_property(drowse_effect,"self_modulate", Color("#0059a800"),0.6)
		await drowse_tween.finished
		drowse_effect.visible = false
	if starstruck:
		starstruck = false
		var dazzled_tween = create_tween()
		dazzled_tween.parallel().tween_property(dazzled_effect,"self_modulate", Color("#0059a800"),0.6)
		dazzled_tween.parallel().tween_property(dazzled_light,"color", Color("#0059a800"),0.6)
		await dazzled_tween.finished
		dazzled_effect.visible = false
		dazzled_light.visible = false
	gain += turn_gain
	if turn_gain > 0:
		create_floating_label(turn_gain,"GAIN","PLAYER")
	max_playable_coins = initial_max_playable_coins
	
	if thrifted_attack != 0: thrifted_attack = 0
	if debted_attack != 0: debted_attack = 0
	if spended_attack != 0: spended_attack = 0

	
	# 3. Twilight Sage Logic
	if main.enemy.type == Enemy.TWILIGHT_SAGE:
		if main.enemy.has_dusk_stance: spend += moon_count
		else: thrift += int(sun_count/2)

	# 4. Tracking / High Scores
	main.total_damage_dealt += turn_damage
	if turn_damage > main.highest_damage_dealt: main.highest_damage_dealt = turn_damage
	main.total_gain += turn_gain
	if turn_gain > main.highest_gain: main.highest_gain = turn_gain

	# 5. Piggy & Reserve Logic
	main.reserve_left_over_coin()
	var coins = get_tree().get_nodes_in_group("coins")
	var is_left = true
	if has_piggy:
		latest_pair_left_coin = null
		latest_pair_right_coin = null
	for coin in coins:
		if has_piggy and is_left and !coin.reserved:
			latest_pair_left_coin = COIN.instantiate()
			latest_pair_left_coin.copy_coin(coin)
			is_left = false
		elif has_piggy and !is_left and !coin.reserved:
			latest_pair_right_coin = COIN.instantiate()
			latest_pair_right_coin.copy_coin(coin)
			is_left = true
		if coin.reserved == false:
			main.particle_manager.spawn_particle(COIN_PLAY_PARTICLE,coin.global_position)
			coin.queue_free()
			
	if has_piggy and latest_pair_left_coin != null and latest_pair_right_coin != null:
		trigger_temp_passive("piggy","PIGGY")
		main.sound_manager.play_sound(PIGGY)
		piggy.shine()
		var type = latest_pair_left_coin.type
		latest_pair_left_coin.setup(latest_pair_left_coin.state,main.coin_deck.get_reserve_slot())
		latest_pair_left_coin.reserved = true
		latest_pair_left_coin.type = type
		latest_pair_left_coin.status = CoinStatus.SHINED
		latest_pair_left_coin.initial_status = CoinStatus.SHINED
		latest_pair_left_coin.add_to_group("reserved coins")
		main.add_child(latest_pair_left_coin)
		if has_deposit:
			trigger_temp_passive("deposit","DEPOSIT")
			if randi_range(1,5) == 1:
				latest_pair_left_coin.is_stamped = true
			create_floating_label(2,"GAIN","PLAYER")
			gain += 2
		
		if has_coin_snipe:
			trigger_temp_passive("coin_snipe","COIN SNIPE")
			main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
			main.enemy.take_damage(3)
			main.total_damage_dealt += 3
			create_floating_label(3,"DAMAGE","ENEMY")

		type = latest_pair_right_coin.type
		latest_pair_right_coin.setup(latest_pair_right_coin.state,main.coin_deck.get_reserve_slot())
		latest_pair_right_coin.reserved = true
		latest_pair_right_coin.type = type
		latest_pair_right_coin.status = CoinStatus.SHINED
		latest_pair_right_coin.initial_status = CoinStatus.SHINED
		latest_pair_right_coin.add_to_group("reserved coins")
		main.add_child(latest_pair_right_coin)
		current_reserve += 2
		if has_deposit:
			trigger_temp_passive("deposit","DEPOSIT")
			if randi_range(1,5) == 1:
				latest_pair_right_coin.is_stamped = true
			create_floating_label(2,"GAIN","PLAYER")
			gain += 2
	
		if has_coin_snipe:
			trigger_temp_passive("coin_snipe","COIN SNIPE")
			main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
			main.enemy.take_damage(3)
			main.total_damage_dealt += 3
			create_floating_label(3,"DAMAGE","ENEMY")
	
	#DOUBLE CHECK FOR LEFT OVERS
	if coins.size() > 0:
		for c in coins:
			c.queue_free()
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
		if main.enemy.unchargable:
			create_floating_label("DEBT","IMMUNE","ENEMY")
			main.sound_manager.play_sound(PASSIVE_REFUND)
		else:
			main.total_debt_applied += turn_debt
			if turn_debt > main.highest_debt_applied:
				main.highest_debt_applied = turn_debt
			main.particle_manager.spawn_particle(DEBT_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
			shake_power += 0.5
			main.sound_manager.play_sound(DEBT)
			create_floating_label(actual_debt_applied,"DEBT","ENEMY")
			
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
	main.enemy.debt += actual_debt_applied
	main.enemy.thrift += turn_thrift
	main.enemy.spend += turn_spend
	
	# 6. Extra Turn Checks
	
	if !has_extra_turn and !lock and main.enemy.coin > 0 and has_cash_out and current_reserve >= 4:
		trigger_temp_passive("cash_out","CASH OUT")
		has_extra_turn = true
		return

	has_extra_turn = false
	has_all_in = false
	extra_turn_effect.visible = false
	all_in_effect.visible = false
	
	
	
func activate_pre_battle_passives():
	
	payback_used = false
	payback_coins = 12
	pocket_money_coins = 8
	current_played_coin = 0
	if has_pocket_money:
		main.sound_manager.play_sound(COIN_FLIP)
		while pocket_money_coins != 0:
			var state = 1
			current_played_coin += 1
			var c = COIN.instantiate()
			if current_played_coin > 4:
				c.setup(state,main.coin_deck.get_reserve_slot())
				c.reserved = true
				current_reserve += 1
				c.add_to_group("reserved coins")
				current_played_coin -= 1
				if has_deposit:
					trigger_temp_passive("deposit","DEPOSIT")
					if randi_range(1,5) == 1:
						c.is_stamped = true
					create_floating_label(2,"GAIN","PLAYER")
					gain += 2
			else:
				c.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
				if current_played_coin <= 2 and has_advanced_planning:
					c.is_stamped = true
				c.add_to_group("coins")
				latest_coin = c
			#Guaranteed Silver Flips
			c.upgrade_to_silver()
			c.is_stamped = true
			main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,latest_coin.global_position)
			main.add_child(c);
			if has_coin_snipe:
				trigger_temp_passive("coin_snipe","COIN SNIPE")
				main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
				main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
				main.enemy.take_damage(3)
				main.total_damage_dealt += 3
				create_floating_label(3,"DAMAGE","ENEMY")
			
			if (current_played_coin == max_playable_coins and current_reserve == max_reserve) or coin == 1:
				toggle_button(main.flip_button,true)
			coin_calculation()
			pocket_money_coins -= 1
			upgraded_flip_count += 1
			await get_tree().create_timer(0.1).timeout
		main.endTurn_button.disabled = false
		toggle_button(main.re_flip_button,false)

func activate_player_turn_start_passives():
	previous_player_flips = 0
	upgraded_flip_count = 0
	#PAYBACK
	if has_payback and payback_used and payback_coins != 0:
		trigger_temp_passive("payback","PAYBACK")
		payback_coins = 6
		main.sound_manager.play_sound(THRIFT)
		main.endTurn_button.disabled = true
		toggle_button(main.re_flip_button,true)
		print("PAYBACK: " + str(payback_coins))
		main.sound_manager.play_sound(PASSIVE_PAYBACK)
		var is_deck_full = false
		payback_used = false
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
				if has_deposit:
					trigger_temp_passive("deposit","DEPOSIT")
					if randi_range(1,5) == 1:
						c.is_stamped = true
					create_floating_label(2,"GAIN","PLAYER")
					gain += 2
					
			else:
				c.setup(state,main.coin_deck.get_vacant_slot(current_played_coin))
				c.add_to_group("coins")

			if current_played_coin <= 2 and has_advanced_planning:
				c.is_stamped = true
			#Guaranteed Silver Flips
			c.upgrade_to_gold()
			c.add_status(CoinStatus.SHINED)
			main.add_child(c);
			
			latest_coin = c
			upgraded_flip_count += 1
			main.sound_manager.play_sound(COIN_FLIP)
			main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,c.global_position)
			if (current_played_coin == max_playable_coins and current_reserve >= max_reserve) or coin == 1:
				toggle_button(main.flip_button,true)
			if has_coin_snipe:
				trigger_temp_passive("coin_snipe","COIN SNIPE")
				main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
				main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
				main.enemy.take_damage(3)
				main.total_damage_dealt += 3
				create_floating_label(3,"DAMAGE","ENEMY")
			if main.enemy.coin > 0 and has_triple_nickel and upgraded_flip_count % 10 == 0  and upgraded_flip_count != 0:
				trigger_temp_passive("triple_nickel","COIN BARRAGE")
				main.particle_manager.spawn_particle(COIN_BARRAGE_PARTICLE,main.enemy_portrait.global_position)
				main.sound_manager.play_sound(DAMAGE_HEAVY)
				main.enemy.take_damage(10)
				main.total_damage_dealt += 10
				create_floating_label(10,"DAMAGE","ENEMY")
				upgraded_flip_count = 0

			coin_calculation()
			payback_coins -= 1
			await get_tree().create_timer(0.1).timeout
			
		main.endTurn_button.disabled = false
		toggle_button(main.re_flip_button,false)


func activate_player_turn_end_passives():
	
	if !has_extra_turn:
		solar_blessing = false
		lunar_blessing = false
		solar_glow.visible = false
		lunar_glow.visible = false
	
	var has_dazzle = false
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if coin.status == CoinStatus.DAZZLED:
			has_dazzle = true
			if coin.state == 0:
				coin.state = 1
			else:
				coin.state = 0
			coin.add_status(CoinStatus.NONE)
			coin.refresh_sprite()
			main.sound_manager.play_sound(ALL_IN_STAMP)
			main.sound_manager.play_sound(COIN_FLIP)
			coin_calculation()
			if has_impromptu_flip:
				trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
				main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
				main.sound_manager.play_sound(DAMAGE_LIGHT)
				main.enemy.take_damage(2)
				main.total_damage_dealt += 2
				create_floating_label(2,"DAMAGE","ENEMY")
			await get_tree().create_timer(0.1).timeout
	if has_dazzle:
		await get_tree().create_timer(0.6).timeout
	if main.enemy.coin == 0:
		return
		
	if has_refund and current_played_coin == 0 and !has_all_in:
		main.show_turn_ui("ALL IN")
		trigger_temp_passive("refund","ALL IN")
		all_in_effect.self_modulate.a = 0
		all_in_effect.visible = true
		var all_in_tween = create_tween()
		all_in_tween.tween_property(all_in_effect,"self_modulate", Color("ffffffff"),0.3)
		has_all_in = true
		var all_in_coin = 20
		main.sound_manager.play_sound(PASSIVE_PAYBACK)
		main.sound_manager.play_sound(ALL_IN)
		while main.enemy.coin > 0 and all_in_coin != 0 and coin > 1:
			flip()
			coin_calculation()
			await get_tree().create_timer(0.1).timeout
			all_in_coin -= 1
		await get_tree().create_timer(1.0).timeout
		if main.enemy.coin == 0:
			return
	
	if has_impromptu_flip and latest_coin != null:
		if latest_coin.state == 0:
			latest_coin.state = 1
		else:
			latest_coin.state = 0
		if latest_coin.status == CoinStatus.VOIDED: 
			latest_coin.add_status(latest_coin.initial_status)
			main.sound_manager.play_sound(VOID_CLEANSE)
		latest_coin.refresh_sprite()
		trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
		main.sound_manager.play_sound(COIN_FLIP)
		main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
		main.sound_manager.play_sound(DAMAGE_LIGHT)
		main.enemy.take_damage(2)
		main.total_damage_dealt += 2
		create_floating_label(2,"DAMAGE","ENEMY")
		coin_calculation()
		await get_tree().create_timer(0.6).timeout
		if main.enemy.coin == 0:
			return
	if has_magic_trick and current_played_coin >= 8:
		trigger_temp_passive("magic_trick","MAGIC TRICK")
		coins = get_tree().get_nodes_in_group("coins")
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
				if has_impromptu_flip:
					trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(2)
					main.total_damage_dealt += 2
					create_floating_label(2,"DAMAGE","ENEMY")
				if has_coin_snipe:
					trigger_temp_passive("coin_snipe","COIN SNIPE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
					main.enemy.take_damage(3)
					main.total_damage_dealt += 3
					create_floating_label(3,"DAMAGE","ENEMY")
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
			if index == 4 or index == 6 or index == 8:
				coin.copy_coin(second_coin)
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				if has_impromptu_flip:
					trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(2)
					main.total_damage_dealt += 2
					create_floating_label(2,"DAMAGE","ENEMY")
				if has_coin_snipe:
					trigger_temp_passive("coin_snipe","COIN SNIPE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(PASSIVE_COIN_SNIPE)
					main.enemy.take_damage(3)
					main.total_damage_dealt += 3
					create_floating_label(3,"DAMAGE","ENEMY")
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
		coin_calculation()
		await get_tree().create_timer(0.6).timeout
		if main.enemy.coin == 0:
			return
	if has_advanced_planning:
		trigger_temp_passive("advanced_planning","SEAL OF APPROVAL")
		coins = get_tree().get_nodes_in_group("coins")
		var index = 0
		for coin in coins:
			if coin.is_stamped:
				coin.is_stamped = false
				if has_inflation and coin.base_value == 6:
					if coin.status == CoinStatus.SHINED:
						coin.shine_stack += 1
					else:
						coin.add_status(CoinStatus.SHINED)
				coin.upgrade()
				if coin.status == CoinStatus.VOIDED:
					coin.status = coin.initial_status
					main.sound_manager.play_sound(VOID_CLEANSE)
					if has_pay_down:
						debted_attack += 2
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				if has_impromptu_flip:
					trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(2)
					main.total_damage_dealt += 2
					create_floating_label(2,"DAMAGE","ENEMY")
				coin_calculation()
				await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(0.6).timeout
		if main.enemy.coin == 0:
			return
	
	if has_simple_interest and moon_moon_count > 0: 
		trigger_temp_passive("simple_interest","FULL MOON")
		for coin in coins:
			#PRIORITY 1: UNSHINED MOON COINS
			if coin.state == 1 and moon_moon_count > 0 and coin.status != CoinStatus.SHINED:
				coin.add_status(CoinStatus.SHINED)
				moon_moon_count -= 1
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				if has_impromptu_flip:
					trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(2)
					main.total_damage_dealt += 2
					create_floating_label(2,"DAMAGE","ENEMY")
				await get_tree().create_timer(0.1).timeout
			if moon_moon_count == 0: break
		
		if moon_moon_count > 0:
			for coin in coins:
				#PRIORITY 2: SHINED MOON COINS (No Remaining Unshined Left)
				if coin.state == 1 and moon_moon_count > 0:
					if has_inflation and coin.base_value == 6:
						coin.shine_stack += 1
					moon_moon_count -= 1
					coin.refresh_sprite()
					main.sound_manager.play_sound(COIN_FLIP)
					if has_impromptu_flip:
						trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
						main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
						main.sound_manager.play_sound(DAMAGE_LIGHT)
						main.enemy.take_damage(2)
						main.total_damage_dealt += 2
						create_floating_label(2,"DAMAGE","ENEMY")
					await get_tree().create_timer(0.1).timeout
				if moon_moon_count == 0: break
		coin_calculation()
		await get_tree().create_timer(0.6).timeout
		if main.enemy.coin == 0:
			return

	if has_lucky_pair and sun_sun_count > 0:
		trigger_temp_passive("lucky_pair","GOLD RUSH")
		
		#PRIORITY 1: UNUPGRADED COINS
		for coin in coins:
			if  sun_sun_count > 0 and coin.base_value < 6:
				coin.upgrade_to_gold()
				sun_sun_count -= 1
				coin.refresh_sprite()
				main.sound_manager.play_sound(COIN_FLIP)
				if has_impromptu_flip:
					trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
					main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
					main.sound_manager.play_sound(DAMAGE_LIGHT)
					main.enemy.take_damage(2)
					main.total_damage_dealt += 2
					create_floating_label(2,"DAMAGE","ENEMY")
				await get_tree().create_timer(0.1).timeout
			if sun_sun_count == 0: break
				
		#PRIORITY 2: UNSHINED GOLD COINS
		if sun_sun_count > 0:
			for coin in coins:
				if  sun_sun_count > 0 and coin.status == CoinStatus.NONE:
					if has_inflation:
						coin.add_status(CoinStatus.SHINED)
					sun_sun_count -= 1
					coin.refresh_sprite()
					main.sound_manager.play_sound(COIN_FLIP)
					if has_impromptu_flip:
						trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
						main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
						main.sound_manager.play_sound(DAMAGE_LIGHT)
						main.enemy.take_damage(2)
						main.total_damage_dealt += 2
						create_floating_label(2,"DAMAGE","ENEMY")
					await get_tree().create_timer(0.1).timeout
				if sun_sun_count == 0: break
		
		#PRIORITY 3: SHINED GOLD COINS
		if sun_sun_count > 0:
			for coin in coins:
				if sun_sun_count > 0:
					if has_inflation:
						coin.shine_stack += 1
					sun_sun_count -= 1
					coin.refresh_sprite()
					main.sound_manager.play_sound(COIN_FLIP)
					if has_impromptu_flip:
						trigger_temp_passive("impromptu_flip","FLIP SEQUENCE")
						main.particle_manager.spawn_particle(SINGLE_DAMAGE_PARTICLE,main.enemy_portrait.global_position)
						main.sound_manager.play_sound(DAMAGE_LIGHT)
						main.enemy.take_damage(2)
						main.total_damage_dealt += 2
						create_floating_label(2,"DAMAGE","ENEMY")
					await get_tree().create_timer(0.1).timeout
				if sun_sun_count == 0: break
		coin_calculation()
		await get_tree().create_timer(0.6).timeout
		if main.enemy.coin == 0:
			return
	
	if has_solar_coin and sun_count >= 8:
		solar_blessing = true;
		trigger_temp_passive("solar_coin","SOLAR BLESSING")
		solar_glow.visible = true
	if has_lunar_coin and moon_count >= 8:
		lunar_blessing = true
		trigger_temp_passive("lunar_coin","LUNAR BLESSING")
		lunar_glow.visible = true

func extra_turn():
	
	main.endTurn_button.mouse_default_cursor_shape = 2
	main.re_flip_button.mouse_default_cursor_shape = 2
	main.player_info.visible = true
	main.enemy_info.visible = true
	main.sound_manager.play_sound(CASH_OUT)
	extra_turn_effect.self_modulate.a = 0
	extra_turn_effect.visible = true
	var extra_tween = create_tween()
	extra_tween.tween_property(extra_turn_effect,"self_modulate", Color("000000ff"),0.3)
	await start_turn()
	toggle_button(main.flip_button,true)
	toggle_button(main.reserve_button,true)
	toggle_button(main.endTurn_button,false)
	
func toggle_button(btn, make_disabled: bool) -> void:
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

func trigger_board_pulse() -> void:
	var board_coins = get_tree().get_nodes_in_group("coins")
	
	for i in range(0, board_coins.size() - 1, 2):
		var left_coin = board_coins[i]
		var right_coin = board_coins[i + 1]
		
		if is_instance_valid(left_coin) and is_instance_valid(right_coin):
			if not left_coin.reserved and not right_coin.reserved:
				left_coin.pulse_glow()
				right_coin.pulse_glow()
				
		# --- THE MAGIC STAGGER ---
		# Wait 0.3 seconds before telling the next pair to pulse!
		await get_tree().create_timer(1.0).timeout


func show_tally_ui():
	tally_effect.visible = true
	main.sound_manager.play_sound(PASSIVE_REFUND)
	tally_flip_count.text = str(tally_counter)
	tally_effect.self_modulate = Color("ffffff00")
	var target_position = tally_effect.global_position.y - 20
	
	var tween = create_tween()
	tween.parallel().tween_property(tally_effect,"self_modulate",Color("e7a900"),0.2)
	tween.parallel().tween_property(tally_effect, "position:y",target_position,0.2)
	
	

func hide_tally_ui():
	var target_position = tally_effect.global_position.y - 20
	var tween = create_tween()
	tween.parallel().tween_property(tally_effect,"self_modulate",Color("ffffff00"),0.2)
	tween.parallel().tween_property(tally_effect, "position:y",target_position,0.2)
	await tween.finished
	tally_effect.global_position.y += 40
	tally_effect.visible = false
	
