extends HBoxContainer
const PASSIVE_BAR_ICON = preload("uid://dldde8yrawlpn")
@onready var passives_container: GridContainer = $PassivesPanel/MarginContainer/VBoxContainer/GridContainer
var player_node

@onready var trust_stats: Label = $"StatsBoxPanel/MarginContainer/VBoxContainer/Trust Stats"

@onready var status_container: VFlowContainer = $StatusEffectsPanel/MarginContainer/StatusContainer
const STATUS_EFFECT = preload("uid://bmy7mewa8qp5l")
enum Status{
	GAIN,
	DEBT,
	THRIFT,
	SPEND,
	
	DROWSE,
	VOIDED,
	TALLY,
	STARSTRUCK,
	SEALED,
	SUNLIT_CURSE,
	MOONLIT_CURSE,
	SOLAR_BLESSED,
	LUNAR_BLESSED,
	
	BENCHMARK,
	AUDIT,
	SETTLE,
	EMPOWERED,
	RADIANT,
	
	MOMENTUM,
	TRUST,
	UNCHARGABLE,
	COUNTER,
	FULLY_PAID,
	FOCUSED
}

@onready var passive_name: Label = $PassivesPanel/MarginContainer/VBoxContainer/Passive_name
@onready var passive_desc: Label = $PassivesPanel/MarginContainer/VBoxContainer/Passive_desc

@onready var coins: Label = $StatsBoxPanel/MarginContainer/VBoxContainer/HBoxContainer/Coins
var is_closing: bool = false
var is_open: bool = false
var slide_distance: float = 30.0 
var target_y: float
var stagger_delay: float = 0.1


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
		"desc": "Flip the Last Coin played to its other side. For each Flip/Upgrade that occurred during End Turn Sequence, Deal 2 DAMAGE.",
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
		"desc": "Flipping a SILVER/GOLD Coin deals 1 DAMAGE. Generated Coins deal 3 DAMAGE instead.",
		"anim": "coin_snipe_anim"
	},

	"has_simple_interest": {
		"name": "Full Moon",
		"desc": "For each MOON-MOON Pair played, 1 Moon Coin becomes SHINED at the end of the turn.",
		"anim": "full_moon_anim"
	},

	"has_withdraw": {
		"name": "Withdraw",
		"desc": "Removing a RESERVED Coin deals 1 DAMAGE. Statused Coins deal 3 DAMAGE instead.",
		"anim": "withdraw_anim"
	},

	# =======================
	# A-RANK PASSIVES
	# =======================

	"has_lucky_pair": {
		"name": "Gold Rush",
		"desc": "+10% GOLD Flip Rate. For each SUN-SUN Pair played, 1 Random Coin is Upgraded to GOLD.",
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

	"has_magic_trick": {
		"name": "Magic Trick",
		"desc": "If you played 8+ Coins, the 1st Coin Pair generates copies of itself into the 2nd, 3rd, and 4th Pair at the end of the turn.",
		"anim": "magic_trick_anim"
	},

	"has_reimbursement": {
		"name": "Tax Evasion",
		"desc": "When DEBT is applied to you, halve it, return the removed DEBT to the Enemy, and deal DAMAGE equal to the returned DEBT.",
		"anim": "tax_evasion_anim"
	},

	"has_payback": {
		"name": "Payback",
		"desc": "Whenever an enemy deals Heavy Damage, generate 6 SHINED GOLD SUN Coins next turn.",
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
		"desc": "Max Reserve +2. RESERVING a Coin applies 2 GAIN with a 20% Chance to be STAMPED.",
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


func _ready() -> void:
	for child in get_children():
		child.modulate.a = 0.0
	

func setup(keeper:Node,player:Node) -> void:
	populate_passives(player)
	populate_stats(keeper,player)
	
func open() -> void:
	target_y = global_position.y
	global_position.y += slide_distance
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position:y", target_y, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var delay = 0.0
	for child in get_children():
		tween.tween_property(child, "modulate:a", 1.0, 0.3).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		delay += stagger_delay
	tween.chain().tween_callback(func(): is_open = true)

func close() -> void:
	if is_closing: return
	is_closing = true
	var tween = create_tween().set_parallel(true)
	var children = get_children()
	children.reverse()
	var delay = 0.0
	for child in children:
		tween.tween_property(child, "modulate:a", 0.0, 0.2).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		delay += stagger_delay
	tween.tween_property(self, "global_position:y", target_y + slide_distance, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(self.queue_free)


func populate_passives(player: Node) -> void:

	var active_passive_keys: Array[String] = []
	
	for variable_name in PASSIVE_DATA.keys():
		if player.get(variable_name) == true:
			active_passive_keys.append(variable_name)
			

	for key in active_passive_keys:
		var icon_instance = PASSIVE_BAR_ICON.instantiate()
		passives_container.add_child(icon_instance)
		
		var data = PASSIVE_DATA[key]
		
		icon_instance.setup(data["name"], data["desc"]) 
		
		icon_instance.mouse_entered.connect(show_passive_details.bind(data["name"], data["desc"]))
		
		
func show_passive_details(p_name: String, p_desc: String) -> void:
	# 1. Set the text
	passive_name.text = p_name
	passive_desc.text = p_desc
	# 2. Reset the font size to your maximum/default size (e.g., 16)
	var current_font_size = 24 
	passive_desc.add_theme_font_size_override("font_size", current_font_size)
	
	# 3. Force Godot to calculate the new text dimensions
	passive_desc.reset_size()
	
	# 4. While the text is wider than our box, shrink it!
	# (We stop at 8 so it doesn't become microscopic)
	while passive_desc.get_minimum_size().x > passive_desc.size.x and current_font_size > 10:
		current_font_size -= 1
		passive_desc.add_theme_font_size_override("font_size", current_font_size)
		passive_desc.reset_size()
	
	

func clear_passive_details() -> void:
	passive_name.text = "Passive Name"
	passive_desc.text = "Hover over a passive to view details."

func populate_stats(keeper:Node,player:Node) -> void:
	var stats_text = ""
	stats_text += "Coins: " + str(keeper.coin) + "\n"
	stats_text += "Max Flip: " + str(keeper.max_playable_coins) + "\n"
	stats_text += "Trust Level: " + str(keeper.trust) + "\n"
	
	trust_stats.text += "\nLevel 1: Base Form"
	if keeper.trust > 1: trust_stats.text += "\nLevel 2: SPEND Magic Learned"
	if keeper.trust > 2: trust_stats.text += "\nLevel 3: THRIFT Magic Learned"
	if keeper.trust > 3: trust_stats.text += "\nLevel 4: RADIANT State Learned"
	
	coins.text = stats_text
	
		# ==========================================
	# 3. POPULATE STATUS EFFECTS
	# ==========================================
	if player.has_active_income:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.FULLY_PAID,1)
		s.add_to_group("keeper_status")
		status_container.add_child(s)
	
	if player.has_merchant_scroll:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.COUNTER,1)
		s.add_to_group("keeper_status")
		status_container.add_child(s)
	
	if keeper.trust > 3:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.RADIANT,1)
		s.add_to_group("keeper_status")
		status_container.add_child(s)
	
	var s = STATUS_EFFECT.instantiate()
	s.set_status(Status.MOMENTUM,1)
	s.add_to_group("keeper_status")
	status_container.add_child(s)
	
	s = STATUS_EFFECT.instantiate()
	s.set_status(Status.UNCHARGABLE,1)
	s.add_to_group("keeper_status")
	status_container.add_child(s)
	
	s = STATUS_EFFECT.instantiate()
	s.set_status(Status.FOCUSED,1)
	s.add_to_group("keeper_status")
	status_container.add_child(s)
	
	
func _input(event: InputEvent) -> void:
	if is_open and not is_closing:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var menu_box = get_global_rect()
			var mouse_pos = get_global_mouse_position()
			if not menu_box.has_point(mouse_pos):
				close()
				get_viewport().set_input_as_handled()
