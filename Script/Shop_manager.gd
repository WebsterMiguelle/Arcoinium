extends CanvasLayer

@onready var container = $Background/CenterContainer/VBoxContainer/CardContainer
const Shop_card = preload("res://Scene/shop_card.tscn")
@onready var bg = $Background
@onready var back_button = $Background/Back
@onready var main = get_node("/root/Main")
@onready var coin_label = $Background/CoinLabel
@onready var player: Node2D = $"../Player"

var player_ref
var shop_done := false

signal item_purchased(card_id, price)
signal shop_closed


var all_cards = [
	{"id": 0, "name": "Solar Coin", "rank": "B"},
	{"id": 1, "name": "Lunar Coin", "rank": "B"},
	{"id": 2, "name": "Wish Bone", "rank": "B"},
	{"id": 3, "name": "Golden Clover", "rank": "B"},
	{"id": 4, "name": "Merchant’s Scroll", "rank": "B"},
	{"id": 5, "name": "Impromptu Flip", "rank": "B"},
	{"id": 6, "name": "Advanced Planning", "rank": "B"},
	{"id": 7, "name": "Value Increase", "rank": "B"},
	{"id": 8, "name": "Lending Charge", "rank": "B"},
	{"id": 9, "name": "Coin Snipe", "rank": "B"},
	{"id": 10, "name": "Simple Interest", "rank": "B"},
	{"id": 11, "name": "Lucky Pair", "rank": "A"},
	{"id": 12, "name": "Sleight of Hand", "rank": "A"},
	{"id": 13, "name": "Piggy", "rank": "A"},
	{"id": 14, "name": "Pocket Money", "rank": "A"},
	{"id": 15, "name": "Passive Income", "rank": "A"},
	{"id": 16, "name": "Magic Trick", "rank": "A"},
	{"id": 17, "name": "Reimbursement", "rank": "A"},
	{"id": 18, "name": "Payback", "rank": "A"},
	{"id": 19, "name": "Loan Shark", "rank": "A"},
	{"id": 20, "name": "Spare Change", "rank": "A"},
	{"id": 21, "name": "Triple Nickel", "rank": "A"},
	{"id": 22, "name": "Inflation", "rank": "S"},
	{"id": 23, "name": "Jar'O Savings", "rank": "S"},
	{"id": 24, "name": "Pay Down", "rank": "S"},
	{"id": 25, "name": "Refund", "rank": "S"}
	
]


func show_shop_async(player):
	shop_done = false
	player_ref = player
	#get_parent().reward_manager.set_cards_enabled(false)
	
	show()
	
	
	bg.visible = true
	visible = true
	back_button.disabled = false 
	
	generate_shop()
	
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 0.5, 0.5)
	
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
	selected_cards += draw_cards(b_pool, 3)
	selected_cards += draw_cards(a_pool, 2)
	selected_cards += draw_cards(s_pool, 1)

	for data in selected_cards:
		var card = Shop_card.instantiate()
	
		card.card_id = data["id"]
		card.card_name = data["name"]
		card.card_rank = data["rank"]
		match card.card_rank:
			"S":
				card.price = 30
			"A":
				card.price = 20
			"B":
				card.price = 10
		card.stock = 1
		
		card.card_bought.connect(_on_card_bought.bind(card))
		container.add_child(card)
		
		
func _on_card_bought(card_id, price, card):
	if player_ref.coin >= price:
		player_ref.coin -= price
		apply_item(card_id)
		emit_signal("item_purchased", card_id, price)
		card.disabled = true
		card.modulate = Color(0.5, 0.5, 0.5)
		
		coin_label.text = "Coins: " + str(player_ref.coin)
		for c in container.get_children():
			c.update_state(player_ref.coin)
		
	else:
		print("Not enough coins!")
		
		
		
func apply_item(card_id):
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
			main.player.silver_flip_rate += 0.1
		3:
			print("Golden Clover")
			main.player.has_golden_clover = true
			main.player.gold_flip_rate += 0.05
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
		12:
			print("A-Rank: Sleight of Hand")
			main.player.has_sleight_of_hand = true
			main.player.max_reflip += 6
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
		22:
			print("S-Rank: Inflation")
			main.player.has_inflation = true
		23:
			print("S-Rank: Active Income")
			main.player.has_active_income = true
		24:
			print("S-Rank: Pay Down")
			main.player.has_pay_down = true
		25:
			print("S-Rank: Refund")
			main.player.has_refund = true
		_:
			print("Other reward")


func close_shop():
	bg.visible = false
	visible = false
	#get_parent().reward_manager.set_cards_enabled(true)
	shop_done = true
	emit_signal("shop_closed")
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not visible or player_ref == null:
		return
		
	#for card in container.get_children():
		#card.update_state(player_ref.coin)
		
	coin_label.text = "Coins: " + str(player_ref.coin)

func _on_proceed_pressed():
	emit_signal("shop_closed")
	queue_free()
	


func _on_back_pressed() -> void:
	close_shop()
	
func create_card(data):
	var card = Shop_card.instantiate()
	card.card_id = data["id"]
	card.card_name = data["name"]
	card.card_rank = data["rank"]

	card.card_selected.connect(self._on_card_bought)

	container.add_child(card)
	
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
		_:
			return false
