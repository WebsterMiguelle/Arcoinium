extends HBoxContainer
const PASSIVE_BAR_ICON = preload("uid://dldde8yrawlpn")
@onready var passives_container: GridContainer = $PassivesPanel/MarginContainer/VBoxContainer/GridContainer


var is_closing: bool = false
var slide_distance: float = 30.0 
var target_y: float
var stagger_delay: float = 0.1


const PASSIVE_DATA = {
	# =======================
	# B-RANK PASSIVES
	# =======================
	"has_solar_coin": {
		"name": "Solar Coin",
		"desc": "The 1st and 3rd Coin Flip is always SUN.",
		"anim": "solar_coin_anim"
	},
	"has_lunar_coin": {
		"name": "Lunar Coin",
		"desc": "The 2nd and 4th Coin Flip is always MOON.",
		"anim": "lunar_coin_anim"
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
		"name": "Merchant's Scroll",
		"desc": "25% Shop Discount.",
		"anim": "merchant_scroll_anim"
	},
	"has_impromptu_flip": {
		"name": "Impromptu Flip",
		"desc": "Upon ending the turn, the Last Coin on the Arcane Circle will be Upgraded, and Flipped to its other side.",
		"anim": "impromptu_flip_anim"
	},
	"has_advanced_planning": {
		"name": "Advanced Planning",
		"desc": "The First 2 Coins on the Arcane Circle will not be affected by Re-Flips. Upgrade these Coins at the end of the turn.",
		"anim": "advanced_planning_anim"
	},
	"has_value_increase": {
		"name": "Value Increase",
		"desc": "Upgrade all RESERVED Coins next turn. (RESERVED Coin: When Arcane Circle overflows with Coins, Reserve it.)",
		"anim": "value_increase_anim"
	},
	"has_lending_charge": {
		"name": "Lending Charge",
		"desc": "Each SUN-MOON Pair applies 3 DEBT.",
		"anim": "lending_charge_anim"
	},
	"has_coin_snipe": {
		"name": "Coin Snipe",
		"desc": "Flipping a SILVER or GOLD Coin deals 1 DAMAGE.",
		"anim": "coin_snipe_anim"
	},
	"has_simple_interest": {
		"name": "Simple Interest",
		"desc": "For each RESERVED Coin removed, apply 1 GAIN to self. (RESERVED Coin: When Arcane Circle overflows with Coins, Reserve it.)",
		"anim": "simple_interest_anim"
	},
	"has_withdraw": {
		"name": "Withdraw",
		"desc": "For each RESERVED Coin removed, deal 1 DAMAGE. (RESERVED Coin: When Arcane Circle overflows with Coins, Reserve it.)",
		"anim": "withdraw_anim"
	},
	
	# =======================
	# A-RANK PASSIVES
	# =======================
	"has_lucky_pair": {
		"name": "Lucky Pair",
		"desc": "+10% GOLD Flip Rate. The 7th and 8th Flipped Coin is upgraded.",
		"anim": "lucky_pair_anim"
	},
	"has_sleight_of_hand": {
		"name": "Sleight of Hand",
		"desc": "+4 Extra Re-Flips.",
		"anim": "sleight_of_hand_anim"
	},
	"has_piggy": {
		"name": "Piggy",
		"desc": "At the end of each turn, Piggy will duplicate your Last Coin Pair and add it to the Reserve.",
		"anim": "piggy_anim"
	},
	"has_pocket_money": {
		"name": "Pocket Money",
		"desc": "Start each battle with 8 SILVER MOON Coins.",
		"anim": "pocket_money_anim"
	},
	"has_passive_income": {
		"name": "Passive Income",
		"desc": "In every battle, the first Enemy DAMAGE will be turned into Coins. (Caps at 30 Coin GAIN)",
		"anim": "passive_income_anim"
	},
	"has_magic_trick": {
		"name": "Magic Trick",
		"desc": "Upon ending the turn with 8 or more Coins, the 1st Coin Pair will be copied to the 2nd, 3rd, and 4th Coin Pair.",
		"anim": "magic_trick_anim"
	},
	"has_reimbursement": {
		"name": "Reimbursement",
		"desc": "Each Flip and Re-Flip has a 30% Chance to apply 1 DEBT.",
		"anim": "reimbursement_anim"
	},
	"has_payback": {
		"name": "Payback",
		"desc": "If Coin Caster receives a killing blow, set Coin back to 1, Cleanse all Debuffs, and immediately generate 12 GOLD SUN Coins next turn. (One-Time per Battle)",
		"anim": "payback_anim"
	},
	"has_loan_shark": {
		"name": "Loan Shark",
		"desc": "At the start of the enemy’s turn, immediately deal damage based on half of the Enemy’s DEBT. Remove half of DEBT afterwards.",
		"anim": "loan_shark_anim"
	},
	"has_spare_change": {
		"name": "Spare Change",
		"desc": "Upon a Re-Flip, retrieve all RESERVED Coins. (RESERVED Coin: When Arcane Circle overflows with Coins, Reserve it.)",
		"anim": "spare_change_anim"
	},
	"has_triple_nickel": {
		"name": "Triple Nickel",
		"desc": "+20% SILVER Flip Rate. The first 3 Flips are SILVER Coins.",
		"anim": "triple_nickel_anim"
	},
	"has_deposit": {
		"name": "Deposit",
		"desc": "+4 Max Reserve.",
		"anim": "deposit_anim"
	},
	"has_dividend": {
		"name": "Dividend",
		"desc": "There is a 30% chance to duplicate each RESERVED Coin on the next turn. (RESERVED Coin: When Arcane Circle overflows with Coins, Reserve it.)",
		"anim": "dividend_anim"
	},

	# =======================
	# S-RANK PASSIVES
	# =======================
	"has_inflation": {
		"name": "Inflation",
		"desc": "There is a 50% chance for each Coin on the Arcane Circle to upgrade every Re-Flip. For every Gold Coin played, apply 1 SPEND.",
		"anim": "inflation_anim"
	},
	"has_active_income": { # Note: Tied to "Jar'O Savings" in your player.gd logic
		"name": "Jar'O Savings",
		"desc": "At the end of the 1st Turn, gain an EXTRA TURN, apply 16 THRIFT to the enemy, and generate 16 SILVER MOON Coins. Cannot Flip or Re-Flip during Extra Turns. (One-Time per Battle)",
		"anim": "jar_o_savings_anim"
	},
	"has_pay_down": {
		"name": "Pay Down",
		"desc": "Add 5 DEBT at the end of the Enemy’s Turn. If Enemy DEBT is greater than their Current Coins at the end of their turn, perish instantly.",
		"anim": "pay_down_anim"
	},
	"has_refund": { # Note: Tied to "All In" in your player.gd logic
		"name": "All In",
		"desc": "If there are No Coins on the Arcane Circle at the end of the turn, Automatically Flip 24 Upgraded Coins.",
		"anim": "all_in_anim"
	},
	"has_cash_out": {
		"name": "Cash Out",
		"desc": "When Coin Reserve is full at the end of the turn, immediately gain an EXTRA TURN. Cannot Flip or Re-Flip during Extra Turns.",
		"anim": "cash_out_anim"
	}
}

func _ready() -> void:
	for child in get_children():
		child.modulate.a = 0.0
	

func setup(player:Node) -> void:
	populate_passives(player)
	
func open() -> void:
	target_y = global_position.y
	global_position.y += slide_distance
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position:y", target_y, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var delay = 0.0
	for child in get_children():
		tween.tween_property(child, "modulate:a", 1.0, 0.3).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		delay += stagger_delay

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
	# 1. BUILD THE ARRAY
	# Instead of just animation names, we store the dictionary keys of the passives the player actually owns
	var active_passive_keys: Array[String] = []
	
	for variable_name in PASSIVE_DATA.keys():
		if player.get(variable_name) == true:
			active_passive_keys.append(variable_name)
			
	# 2. SPAWN THE ICONS
	for key in active_passive_keys:
		var icon_instance = PASSIVE_BAR_ICON.instantiate()
		
		# Add it to the GridContainer first so it enters the scene tree
		passives_container.add_child(icon_instance)
		
		# Grab the specific dictionary block for this passive
		var data = PASSIVE_DATA[key]
		
		# Pass the 3 pieces of data directly into the icon's setup function!
		icon_instance.setup(data["name"], data["desc"], data["name"])
