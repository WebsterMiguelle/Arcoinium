extends CanvasLayer
const SHOPKEEPER_VOICE = preload("uid://c86gce7j7tjey")
@onready var container = $Background/CenterContainer/VBoxContainer/CardContainer
const Shop_card = preload("res://Scene/shop_card.tscn")
@onready var bg = $Background
@onready var back_button: Button = $Back
@onready var main = get_node("/root/Main")
@onready var coin_label = $Background/CoinLabel
@onready var player: Node2D = $"../Player"
@onready var carpet: TextureRect = $Background/Carpet
@onready var shop_keeper: AnimatedSprite2D = $"Background/Shop Keeper_Portrait"
const SHOP_BELL = preload("uid://1kl4yi6uvnhn")

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
	{"id": 0, "name": "Solar Blessing", "rank": "B", "desc": "When 8 or more SUN Coins are played this turn, all Odd Flips next turn are guaranteed SUN."},
	{"id": 1, "name": "Lunar Blessing", "rank": "B", "desc": "When 8 or more MOON Coins are played this turn, all Even Flips next turn are guaranteed MOON."},
	{"id": 2, "name": "Wish Bone", "rank": "B", "desc": "+20% SILVER Flip Rate."},
	{"id": 3, "name": "Golden Clover", "rank": "B", "desc": "+10% GOLD Flip Rate."},
	{"id": 4, "name": "Flip Sequence", "rank": "B", "desc": "Flip the Last Coin played to its other side. For each Flip that occurred during End Turn Sequence, Deal 1 DAMAGE."},
	{"id": 5, "name": "Seal of Approval", "rank": "B", "desc": "The first 2 Coins placed on the Arcane Circle become STAMPED. At the end of the turn, Remove all STAMP from Played Coins and Upgrade them."},
	{"id": 6, "name": "Value Increase", "rank": "B", "desc": "Upgrade all RESERVED Coins next turn."},
	{"id": 7, "name": "Lending Charge", "rank": "B", "desc": "SUN-MOON Pairs apply 3 DEBT. If all played Pairs are SUN-MOON, apply double DEBT."},
	{"id": 8, "name": "Coin Snipe", "rank": "B", "desc": "Flipping a SILVER or GOLD Coin deals 1 DAMAGE. Generated Coins deal 3 DAMAGE instead."},
	{"id": 9, "name": "Simple Interest", "rank": "B", "desc": "RESERVING a Coin applies 1 GAIN to yourself."},

	{"id": 10, "name": "Lucky Pair", "rank": "A", "desc": "+10% GOLD Flip Rate. The 9th and 10th Flipped Coins are SHINED at the end of the turn."},
	{"id": 11, "name": "Pickpocket", "rank": "A", "desc": "+2 Re-Flips. Re-Flipping deals 1 DAMAGE and generates a RESERVED Coin with a Random Status Effect."},
	{"id": 12, "name": "Piggy", "rank": "A", "desc": "End Turn: Generate and RESERVE a SHINED copy of your last Coin Pair."},
	{"id": 13, "name": "Pocket Money", "rank": "A", "desc": "Generate 8 STAMPED SILVER MOON Coins at the start of each battle. Half of these Coins will be RESERVED."},
	{"id": 14, "name": "Passive Income", "rank": "A", "desc": "Generate RESERVED DAZZLED Coins equal to 10% of Enemy Damage taken."},
	{"id": 15, "name": "Magic Trick", "rank": "A", "desc": "If you played 8+ Coins, the 1st Coin Pair generates copies of itself into the 2nd, 3rd, and 4th Pair at the end of the turn."},
	{"id": 16, "name": "Tax Evasion", "rank": "A", "desc": "When DEBT is applied to you, halve it, return the removed DEBT to the Enemy, and deal DAMAGE equal to the returned DEBT."},
	{"id": 17, "name": "Payback", "rank": "A", "desc": "Fatal Damage leaves you at 1 Coin, cleanses all Debuffs, and generates 12 SHINED GOLD SUN Coins next turn. (Once per Battle)"},
	{"id": 18, "name": "Loan Shark", "rank": "A", "desc": "For each Enemy Coin Flip, detonate 5% of their DEBT as DAMAGE. Each Enemy Coin Flip has a chance equal to their current DEBT (up to 100%) to become DAZZLED."},
	{"id": 19, "name": "Spare Change", "rank": "A", "desc": "Re-Flipping retrieves all RESERVED Coins. Retrieving a STAMPED Coin restores 1 Re-Flip."},
	{"id": 20, "name": "Triple Nickel", "rank": "A", "desc": "+20% SILVER Flip Rate. Your first 3 Flips each turn are guaranteed SHINED SILVER Coins."},

	{"id": 21, "name": "Inflation", "rank": "S", "desc": "You Cannot Manually Reserve. Each Re-Flip has a 30% Chance for each Coin to Upgrade. Upgrading Beyond Gold consumes 1 Coin and applies SHINE. SHINE is now Stackable."},
	{"id": 22, "name": "Fully Paid", "rank": "S", "desc": "Everytime you SETTLE all your DEBT, Deal 15 DAMAGE and apply 4 THRIFT. For each successful SETTLE, DAMAGE further increases by 15."},
	{"id": 23, "name": "Bankrupt", "rank": "S", "desc": "Your Coin Bar will only flip VOIDED Coins. For each VOIDED Coin Played/Cleansed, apply 2 DEBT to Self/Enemy. Execute the enemy if their DEBT is higher than their Coins."},
	{"id": 24, "name": "All In", "rank": "S", "desc": "If the Arcane Circle is empty at End Turn, automatically Flip 20 Upgraded Coins with a 50% Chance of being STAMPED. Each Statused Coin flipped this way deals 3 DAMAGE."},
	{"id": 25, "name": "Withdraw", "rank": "B", "desc": "Removing a RESERVED Coin deals 1 DAMAGE. Statused Coins deal 3 DAMAGE instead."},
	{"id": 26, "name": "Deposit", "rank": "A", "desc": "+4 Max Reserve. Overflowing Reserve applies 3 GAIN per Coin."},
	{"id": 27, "name": "Dividend", "rank": "A", "desc": "Each RESERVED Coin has a 30% chance to generate a copy of itself next turn."},
	{"id": 28, "name": "Cash Out", "rank": "S", "desc":  "If there are 4 or more RESERVED Coins at the end of a Player or Enemy Turn, gain an EXTRA TURN. During Extra Turns, you can only Re-Flip and cannot gain additional Extra Turns."}
]

func show_shop_async(player):
	
	carpet.modulate.a = 0
	shop_keeper.modulate.a = 0
	await main.sound_manager.play_sound(SHOP_BELL)
	main.sound_manager.play_sound(SHOPKEEPER_VOICE)
	shop_done = false
	player_ref = player
	show()
	
	var tween = create_tween()
	tween.parallel().tween_property(carpet,"modulate:a",1,0.4)
	tween.parallel().tween_property(shop_keeper,"modulate:a",1,0.4)
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
	if !main.player.has_merchant_scroll:
		selected_cards += draw_cards(b_pool, 2)
		selected_cards += draw_cards(a_pool, 4)
		selected_cards += draw_cards(s_pool, 2)
	else:
		selected_cards += draw_cards(b_pool, 1)
		selected_cards += draw_cards(a_pool, 4)
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
			"S": base_price = 45
			"A": base_price = 30
			"B": base_price = 15
			
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
			print("Impromptu Flip Passive")
			main.player.has_impromptu_flip = true
		5:
			print("Seal of Approval Passive")
			main.player.has_advanced_planning = true
		6:
			print("Value Increase Passive")
			main.player.has_value_increase = true
		7:
			print("Lending Charge Passive")
			main.player.has_lending_charge = true
		8:
			print("Coin Snipe Passive")
			main.player.has_coin_snipe = true
		9:
			print("Simple Interest Passive")
			main.player.has_simple_interest = true
		10:
			print("Lucky Pair")
			main.player.has_lucky_pair = true
			main.player.gold_flip_rate += 0.1
		11:
			print("A-Rank: Pickpocket")
			main.player.has_sleight_of_hand = true
			main.player.max_re_flip += 2
		12:
			print("A-Rank: Piggy")
			main.player.has_piggy = true
		13:
			print("A-Rank: Pocket Money")
			main.player.has_pocket_money = true
		14:
			print("A-Rank: Passive Income")
			main.player.has_passive_income = true
		15:
			print("A-Rank: Magic Trick")
			main.player.has_magic_trick = true
		16:
			print("A-Rank: Tax Evasion")
			main.player.has_reimbursement = true
		17:
			print("A-Rank: Payback")
			main.player.has_payback = true
		18:
			print("A-Rank: Loan Shark")
			main.player.has_loan_shark = true
		19:
			print("A-Rank: Spare Change")
			main.player.has_spare_change = true
		20:
			print("A-Rank:Triple Nickel")
			main.player.has_triple_nickel = true
			main.player.silver_flip_rate += 0.2
		21:
			print("S-Rank: Inflation")
			main.player.has_inflation = true
		22:
			print("S-Rank: Active Income")
			main.player.has_active_income = true
		23:
			print("S-Rank: Bankrupt")
			main.player.has_pay_down = true
		24:
			print("S-Rank: Refund")
			main.player.has_refund = true
			main.player.max_re_flip += 1
		25:
			print("B-Rank: Withdraw")
			main.player.has_withdraw = true
		26:
			print("A-Rank: Deposit")
			main.player.has_deposit = true
			main.player.max_reserve += 4
		27:
			print("A-Rank: Dividend")
			main.player.has_dividend = true
		28:
			print("S-Rank: Cash Out")
			main.player.has_cash_out = true
		_:
			print("Other reward")


func close_shop():
	bg.visible = false
	visible = false
	shop_done = true
	var tween = create_tween()
	tween.parallel().tween_property(carpet,"modulate:a",0,0.4)
	tween.parallel().tween_property(shop_keeper,"modulate:a",0,0.4)
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
			return main.player.has_impromptu_flip
		5: 
			return main.player.has_advanced_planning
		6: 
			return main.player.has_value_increase
		7: 
			return main.player.has_lending_charge
		8: 
			return main.player.has_coin_snipe
		9: 
			return main.player.has_simple_interest
		10: 
			return main.player.has_lucky_pair
		11: 
			return main.player.has_sleight_of_hand
		12: 
			return main.player.has_piggy
		13: 
			return main.player.has_pocket_money
		14: 
			return main.player.has_passive_income
		15: 
			return main.player.has_magic_trick
		16: 
			return main.player.has_reimbursement
		17: 
			return main.player.has_payback
		18: 
			return main.player.has_loan_shark
		19: 
			return main.player.has_spare_change
		20: 
			return main.player.has_triple_nickel
		21: 
			return main.player.has_inflation
		22: 
			return main.player.has_active_income
		23: 
			return main.player.has_pay_down
		24: 
			return main.player.has_refund
		25:
			return main.player.has_withdraw
		26:
			return main.player.has_deposit
		27:
			return main.player.has_dividend
		28:
			return main.player.has_cash_out
		_:
			return false
