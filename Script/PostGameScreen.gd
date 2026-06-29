extends Control
const GAME_OVER_WALL_CLOSE = preload("uid://dcogb5vig426m")
const GAME_OVER_STAMP = preload("uid://b1ajhwrgwjsvo")
const GAME_OVER_WALL = preload("uid://cen1jkl1h44jj")
const GAME_OVER_WRITE = preload("uid://df3805cdw3r4t")
const ALL_IN_STAMP = preload("uid://bo7ip21oxj6eq")
@onready var sound_manager: Node2D = $SoundManager
var player = null
# ==========================================
# ANIMATION & BACKGROUND NODES
# ==========================================
@onready var left_door: Control = $LeftSideBricks
@onready var right_door: Control = $RightSideBricks
@onready var left_edge: TextureRect = $LeftSideBricks/OpenTile
@onready var right_edge: TextureRect = $RightSideBricks/OpenTile
@onready var dark_overlay: ColorRect = $DarkOverlay
@onready var ui_layer: Control = $UILayer

# ==========================================
# LEFT PANEL NODES (Result & Passives)
# ==========================================
@onready var left_panel: PanelContainer = $UILayer/HBoxContainer/LeftPanel
@onready var left_vbox: VBoxContainer = $UILayer/HBoxContainer/LeftPanel/MarginContainer/VBoxContainer
@onready var end_result: Label = $UILayer/HBoxContainer/LeftPanel/MarginContainer/VBoxContainer/EndResult
@onready var mini_message: Label = $UILayer/HBoxContainer/LeftPanel/MarginContainer/VBoxContainer/Mini_message
@onready var passives_grid: GridContainer = $UILayer/HBoxContainer/LeftPanel/MarginContainer/VBoxContainer/PassivesGrid
@onready var greed_stamp: TextureRect = $Greed_Stamp

# ==========================================
# RIGHT PANEL NODES (Stats)
# ==========================================
@onready var right_panel: PanelContainer = $UILayer/HBoxContainer/RightPanel
@onready var right_vbox: VBoxContainer = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer
@onready var statistics_title: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/StatisticsTitle

@onready var stats_container: VBoxContainer = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS
@onready var remaining_coins: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/RemainingCoins
@onready var highest_dmg: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/HighestDMG
@onready var total_dmg: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalDMG
@onready var highest_gain: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/HighestGAIN
@onready var total_gain: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalGAIN
@onready var enemies_defeated: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/EnemiesDefeated
@onready var sun_coins_flipped: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/SunCoinsFlipped
@onready var moon_coins_flipped: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/MoonCoinsFlipped
@onready var total_flips: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalFlips
@onready var total_reflips: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalReflips
@onready var total_reserve_coins: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalReserveCoins
@onready var highest_debt: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/HighestDEBT
@onready var total_debt: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalDEBT
@onready var run_time: Label = $UILayer/HBoxContainer/LeftPanel/MarginContainer/VBoxContainer/RunTime

@onready var grade: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Grade
@onready var title: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Title

# ==========================================
# DATA PRELOADS
# ==========================================
const PASSIVE_ICON = preload("res://Scene/Passive_Bar_Icon.tscn") 
var stat_sequence: Array = []

#===========================================
#Passives
#===========================================
const PASSIVE_DATA = {
	# =======================
	# B-RANK PASSIVES
	# =======================
	"has_solar_coin": {
		"name": "Solar Blessing",
		"desc": "When 8 or more SUN Coins are played this turn, all Odd Flips next turn are guaranteed SUN.",
		"anim": "solar_blessing_anim"
	},
	"has_lunar_coin": {
		"name": "Lunar Blessing",
		"desc": "When 8 or more MOON Coins are played this turn, all Even Flips next turn are guaranteed MOON.",
		"anim": "lunar_blessing_anim"
	},
	"has_wishbone": {
		"name": "Wish Bone",
		"desc": "+20% SILVER Flip Rate.",
		"anim": "wishbone_anim"
	},
	"has_golden_clover": {
		"name": "Golden Clover",
		"desc": "+10% GOLD Flip Rate.",
		"anim": "golden_clover_anim"
	},
	"has_merchant_scroll": {
		"name": "Keeper's Scroll",
		"desc": "The Shopkeeper accompanies you. When you receive Damage, she gains a Turn and flips 1 STAMPED COPPER MOON-SUN Pair. Max Coin Flip increases by 2 each succeeding turn.",
		"anim": "keeper's_scroll_anim"
	},
	"has_impromptu_flip": {
		"name": "Flip Sequence",
		"desc": "Flip the Last Coin played to its other side. For each Flip/Upgrade that occurred during End Turn Sequence, Deal 1 DAMAGE.",
		"anim": "flip_sequence_anim"
	},
	"has_advanced_planning": {
		"name": "Seal of Approval",
		"desc": "The first 2 Coins placed on the Arcane Circle become STAMPED. At the end of the turn, Remove all STAMP from Played Coins and Upgrade them.",
		"anim": "seal_of_approval_anim"
	},
	"has_value_increase": {
		"name": "Value Increase",
		"desc": "Upgrade all RESERVED Coins next turn. Upgrading Beyond Gold applies SHINE instead.",
		"anim": "value_increase_anim"
	},
	"has_lending_charge": {
		"name": "Lending Charge",
		"desc": "SUN-MOON Pairs apply 3 DEBT. If all played Pairs are SUN-MOON, apply double DEBT.",
		"anim": "lending_charge_anim"
	},

	"has_coin_snipe": {
		"name": "Coin Snipe",
		"desc": "Flipping a SILVER or GOLD Coin deals 1 DAMAGE. Generated Coins deal 3 DAMAGE instead.",
		"anim": "coin_snipe_anim"
	},

	"has_simple_interest": {
		"name": "Full Moon",
		"desc": "For each MOON-MOON Pair played, 1 Moon Coin becomes SHINED at the end of the turn.",
		"anim": "full_moon_anim"
	},

	"has_lucky_pair": {
		"name": "Gold Rush",
		"desc": "+10% GOLD Flip Rate. For each SUN-SUN Pair played, 1 Random Coin is Upgraded to Gold.",
		"anim": "gold_rush_anim"
	},

	"has_sleight_of_hand": {
		"name": "Pickpocket",
		"desc": "+2 Re-Flips. Re-Flipping deals 1 DAMAGE and generates a RESERVED Coin with a Random Status Effect.",
		"anim": "pickpocket_anim"
	},

	"has_piggy": {
		"name": "Piggy",
		"desc": "Piggy accompanies you. At the end of the turn, Piggy will Generate and RESERVE a SHINED copy of your last Coin Pair.",
		"anim": "piggy_anim"
	},

	"has_pocket_money": {
		"name": "Pocket Money",
		"desc": "Generate 8 STAMPED SILVER MOON Coins at the start of each battle. Half of these Coins will be RESERVED.",
		"anim": "pocket_money_anim"
	},

	"has_passive_income": {
		"name": "Passive Income",
		"desc": "Generate RESERVED DAZZLED Coins equal to 10% of Enemy Damage taken.",
		"anim": "passive_income_anim"
	},

	"has_reimbursement": {
		"name": "Tax Evasion",
		"desc": "When DEBT is applied to you, halve it, return the removed DEBT to the Enemy, and deal DAMAGE equal to the returned DEBT.",
		"anim": "tax_evasion_anim"
	},

	"has_payback": {
		"name": "Payback",
		"desc": "After taking Heavy Damage 4 times, cleanse all Debuffs and generate 12 SHINED SILVER SUN Coins next turn. Reset the counter afterwards.",
		"anim": "payback_anim"
	},

	"has_loan_shark": {
		"name": "Loan Shark",
		"desc": "Loan Shark accompanies you. For each Enemy Coin Flip, Loan Shark detonates 2% of their DEBT as DAMAGE. Each Enemy Coin Flip has a chance equal to their current DEBT (up to 100%) to become DAZZLED.",
		"anim": "loan_shark_anim"
	},

	"has_spare_change": {
		"name": "Spare Change",
		"desc": "Re-Flipping retrieves all RESERVED Coins. Retrieving a STAMPED Coin restores 1 Re-Flip.",
		"anim": "spare_change_anim"
	},

	"has_triple_nickel": {
		"name": "Coin Barrage",
		"desc": "+20% SILVER Flip Rate. Every time you Flip 10 SILVER/GOLD Coins in a turn, deal 10 Damage.",
		"anim": "coin_barrage_anim"
	},

	"has_deposit": {
		"name": "Deposit",
		"desc": "Max Reserve +4. RESERVING a Coin applies 1 GAIN. Statused Coins apply 3 GAIN instead.",
		"anim": "deposit_anim"
	},

	"has_dividend": {
		"name": "Dividend",
		"desc": "Each RESERVED Coin has a 30% chance to generate a copy of itself next turn.",
		"anim": "dividend_anim"
	},

	# =======================
	# S-RANK PASSIVES
	# =======================
	"has_inflation": {
		"name": "Inflation",
		"desc": "You Cannot Manually Reserve. Each Re-Flip has a 50% Chance for each Coin to Upgrade. Upgrading Beyond Gold consumes 1 Coin and applies SHINE. SHINE is now Stackable.",
		"anim": "inflation_anim"
	},

	"has_active_income": {
		"name": "Fully Paid",
		"desc": "The Shopkeeper accompanies you. Everytime you SETTLE all your DEBT, Shopkeeper gains a Turn and Flips 2 GOLD SUN Coins. Max Coin Flip increases by 2 each succeeding turn.",
		"anim": "fully_paid_anim"
	},

	"has_pay_down": {
		"name": "Bankrupt",
		"desc": "Your Coin Bar will only flip VOIDED Coins. For each VOIDED Coin Played/Cleansed, apply 2 DEBT to Self/Enemy. Execute the enemy if their DEBT is higher than their Coins.",
		"anim": "bankrupt_anim"
	},

	"has_refund": {
		"name": "All In",
		"desc": "If the Arcane Circle is empty at End Turn, automatically Flip 20 SILVER Coins with a 50% Chance of being STAMPED. Each Statused Coin flipped this way deals 3 DAMAGE.",
		"anim": "all_in_anim"
	},

	"has_cash_out": {
		"name": "Cash Out",
		"desc": "If there are 4 or more RESERVED Coins at the end of a Player or Enemy Turn, gain an EXTRA TURN. During Extra Turns, you can only Re-Flip and cannot gain additional Extra Turns.",
		"anim": "cash_out_anim"
	}
}

const RUN_GRADES = [
	{
		"min": 0,
		"max": 0,
		"rank": "F",
		"title": "Bankrupt",
		"color": "#5A5A5A" # Dark Gray
	},
	{
		"min": 1,
		"max": 14,
		"rank": "D-",
		"title": "Coin Gatherer",
		"color": "#7A4F2C" # Bronze Brown
	},
	{
		"min": 15,
		"max": 29,
		"rank": "D+",
		"title": "Wealth Seeker",
		"color": "#996633" # Copper
	},
	{
		"min": 30,
		"max": 44,
		"rank": "C-",
		"title": "Wandering Trader",
		"color": "#3F9E4D" # Green
	},
	{
		"min": 45,
		"max": 59,
		"rank": "C+",
		"title": "Coin Caster",
		"color": "#52C76B" # Bright Green
	},
	{
		"min": 60,
		"max": 74,
		"rank": "B-",
		"title": "Prosperity Keeper",
		"color": "#3A86FF" # Blue
	},
	{
		"min": 75,
		"max": 89,
		"rank": "B+",
		"title": "Arcane Merchant",
		"color": "#5FA8FF" # Bright Blue
	},
	{
		"min": 90,
		"max": 104,
		"rank": "A-",
		"title": "Treasury Warden",
		"color": "#8E5BFF" # Violet
	},
	{
		"min": 105,
		"max": 119,
		"rank": "A+",
		"title": "Fortune Architect",
		"color": "#B06CFF" # Bright Violet
	},
	{
		"min": 120,
		"max": 134,
		"rank": "S-",
		"title": "Vault Sovereign",
		"color": "#FFB000" # Gold
	},
	{
		"min": 135,
		"max": 149,
		"rank": "S+",
		"title": "Grand Financier",
		"color": "#FFD54A" # Bright Gold
	},
	{
		"min": 150,
		"max": 164,
		"rank": "SS-",
		"title": "Greed Sage",
		"color": "#FF8A00" # Orange Gold
	},
	{
		"min": 165,
		"max": 179,
		"rank": "SS+",
		"title": "Arcanist of Fortune",
		"color": "#FF5E5E" # Crimson
	},
	{
		"min": 180,
		"max": 194,
		"rank": "SSS-",
		"title": "Twilight Magnate",
		"color": "#FF4FD8" # Magenta
	},
	{
		"min": 195,
		"max": INF,
		"rank": "SSS+",
		"title": "Master of Arcoinium",
		"color": "#FFFFFF" # Pure White
	}
]

func _ready() -> void:
	ui_layer.modulate.a = 0.0
	ui_layer.scale = Vector2(0.8, 0.8) 
	ui_layer.pivot_offset = ui_layer.size / 2 
	dark_overlay.modulate.a = 0.0
	
	for child in left_vbox.get_children():
		child.modulate.a = 0.0
	for child in passives_grid.get_children():
		child.modulate.a = 0.0

	statistics_title.modulate.a = 0.0
	grade.modulate.a = 0.0
	title.modulate.a = 0.0
	for child in stats_container.get_children():
		child.modulate.a = 0.0

	play_slam_animation()

func play_slam_animation() -> void:
	
	# Get exact screen dimensions dynamically
	var screen_width = get_viewport_rect().size.x
	var half_screen = screen_width / 2.0
	
	# We need to know how wide the left door is so its RIGHT edge stops at the middle
	var left_door_width = left_door.size.x
	
	# 1. Force Starting Positions (Completely off-screen)
	right_edge.visible = true
	left_edge.visible = true
	left_door.position.x = -left_door_width - 160
	right_door.position.x = screen_width + 160
	
	var tween = create_tween()
	
	# ==========================================
	# PHASE 1: THE DOORS SLAM INWARD
	# ==========================================
	tween.set_parallel(true) 
	var left_target = half_screen - left_door_width 
	
	tween.tween_property(left_door, "position:x", left_target, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		
	
	var right_target = half_screen
	
	tween.tween_property(right_door, "position:x", right_target, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	# ==========================================
	# PHASE 2: THE IMPACT PAUSE
	# ==========================================
	
	tween.set_parallel(false) 
	tween.tween_callback(func():
		left_edge.visible = false
		right_edge.visible = false
		
		# Snap them perfectly flush the exact millisecond the jagged edges vanish!
		# This completely hides the seam without causing a draw-order overlap.
		left_door.position.x = half_screen - left_door_width
		right_door.position.x = half_screen
	)
	
	tween.tween_interval(0.4) 
	
	# ==========================================
	# PHASE 3: THE UI POPS UP
	# ==========================================
	tween.set_parallel(true)
	
	tween.tween_property(dark_overlay, "modulate:a", 0.6, 0.1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(ui_layer, "modulate:a", 1.0, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(ui_layer, "scale", Vector2(1.0, 1.0), 0.5)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	# ==========================================
	# PHASE 4: STAGGER THE CONTENTS (Left to Right)
	# ==========================================
	tween.set_parallel(false) 
	
	tween.tween_callback(func():
		# 1. Left Panel (Result + Message + Passives)
		var left_text_finish_time = stagger_pop_in(left_vbox, 0.0)
		var left_total_finish_time = stagger_pop_in(passives_grid, left_text_finish_time)
		
		
		# 2. Right Panel (Title)
		pop_in_single(statistics_title, left_total_finish_time)

		#2.5. GREED
		if player.greed:
			greed_stamp.visible = true
			await get_tree().create_timer(1.0).timeout
		
		# 3. Right Panel (Counting Stats Sequence)
		var current_delay = left_total_finish_time + 0.2
		var stat_stagger = 0.15
		
		for stat_data in stat_sequence:
			sound_manager.play_sound(GAME_OVER_WRITE)
			animate_counting_stat(stat_data["label"], stat_data["prefix"], stat_data["val"], current_delay)
			current_delay += stat_stagger
			
		# 4. Right Panel (Final Grade)
		pop_in_single(grade, current_delay + 0.5)
		pop_in_single(title, current_delay + 0.5)
	)
	
# ==========================================
# ANIMATION HELPERS
# ==========================================
func stagger_pop_in(container: Control, start_delay: float = 0.0) -> float:
	var delay = start_delay
	var stagger_time = 0.1
	
	for child in container.get_children():
		sound_manager.play_sound(GAME_OVER_WRITE)
		child.modulate.a = 0.0
		child.scale = Vector2(1.5, 1.5)
		child.pivot_offset = child.size / 2 
		
		var tween = create_tween().set_parallel(true)
		
		tween.tween_property(child, "modulate:a", 1.0, 0.3)\
			.set_delay(delay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			
		tween.tween_property(child, "scale", Vector2(1.0, 1.0), 0.4)\
			.set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			
		delay += stagger_time 
	return delay

func pop_in_single(node: Control, delay: float) -> void:
	sound_manager.play_sound(GAME_OVER_WRITE)
	node.modulate.a = 0.0
	node.scale = Vector2(1.5, 1.5)
	node.pivot_offset = node.size / 2 
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(node, "modulate:a", 1.0, 0.3)\
		.set_delay(delay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2(1.0, 1.0), 0.4)\
		.set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func animate_counting_stat(label: Label, prefix: String, target_value: int, delay: float) -> void:
	label.modulate.a = 0.0
	label.scale = Vector2(1.5, 1.5)
	label.pivot_offset = label.size / 2 
	label.text = prefix + "0" 
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(label, "modulate:a", 1.0, 0.3)\
		.set_delay(delay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.4)\
		.set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	# The count up animation takes 0.8 seconds
	tween.tween_method(
		func(current_val: int): label.text = prefix + str(current_val),
		0, target_value, 0.8 
	).set_delay(delay).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

# ==========================================
# DATA HANDOFF (Called from main.gd)
# ==========================================
# Change the last argument to 'player_node: Node'
func setup(stats: Dictionary, player_won: bool, title_text: String, killer_text: String, player_node: Node) -> void:
	player = player_node
	end_result.text = title_text
	mini_message.text = killer_text
	run_time.text = "Run Time: " + str(round(stats["run_time"]))
	await get_tree().process_frame
	
	shrink_text_to_fit(end_result, 48, 20)
	shrink_text_to_fit(mini_message, 24, 12)
	
	stat_sequence = [
		{"label": remaining_coins, "prefix": "Remaining Coins: ", "val": stats["remaining_coins"]},
		{"label": highest_dmg, "prefix": "Highest DMG: ", "val": stats["highest_damage_dealt"]},
		{"label": total_dmg, "prefix": "Overall Total DMG: ", "val": stats["overall_total_damage"]},
		{"label": highest_gain, "prefix": "Highest GAIN: ", "val": stats["highest_gain"]},
		{"label": total_gain, "prefix": "Overall Total GAIN: ", "val": stats["overall_total_gain"]},
		{"label": highest_debt, "prefix": "Highest DEBT: ", "val": stats["highest_debt_applied"]},
		{"label": total_debt, "prefix": "Overall Total DEBT: ", "val": stats["total_debt_applied"]},
		{"label": enemies_defeated, "prefix": "Enemies Defeated: ", "val": stats["enemies_defeated"]},
		{"label": sun_coins_flipped, "prefix": "Sun Coins Flipped: ", "val": stats["heads"]},
		{"label": moon_coins_flipped, "prefix": "Moon Coins Flipped: ", "val": stats["tails"]},
		{"label": total_flips, "prefix": "Total Flips: ", "val": stats["flips"]},
		{"label": total_reflips, "prefix": "Re-Flips: ", "val": stats["reflips"]},
		{"label": total_reserve_coins, "prefix": "Total Reserve Coins: ", "val": stats["total_reserved_coins"]}
	]
	
	# ==========================================
	# THE FOOLPROOF PASSIVE LOOP
	# ==========================================
	for key in PASSIVE_DATA.keys():
		# Check the player node directly! If they have it, spawn it.
		if player_node.get(key) == true:
			var data = PASSIVE_DATA[key]
			var icon = PASSIVE_ICON.instantiate()
			passives_grid.add_child(icon)
			
			if icon.has_method("setup"):
				icon.setup(data["name"], data["desc"])
			
	
	# ==========================================
	# GRADE CALCULATION
	# ==========================================
	
	var final_grade = get_run_grade(stats["remaining_coins"])
	
	var final_rank = final_grade.rank
	var final_title = final_grade.title
	
	grade.text = str(final_rank)
	title.text = str(final_title)
	grade.add_theme_color_override("font_color",final_grade.color)
	title.add_theme_color_override("font_color",final_grade.color)
	
	
func get_run_grade(final_coins: int) -> Dictionary:
	for grade in RUN_GRADES:
		if final_coins >= grade.min and final_coins <= grade.max:
			return grade

	return RUN_GRADES[0]

func shrink_text_to_fit(label: Label, max_font_size: int, min_font_size: int) -> void:
	var current_font_size = max_font_size
	
	# Force the label to start at the maximum desired size
	label.add_theme_font_size_override("font_size", current_font_size)
	label.reset_size()
	
	# While the text is physically wider than its allowed box, shrink it!
	while label.get_minimum_size().x > label.size.x and current_font_size > min_font_size:
		current_font_size -= 1
		label.add_theme_font_size_override("font_size", current_font_size)
		label.reset_size()


func _on_main_menu_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/Main_Menu.tscn")


func _on_try_again_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().paused = false
	get_tree().reload_current_scene()
