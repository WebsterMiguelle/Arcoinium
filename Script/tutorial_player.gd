#player tutorial
extends Node2D 

enum CoinStatus {
	NONE,
	SHINED,
	VOIDED,
	DAZZLED
}

enum Enemy{
	SHOP_KEEPER
}
@onready var camera_2d: Camera2D = $"../Camera2D"
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
const DEBT = preload("uid://cuwgygacdm7dj")
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
var shine_flip_rate = 0.25: #Chance to Flip a Shined Coin
	set(value):
		shine_flip_rate = clamp(value,0.0,100.0)

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
var previous_player_gain = 0

var previous_player_flips = 0
var player_turn_count = 0
var sun_count = 0
var moon_count = 0
var thrifted_attack = 0
var debted_attack = 0
var spended_attack = 0

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
		particle_manager.spawn_particle(GAIN_EFFECT_PARTICLE,main.player_gain.global_position)
		main.sound_manager.play_sound(GAIN_EFFECT)
		create_floating_label(gain,"GAIN","PLAYER")
	elif debt > 0:
		particle_manager.spawn_particle(DEBT_EFFECT_PARTICLE,main.player_debt.global_position)
		main.sound_manager.play_sound(DEBT_EFFECT)
	gain = 0
	print("Player HP: ", coin)

func reset_stats():
	max_coin = 500 #Max Coin Capacity
	max_reserve = 4
	current_reserve = 0
	coin = 50
	max_playable_coins = 16 #Max Flips Per Turn
	current_played_coin = 0 #Current Flip Count
	max_re_flip = 3 #Max Re-Flips Per Turn
	current_re_flip = 0 #Current Re-Flip Count
	silver_flip_rate = 0.1 #Chance to Flip a Silver Coin 
	gold_flip_rate = 0.05 #Chance to Flip a Gold Coin

	
func refresh_start_of_battle_stats():
	initial_max_reserve = max_reserve
	lock = false
	slow = false
	thrifted_attack = 0
	debted_attack = 0
	spended_attack = 0
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


	var shined_sun_boost = 0
	var shined_moon_boost = 0
	
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
			if coin.status == CoinStatus.SHINED:
				shined_sun_boost += 3 + coin.shine_stack
		elif coin.state == 1 and !coin.reserved:
			moon_count +=1
			if coin.status == CoinStatus.SHINED:
				shined_moon_boost += 3 + coin.shine_stack
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
	var text = ""
	if coins != null:
		if total_damage != 0: 
			text += "\nDAMAGE: " + str(total_damage)
			if shined_sun_boost > 1:
				text += " (x" + str(shined_sun_boost) + ")"
		if total_gain != 0:
			text += "\nGAIN: " + str(total_gain)
			if shined_moon_boost > 1:
				text += " (x" + str(shined_moon_boost) + ")"
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
	return [total_damage,total_gain,total_debt,total_thrift, total_spend,shined_sun_boost, shined_moon_boost]

func reserve():
	print("RESERVE")
	main.sound_manager.play_sound(COIN_FLIP)
	flip_clicks += 1
	if current_re_flip != max_re_flip: 
		toggle_button(main.re_flip_button,false)
		
	var state = randi() % 2

	if state == 0:
		main.total_heads += 1
	else:
		main.total_tails += 1
	
	var c = COIN.instantiate()
	
	if lock: return
	c.setup(state,main.coin_deck.get_reserve_slot())
	c.reserved = true
	current_reserve += 1
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
		
	if main.advance_mode:
		var shine_chance = randf()
		if shine_chance <= shine_flip_rate:
			c.add_status(c.CoinStatus.SHINED)
			c.refresh_sprite()
			c.pulse_glow()
		
	take_damage(1)
	add_child(c)

	print(current_played_coin)
	if (current_reserve >= max_reserve) or coin == 1:
		toggle_button(main.reserve_button,true)
	if coin == 1:
		toggle_button(main.flip_button,true)
	coin_calculation()
	if main.enemy.coin > 0:
		main.check_defeat()

func flip():
	
	var is_deck_full = false
	print("FLIP")
	flip_clicks += 1
	if current_re_flip != max_re_flip: 
		toggle_button(main.re_flip_button,false)
		
	var state = randi() % 2
	
	if main.advance_mode and not main.adv_debt_done and flip_clicks <= 2:
		state = 0
	
	if state == 0:
		main.total_heads += 1
	else:
		main.total_tails += 1
	
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
		
	if c.base_value > 2:
		main.sound_manager.play_sound(COIN_UPGRADE)
		
	if main.advance_mode:
		var shine_chance = randf()
		if shine_chance <= shine_flip_rate:
			c.add_status(c.CoinStatus.SHINED)
			c.refresh_sprite()
			c.pulse_glow()

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
	if c.reserved == false:
		latest_coin = c
		main.particle_manager.spawn_particle(COIN_ADD_PARTICLE,latest_coin.global_position)

	print(current_played_coin)
	if (current_played_coin == max_playable_coins and current_reserve >= max_reserve) or coin == 1:
		toggle_button(main.flip_button,true)
		toggle_button(main.reserve_button,true)
	coin_calculation()
	
	if main.advance_mode and not main.adv_debt_done and flip_clicks >= 2:
		toggle_button(main.flip_button,true)
		
	if main.enemy.coin > 0:
		main.check_defeat()

	if current_reserve >= max_reserve:
		toggle_button(main.reserve_button,true)



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
	for c in coins:
		c.re_flip()
		
	if current_re_flip == max_re_flip or current_played_coin == 0:
		toggle_button(main.re_flip_button,true)

	await get_tree().create_timer(0.1).timeout
	coin_calculation()
	
	
func start_turn():
	if lock:
		max_reserve = 0
	player_turn_count += 1
	
	#Initialize Global Stats
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
	current_played_coin = 0
	main.coin_deck.reset_sigils()
	current_re_flip = 0
	latest_coin = null

	toggle_button(main.flip_button,false)
	toggle_button(main.reserve_button,false)
	if current_played_coin == 0:
		toggle_button(main.re_flip_button,true)
		main.turn_calculation.text = ""

	main.reflip_label.text = str(max_re_flip - current_re_flip)
	current_reserve = 0

	#Check Coin Reserve
	
	if !lock and player_turn_count != 1:
		var coins = get_tree().get_nodes_in_group("reserved coins")
		current_reserve = coins.size()
		var is_deck_full = false
		
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
					
				latest_coin.refresh_sprite()
				if current_played_coin > 1:
					coin_calculation()
					
	if !lock and (coin == 1 or current_reserve >= max_reserve):
		toggle_button(main.flip_button,true)
		toggle_button(main.reserve_button,true)
	if current_played_coin == 0:
		toggle_button(main.re_flip_button,true)
	print(max_reserve)
	if main.enemy.coin == 0:
		main.check_defeat()
	

func end_turn():
	print("ENDED TURN!?")
	
	toggle_button(main.re_flip_button,true)
	toggle_button(main.endTurn_button, true)
	toggle_button(main.flip_button,true)
	toggle_button(main.reserve_button,true)
	main.coin_deck.sigil_pressed();
	previous_player_flips = current_played_coin


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
	previous_player_gain = turn_gain
	

	# 1. Apply Stats to Player
	thrift = 0
	spend = 0
	if lock:	
		lock = false
		max_reserve = initial_max_reserve
		var coins = get_tree().get_nodes_in_group("reserved coins")
		current_reserve = coins.size()
	if slow: slow = false
	gain += turn_gain
	max_playable_coins = initial_max_playable_coins
	
	if thrifted_attack != 0: thrifted_attack = 0
	if debted_attack != 0: debted_attack = 0
	if spended_attack != 0: spended_attack = 0


	# 4. Tracking / High Scores
	main.total_damage_dealt += turn_damage
	if turn_damage > main.highest_damage_dealt: main.highest_damage_dealt = turn_damage
	main.total_gain += turn_gain
	if turn_gain > main.highest_gain: main.highest_gain = turn_gain

	# 5. Piggy & Reserve Logic
	main.reserve_left_over_coin()
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if coin.reserved == false:
			main.particle_manager.spawn_particle(COIN_PLAY_PARTICLE,coin.global_position)
			coin.queue_free()
			
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
	main.enemy.thrift += turn_thrift
	main.enemy.spend += turn_spend
	
func extra_turn():
	await start_turn()
	toggle_button(main.re_flip_button,true)
	toggle_button(main.flip_button,true)
	toggle_button(main.reserve_button,true)
	
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
