extends HBoxContainer
const PASSIVE_BAR_ICON = preload("uid://dldde8yrawlpn")
@onready var passives_container: GridContainer = $PassivesPanel/MarginContainer/VBoxContainer/GridContainer


var is_closing: bool = false
var slide_distance: float = 30.0 
var target_y: float
var stagger_delay: float = 0.1


const PASSIVE_LIST = {
	"has_wishbone": "Wishbone",
	"has_golden_clover" : "Golden Clover",
	"has_solar_coin": "Soalr Coin",
	"has_lunar_coin": "Lunar Coin",
	"has_merchant_scroll" : "Merchant Scroll",
	"has_impromptu_flip" : "Impromptu Flip",
	"has_magic_trick" : "Magic Trick",
	"has_sleight_of_hand" : "Sleight of Hand",
	"has_piggy" : "Piggy",
	"has_inflation" : "Inflation",
	"has_payback" : "Payback",
	"has_lucky_pair": "Lucky Pair",
	"has_value_increase": "Value Increase",
	"has_spare_change" : "Spare Change",
	"has_triple_nickel" : "Triple Nickel",
	"has_refund" : "Refund",
	"has_coin_snipe" : "Coin Snipe",
	"has_active_income" : "Active Income",
	"has_pocket_money" : "Pocket Money",
	"has_passive_income" : "Passive Income",
	"has_simple_interest" : "Simple Interest",
	"has_pay_down" : "Pay Down",
	"has_reimbursement" : "Reimbursement",
	"has_loan_shark" : "Loan Shark",
	"has_lending_charge" : "Lending Charge",
	"has_cash_out" : "Cash Out",
	"has_dividend" : "Dividend",
	"has_withdraw" : "Withdraw",
	"has_deposit" : "Deposit"
}


func _ready() -> void:
	for child in get_children():
		child.modulate.a = 0.0

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
	# --- 1. CLEAR THE OLD UI ---
	for child in passives_container.get_children():
		child.queue_free()
		
	# --- 2. BUILD THE ARRAY ---
	var active_passives: Array[String] = []
	
	# Loop through our dictionary to check the player's stats dynamically
	for variable_name in PASSIVE_LIST.keys():
		if player.get(variable_name) == true:
			# If they have it, add the animation string to our array!
			active_passives.append(PASSIVE_LIST[variable_name])
			
			
	# --- 3. SPAWN THE ICONS FROM THE ARRAY ---
	for anim_name in active_passives:
		# Instantiate the Control Node scene
		var icon_instance = PASSIVE_BAR_ICON.instantiate()
		
		# Add it to the GridContainer
		passives_container.add_child(icon_instance)
		
		# Find the AnimatedSprite2D inside the instantiated scene and play the animation
		# Note: Change "AnimatedSprite2D" to whatever you actually named the node inside your icon scene!
		var sprite = icon_instance.get_node("AnimatedSprite2D")
		sprite.play(anim_name)
