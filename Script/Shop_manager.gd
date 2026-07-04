extends CanvasLayer
const SHOPKEEPER_VOICE = preload("uid://c86gce7j7tjey")
@onready var container: GridContainer = $CenterContainer/VBoxContainer/CardContainer
const Shop_card = preload("res://Scene/shop_card.tscn")
@onready var bg = $Background
@onready var back_button: Button = $Back
@onready var main = get_node("/root/Main")
@onready var coin_label: Label = $CoinLabel
@onready var player: Node2D = $"../Player"
@onready var carpet: TextureRect = $Background/Carpet
@onready var shop_keeper: AnimatedSprite2D = $"Background/Shop Keeper_Portrait"
const SHOP_BELL = preload("uid://1kl4yi6uvnhn")
@onready var refresh_sprite: AnimatedSprite2D = $Refresh/Refresh_Sprite
@onready var refresh_price: Label = $Refresh/Refresh_Price
@onready var refresh_button: Button = $Refresh
var refresh_base_value = 5
const SCROLL_HOVERED = preload("uid://dpcddmlbji61k")
const SCROLL_OPEN = preload("uid://ciyhsb2lowwtt")

# NEW: Reference the new text box you just made!
@onready var descriptions: Label = $Background/Descriptions


var player_ref
var shop_done := false
var refresh_count := 0
var purchased_ids := []
var current_cards := []
var card_nodes := []

var purchase_count = 0

signal item_purchased(card_id, price)
signal shop_closed

# UPDATED: Now contains all the "desc" keys!
var all_cards = [
	{"id": 0, "name": "Solar Blessing", "rank": "B", "desc": "When 8 or more SUN Coins are played this turn, all Odd Flips next turn are guaranteed SUN."},
	{"id": 1, "name": "Lunar Blessing", "rank": "B", "desc": "When 8 or more MOON Coins are played this turn, all Even Flips next turn are guaranteed MOON."},
	{"id": 2, "name": "Wish Bone", "rank": "B", "desc": "+20% SILVER Flip Rate."},
	{"id": 3, "name": "Golden Clover", "rank": "B", "desc": "+10% GOLD Flip Rate."},
	{"id": 4, "name": "Keeper's Scroll", "rank": "B", "desc": "I shall accompany you. When you receive Damage, I gain a Turn and will flip 1 STAMPED COPPER MOON-SUN Pair. Max Coin Flip increases by 2 each succeeding turn."},
	{"id": 5, "name": "Flip Sequence", "rank": "B", "desc": "Flip the Last Coin played to its other side. For each Flip/Upgrade that occurred during End Turn Sequence, Deal 2 DAMAGE."},
	{"id": 6, "name": "Seal of Approval", "rank": "B", "desc": "The first 2 Coins placed on the Arcane Circle become STAMPED. At the end of the turn, Remove all STAMP from Played Coins and Upgrade them."},
	{"id": 7, "name": "Value Increase", "rank": "B", "desc": "Upgrade all RESERVED Coins next turn. Upgrading Beyond Gold applies SHINE instead."},
	{"id": 8, "name": "Lending Charge", "rank": "B", "desc": "SUN-MOON Pairs apply 3 DEBT. If all played Pairs are SUN-MOON, apply double DEBT."},
	{"id": 9, "name": "Coin Snipe", "rank": "B", "desc": "Flipping a SILVER/GOLD Coin deals 1 DAMAGE. Generated Coins deal 3 DAMAGE instead."},
	{"id": 10, "name": "Full Moon", "rank": "B", "desc": "For each MOON-MOON Pair played, 1 Moon Coin becomes SHINED at the end of the turn."},

	{"id": 11, "name": "Gold Rush", "rank": "A", "desc": "+10% Gold Flip Rate. For each SUN-SUN Pair played, 1 Random Coin is Upgraded to GOLD."},
	{"id": 12, "name": "Pickpocket", "rank": "A", "desc": "+2 Re-Flips. Re-Flipping deals 1 DAMAGE and generates a RESERVED Coin with a Random Status Effect."},
	{"id": 13, "name": "Piggy", "rank": "A", "desc": "Piggy accompanies you. At the end of the turn, Piggy will Generate and RESERVE a SHINED copy of your last Coin Pair."},
	{"id": 14, "name": "Pocket Money", "rank": "A", "desc": "Generate 8 STAMPED SILVER MOON Coins at the start of each battle. Half of these Coins will be RESERVED."},
	{"id": 15, "name": "Passive Income", "rank": "A", "desc": "Generate RESERVED DAZZLED Coins equal to 10% of Enemy Damage taken."},
	{"id": 16, "name": "Magic Trick", "rank": "A", "desc": "If you played 8+ Coins, the 1st Coin Pair generates copies of itself into the 2nd, 3rd, and 4th Pair at the end of the turn."},
	{"id": 17, "name": "Tax Evasion", "rank": "A", "desc": "When DEBT is applied to you, halve it, return the removed DEBT to the Enemy, and deal DAMAGE equal to the returned DEBT."},
	{"id": 18, "name": "Payback", "rank": "A", "desc": "After taking Heavy Damage, generate 6 SHINED GOLD SUN COINs."},
	{"id": 19, "name": "Loan Shark", "rank": "A", "desc": "Loan Shark accompanies you. For each Enemy Coin Flip, Loan Shark bites off 2% of their DEBT as DAMAGE and converts it to GAIN."},
	{"id": 20, "name": "Spare Change", "rank": "A", "desc": "Re-Flipping retrieves all RESERVED Coins. Retrieving a STAMPED Coin restores 1 Re-Flip."},
	{"id": 21, "name": "Coin Barrage", "rank": "A", "desc": "+20% Silver Flip Rate. Every time you Flip 10 SILVER/GOLD Coins in a turn, deal 10 Damage."},

	{"id": 22, "name": "Inflation", "rank": "S", "desc": "You Cannot Manually Reserve. Each Re-Flip has a 50% Chance for each Coin to Upgrade. Upgrading Beyond Gold consumes 1 Coin and applies SHINE. SHINE is now Stackable."},
	{"id": 23, "name": "Fully Paid", "rank": "S", "desc": "I shall accompany you. Everytime you SETTLE all your DEBT, I gain a Turn and will Flip 2 GOLD SUN Coins. Max Coin Flip increases by 2 each succeeding turn."},
	{"id": 24, "name": "Bankrupt", "rank": "S", "desc": "Your Coin Bar will only flip VOIDED Coins. For each VOIDED Coin Played/Cleansed, apply 2 DEBT to Self/Enemy. Execute the enemy if their DEBT is higher than their Coins."},
	{"id": 25, "name": "All In", "rank": "S", "desc": "If the Arcane Circle is empty at End Turn, automatically Flip 20 SILVER Coins with a 50% Chance of being STAMPED. Each Statused Coin flipped this way deals 3 DAMAGE."},
	{"id": 26, "name": "Withdraw", "rank": "B", "desc": "Removing a RESERVED Coin deals 1 DAMAGE. Statused Coins deal 3 DAMAGE instead."},
	{"id": 27, "name": "Deposit", "rank": "A", "desc": "Max Reserve +3. RESERVING a Coin applies 2 GAIN with a 10% Chance to be STAMPED."},
	{"id": 28, "name": "Dividend", "rank": "A", "desc": "Each RESERVED Coin has a 30% chance to generate a copy of itself next turn."},
	{"id": 29, "name": "Cash Out", "rank": "S", "desc": "If there are 4 or more RESERVED Coins at the end of a Player or Enemy Turn, gain an EXTRA TURN. During Extra Turns, you can only Re-Flip and cannot gain additional Extra Turns."}
];

@warning_ignore("shadowed_variable")
func show_shop_async(player):
	refresh_count = 1
	purchased_ids = []
	current_cards = []
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
	if main.player.greed:
		refresh_base_value = 10
	refresh_price.text = "$" + str(refresh_base_value * refresh_count)
	
	# Clear the label when the shop opens!
	if descriptions:
		descriptions.text = ""
	
	generate_shop()
	
	while not shop_done:
		await get_tree().process_frame
		if main.is_game_over:
			return
		
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
	current_cards = []
		
	var pool = all_cards.duplicate()
	pool = pool.filter(func(card):
		return not is_card_owned(card["id"]) 
	)
	
	var b_pool = pool.filter(func(c): return c["rank"] == "B")
	var a_pool = pool.filter(func(c): return c["rank"] == "A")
	var s_pool = pool.filter(func(c): return c["rank"] == "S")
	
	
	current_cards += draw_cards(b_pool, 2)
	current_cards += draw_cards(a_pool, 4)
	current_cards += draw_cards(s_pool, 2)
		
	build_full_grid()
	
	
func create_card_node(data: Dictionary) -> Node:
	var card = Shop_card.instantiate()
	
	card.card_id = data["id"]
	card.card_name = data["name"]
	card.card_rank = data["rank"]
	card.card_desc = data.get("desc", "")
	
	var base_price = 10
	match card.card_rank:
		"S": base_price = 30
		"A": base_price = 20
		"B": base_price = 10
	
	card.price = base_price
	if main.player.greed:
		card.price = int(card.price * 1.5)
	card.stock = 1
	
	card.card_bought.connect(_on_card_bought.bind(card))
	card.card_hovered.connect(_on_card_hovered)
	card.card_unhovered.connect(_on_card_unhovered)
	card.setup(main)
	return card

func mark_purchased(card) -> void:
	card.disabled = true
	card.modulate = Color(0.5, 0.5, 0.5)

func animate_card_appear(card) -> void:
	card.scale = Vector2(0.6, 0.6)
	card.modulate.a = 0.0
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(card, "scale", Vector2(1, 1), 0.25)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(card, "modulate:a", 1.0, 0.2)

func build_full_grid() -> void:
	for child in container.get_children():
		child.queue_free()
	card_nodes = []
	
	for data in current_cards:
		var card = create_card_node(data)
		container.add_child(card)
		card_nodes.append(card)
		if purchased_ids.has(data["id"]):
			mark_purchased(card)
		
# NEW: Update the label when hovered
func _on_card_hovered(description_text: String) -> void:
	if is_instance_valid(main.player_info_menu):
		return
	main.sound_manager.play_sound(SCROLL_HOVERED)
	if descriptions:
		descriptions.text = description_text

# NEW: Clear the label when mouse leaves
func _on_card_unhovered() -> void:
	if descriptions:
		descriptions.text = ""
		
func _on_card_bought(card_id, price, card):
	if player_ref.coin >= price:
		purchase_count += 1
		if purchase_count == 8:
			main.player.trigger_temp_passive("merchant_scroll","SHOPKEEPER TRUST +1")
		player_ref.coin -= price
		purchased_ids.append(card_id)
		apply_item(card_id)
		emit_signal("item_purchased", card_id, price)
		card.disabled = true
		card.modulate = Color(0.5, 0.5, 0.5)
		
		if purchase_count >= 8:
			main.player.toggle_button(refresh_button,true)
		# NEW: Clear the description text when they buy it
		if descriptions:
			descriptions.text = ""
		
		coin_label.text = str(player_ref.coin)
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
			main.shopkeeper.trust += 1
			main.player.trigger_temp_passive("merchant_scroll","SHOPKEEPER TRUST +1")
		5:
			print("Impromptu Flip Passive")
			main.player.has_impromptu_flip = true
		6:
			print("Seal of Approval Passive")
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
			print("A-Rank: Pickpocket")
			main.player.has_sleight_of_hand = true
			main.player.max_re_flip += 2
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
			print("A-Rank: Tax Evasion")
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
		23:
			print("S-Rank: Active Income")
			main.player.has_active_income = true
			main.shopkeeper.trust += 1
			main.player.trigger_temp_passive("merchant_scroll","SHOPKEEPER TRUST +1")
		24:
			print("S-Rank: Bankrupt")
			main.player.has_pay_down = true
		25:
			print("S-Rank: Refund")
			main.player.has_refund = true
		26:
			print("B-Rank: Withdraw")
			main.player.has_withdraw = true
		27:
			print("A-Rank: Deposit")
			main.player.has_deposit = true
			main.player.max_reserve += 3
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
	if purchase_count >= 8:
		main.shopkeeper.trust += 1
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
		
	coin_label.text = str(player_ref.coin)

func _on_proceed_pressed():
	emit_signal("shop_closed")
	queue_free()

func _on_back_pressed() -> void:
	if is_instance_valid(main.player_info_menu):
		return
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


func _on_refresh_pressed() -> void:
	main.player.coin -= refresh_base_value*refresh_count
	refresh_count += 1
	if main.player.coin <= refresh_base_value*refresh_count:
		main.player.toggle_button(refresh_button,true)
	refresh_price.text = "$" + str(refresh_base_value * refresh_count)
	var shown_ids = current_cards.map(func(c): return c["id"])
	var pool = all_cards.duplicate()
	pool = pool.filter(func(card):
		return not is_card_owned(card["id"]) \
			and not purchased_ids.has(card["id"]) \
			and not shown_ids.has(card["id"])
	)
	var b_pool = pool.filter(func(c): return c["rank"] == "B")
	var a_pool = pool.filter(func(c): return c["rank"] == "A")
	var s_pool = pool.filter(func(c): return c["rank"] == "S")
	
	for i in range(current_cards.size()):
		var data = current_cards[i]
		if purchased_ids.has(data["id"]):
			continue  
		
		var replacement = null
		match data["rank"]:
			"B": replacement = draw_cards(b_pool, 1)
			"A": replacement = draw_cards(a_pool, 1)
			"S": replacement = draw_cards(s_pool, 1)
		
		if replacement and replacement.size() > 0:
			current_cards[i] = replacement[0]
			var old_node = card_nodes[i]
			var slot_index = old_node.get_index()  
			old_node.queue_free()
			
			var new_card = create_card_node(current_cards[i])
			container.add_child(new_card)
			container.move_child(new_card, slot_index)
			card_nodes[i] = new_card
			
			animate_card_appear(new_card)
			if main.player.coin <= new_card.price or new_card.stock <= 0:
				new_card.disabled = true
				new_card.modulate.a = 0.5


func _on_refresh_mouse_entered() -> void:
	if !refresh_button.disabled:
		refresh_sprite.play("default")


func _on_refresh_mouse_exited() -> void:
	refresh_sprite.pause()
