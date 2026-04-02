extends CanvasLayer

@onready var container = $Background/CenterContainer/VBoxContainer/CardContainer
const Shop_card = preload("res://Scene/shop_card.tscn")
@onready var bg = $Background
@onready var back_button = $Background/Back
@onready var main = get_node("/root/Main")
@onready var coin_label = $Background/CoinLabel
@onready var player: Node2D = $"../Player"

const SCROLL_HOVERED = preload("uid://dpcddmlbji61k")
const SCROLL_OPEN = preload("uid://ciyhsb2lowwtt")

# NEW: Reference the new text box you just made!
@onready var descriptions: Label = $Background/Descriptions

var player_ref
var shop_done := false

signal item_purchased(card_id, price)
signal shop_closed

# UPDATED: Now contains all the "desc" keys!
var all_cards = [
	{"id": 0, "name": "Solar Coin", "rank": "B", "desc": "Guarantee that the 1st and 3rd coin flip is a Sun."},
	{"id": 1, "name": "Lunar Coin", "rank": "B", "desc": "Guarantee that the 2nd and 4th coin flip is a Moon."},
	{"id": 2, "name": "Wish Bone", "rank": "B", "desc": "Raise chances of flipping a Silver Coin by 20%."},
	{"id": 3, "name": "Golden Clover", "rank": "B", "desc": "Raise chances of flipping a Gold Coin by 10%."},
	{"id": 4, "name": "Merchant's Scroll", "rank": "B", "desc": "25% Shop Discount."},
	{"id": 5, "name": "Impromptu Flip", "rank": "B", "desc": "Upon ending the turn, the last coin on the Arcane Circle will be upgraded, and flipped to its other side."},
	{"id": 6, "name": "Advanced Planning", "rank": "B", "desc": "The first 2 coins on the Arcane Circle will not be affected by Re-Flips. Upgrade these coins at the end of the turn."},
	{"id": 7, "name": "Value Increase", "rank": "B", "desc": "Upgrade all reserved coins next turn."},
	{"id": 8, "name": "Lending Charge", "rank": "B", "desc": "Each Sun-Moon Pairs played this turn applies 3 Debt to the enemy."},
	{"id": 9, "name": "Coin Snipe", "rank": "B", "desc": "If Coin Caster flipped a Silver or Gold Coin, Deal 1 Damage to the enemy."},
	{"id": 10, "name": "Simple Interest", "rank": "B", "desc": "For each reserved coin added to the Arcane Circle next turn, apply 1 Gain to self."},
	{"id": 11, "name": "Lucky Pair", "rank": "A", "desc": "+10% Gold Flip Rate. The 7th and 8th Flipped Coin on every turn is guaranteed to be upgraded."},
	{"id": 12, "name": "Sleight of Hand", "rank": "A", "desc": "+4 Extra Re-Flips."},
	{"id": 13, "name": "Piggy", "rank": "A", "desc": "At the start of each turn, Piggy will generate the 1st Coin Pair on the Arcane Circle based on the previous turn’s Last Coin Pair."},
	{"id": 14, "name": "Pocket Money", "rank": "A", "desc": "Start each battle with 8 Silver Moon Coins."},
	{"id": 15, "name": "Passive Income", "rank": "A", "desc": "In every battle, the first enemy damage will be turned into Coins. (Caps at 30 Coin Gain)"},
	{"id": 16, "name": "Magic Trick", "rank": "A", "desc": "Upon ending the turn with 8 or more Coins, the 1st Coin Pair will be copied to the 2nd, 3rd, and 4th Coin Pair."},
	{"id": 17, "name": "Reimbursement", "rank": "A", "desc": "Each Flip and Re-Flip has a 30% Chance to apply 1 Debt."},
	{"id": 18, "name": "Payback", "rank": "A", "desc": " If Coin Caster receives a killing blow, set Coin back to 1, Apply 16 Thrift to the Enemy, and immediately generate 8 Silver Sun Coins next turn. (One-Time per Battle)"},
	{"id": 19, "name": "Loan Shark", "rank": "A", "desc": "At the start of the enemy’s turn, immediately deal damage based on half of the Enemy’s Debt."},
	{"id": 20, "name": "Spare Change", "rank": "A", "desc": "Upon a Re-Flip, retrieve all reserved coins on the deck."},
	{"id": 21, "name": "Triple Nickel", "rank": "A", "desc": "+20% Silver Flip Rate. The first 3 Flips on every turn are guaranteed to be Silver Coins."},
	{"id": 22, "name": "Inflation", "rank": "S", "desc": "+1 Extra Re-Flip. There is a 30% chance for each coin on the Arcane Circle to upgrade every Re-Flip."},
	{"id": 23, "name": "Jar'O Savings", "rank": "S", "desc":"For every 15 Gain, apply 2 Thrift to the Enemy."},
	{"id": 24, "name": "Pay Down", "rank": "S", "desc": "Add 5 Debt at the end of the Enemy’s Turn. If Enemy Debt is greater than their Current Coins at the end of their turn, perish instantly."},
	{"id": 25, "name": "Refund", "rank": "S", "desc": "+1 Extra Re-Flip. There is a 20% chance to retrieve all coins from the Arcane Circle upon a Re-Flip. Refresh Re-Flip Count afterwards."},
	{"id": 26, "name": "Withdraw", "rank": "B", "desc": "For each reserved coin added to the Arcane Circle next turn, deal 2 Damage."},
	{"id": 27, "name": "Deposit", "rank": "A", "desc": "+4 Max Reserve."},
	{"id": 28, "name": "Dividend", "rank": "A", "desc": "There is a 30% chance to duplicate each reserved coin on the next turn."},
	{"id": 29, "name": "Cash Out", "rank": "S", "desc": " When Coin Caster flipped all playable and reservable coins, immediately gain an Extra Turn upon ending the current turn. Coin Caster cannot Flip or Re-Flip during Extra Turns."}
]

func show_shop_async(player):
	shop_done = false
	player_ref = player
	show()
	
	bg.visible = true
	visible = true
	back_button.disabled = false 
	
	# Clear the label when the shop opens!
	if descriptions:
		descriptions.text = ""
	
	generate_shop()
	
	while not shop_done:
		await get_tree().process_frame
		
func draw_cards(from_pool: Array, amount: int) -> Array:
	var result = []
	for i in range(amount):
		if from_pool.is_empty():
			break
		var pick = from_pool.pick_random()
		result.append(pick)
		from_pool.erase(pick) # prevent duplicates
	return result

func generate_shop():
	for child in container.get_children():
		child.queue_free()
		
	var pool = all_cards.duplicate()
	pool = pool.filter(func(card):
		return not is_card_owned(card["id"])
	)
	
	var b_pool = pool.filter(func(c): return c["rank"] == "B")
	var a_pool = pool.filter(func(c): return c["rank"] == "A")
	var s_pool = pool.filter(func(c): return c["rank"] == "S")
	
	var selected_cards = []
	selected_cards += draw_cards(b_pool, 1)
	selected_cards += draw_cards(a_pool, 2)
	selected_cards += draw_cards(s_pool, 3)

	for data in selected_cards:
		var card = Shop_card.instantiate()
	
		card.card_id = data["id"]
		card.card_name = data["name"]
		card.card_rank = data["rank"]
		
		# NEW: Hand the description to the shop card!
		card.card_desc = data.get("desc", "")
		
		var base_price = 10
		match card.card_rank:
			"S": base_price = 30
			"A": base_price = 20
			"B": base_price = 10
			
		# BONUS: Your Merchant Scroll Logic perfectly implemented!
		if main.player.has_merchant_scroll:
			card.price = int(base_price * 0.75) # 25% Off!
		else:
			card.price = base_price
			
		card.stock = 1
		
		card.card_bought.connect(_on_card_bought.bind(card))
		
		# NEW: Listen for the hover signals!
		card.card_hovered.connect(_on_card_hovered)
		card.card_unhovered.connect(_on_card_unhovered)
		card.setup(main)
		container.add_child(card)

# NEW: Update the label when hovered
func _on_card_hovered(description_text: String) -> void:
	main.sound_manager.play_sound(SCROLL_HOVERED)
	if descriptions:
		descriptions.text = description_text

# NEW: Clear the label when mouse leaves
func _on_card_unhovered() -> void:
	if descriptions:
		descriptions.text = ""
		
func _on_card_bought(card_id, price, card):
	if player_ref.coin >= price:
		player_ref.coin -= price
		apply_item(card_id)
		emit_signal("item_purchased", card_id, price)
		card.disabled = true
		card.modulate = Color(0.5, 0.5, 0.5)
		
		# NEW: Clear the description text when they buy it
		if descriptions:
			descriptions.text = ""
		
		coin_label.text = "Coins: " + str(player_ref.coin)
		for c in container.get_children():
			c.update_state(player_ref.coin)
		
	else:
		print("Not enough coins!")
		
func apply_item(card_id):
	# ... (Your existing apply_item logic remains entirely unchanged here) ...
	match card_id:
		0:
			print("Solar Coin Passive")
			main.player.has_solar_coin = true
		1:
			print("Lunar Coin")
			main.player.has_lunar_coin = true
		2:
			print("Wish Bone")
			main.player.has_wishbone = true
			main.player.silver_flip_rate += 0.2
		3:
			print("Golden Clover")
			main.player.has_golden_clover = true
			main.player.gold_flip_rate += 0.1
		4:
			print("Merchant Scroll Passive")
			main.player.has_merchant_scroll = true
		5:
			print("Impromptu Flip Passive")
			main.player.has_impromptu_flip = true
		6:
			print("Advanced Planning Passive")
			main.player.has_advanced_planning = true
		7:
			print("Value Increase Passive")
			main.player.has_value_increase = true
		8:
			print("Lending Charge Passive")
			main.player.has_lending_charge = true
		9:
			print("Coin Snipe Passive")
			main.player.has_coin_snipe = true
		10:
			print("Simple Interest Passive")
			main.player.has_simple_interest = true
		11:
			print("Lucky Pair")
			main.player.has_lucky_pair = true
			main.player.gold_flip_rate += 0.1
		12:
			print("A-Rank: Sleight of Hand")
			main.player.has_sleight_of_hand = true
			main.player.max_re_flip += 4
		13:
			print("A-Rank: Piggy")
			main.player.has_piggy = true
		14:
			print("A-Rank: Pocket Money")
			main.player.has_pocket_money = true
		15:
			print("A-Rank: Passive Income")
			main.player.has_passive_income = true
		16:
			print("A-Rank: Magic Trick")
			main.player.has_magic_trick = true
		17:
			print("A-Rank: Reimbursement")
			main.player.has_reimbursement = true
		18:
			print("A-Rank: Payback")
			main.player.has_payback = true
		19:
			print("A-Rank: Loan Shark")
			main.player.has_loan_shark = true
		20:
			print("A-Rank: Spare Change")
			main.player.has_spare_change = true
		21:
			print("A-Rank:Triple Nickel")
			main.player.has_triple_nickel = true
			main.player.silver_flip_rate += 0.2
		22:
			print("S-Rank: Inflation")
			main.player.has_inflation = true
			main.player.max_re_flip += 1
		23:
			print("S-Rank: Active Income")
			main.player.has_active_income = true
		24:
			print("S-Rank: Pay Down")
			main.player.has_pay_down = true
		25:
			print("S-Rank: Refund")
			main.player.has_refund = true
			main.player.max_re_flip += 1
		26:
			print("B-Rank: Withdraw")
			main.player.has_withdraw = true
		27:
			print("A-Rank: Deposit")
			main.player.has_deposit = true
			main.player.max_reserve += 4
		28:
			print("A-Rank: Dividend")
			main.player.has_dividend = true
		29:
			print("S-Rank: Cash Out")
			main.player.has_cash_out = true
		_:
			print("Other reward")


func close_shop():
	bg.visible = false
	visible = false
	shop_done = true
	emit_signal("shop_closed")
	
func _ready() -> void:
	if not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)

func _process(_delta: float) -> void:
	if not visible or player_ref == null:
		return
		
	coin_label.text = "Coins: " + str(player_ref.coin)

func _on_proceed_pressed():
	emit_signal("shop_closed")
	queue_free()

func _on_back_pressed() -> void:
	close_shop()
	
func is_card_owned(card_id: int) -> bool:
	match card_id:
		0: 
			return main.player.has_solar_coin
		1: 
			return main.player.has_lunar_coin
		2: 
			return main.player.has_wishbone
		3: 
			return main.player.has_golden_clover
		4: 
			return main.player.has_merchant_scroll
		5: 
			return main.player.has_impromptu_flip
		6: 
			return main.player.has_advanced_planning
		7: 
			return main.player.has_value_increase
		8: 
			return main.player.has_lending_charge
		9: 
			return main.player.has_coin_snipe
		10: 
			return main.player.has_simple_interest
		11: 
			return main.player.has_lucky_pair
		12: 
			return main.player.has_sleight_of_hand
		13: 
			return main.player.has_piggy
		14: 
			return main.player.has_pocket_money
		15: 
			return main.player.has_passive_income
		16: 
			return main.player.has_magic_trick
		17: 
			return main.player.has_reimbursement
		18: 
			return main.player.has_payback
		19: 
			return main.player.has_loan_shark
		20: 
			return main.player.has_spare_change
		21: 
			return main.player.has_triple_nickel
		22: 
			return main.player.has_inflation
		23: 
			return main.player.has_active_income
		24: 
			return main.player.has_pay_down
		25: 
			return main.player.has_refund
		26:
			return main.player.has_withdraw
		27:
			return main.player.has_deposit
		28:
			return main.player.has_dividend
		29:
			return main.player.has_cash_out
		_:
			return false
