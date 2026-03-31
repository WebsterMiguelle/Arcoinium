extends CanvasLayer
@onready var main = get_node("/root/Main")
@onready var passive_manager = get_node("/root/Main/PassiveManager")
@onready var card_container = $Background/CenterContainer/VBoxContainer/CardContainer
#@onready var refresh_button = $Background/CenterContainer/VBoxContainer/Refresh
const CARD_SCENE = preload("res://Scene/reward_card.tscn")
@onready var player: Node2D = $"../Player"



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


var picked_cards = []
var max_picks = 2
var previous_cards = []
signal selection_done

func draw_cards(from_pool: Array, amount: int) -> Array:
		var result = []
		for i in range(amount):
			if from_pool.is_empty():
				break
			var pick = from_pool.pick_random()
			result.append(pick)
			from_pool.erase(pick)
		return result
		
func show_rewards():
	visible = true
	clear_cards()
	
	var pool = all_cards.filter(func(card):
		return not is_card_owned(card["id"])
	)
	var b_pool = pool.filter(func(c): return c["rank"] == "B")
	var a_pool = pool.filter(func(c): return c["rank"] == "A")
	var s_pool = pool.filter(func(c): return c["rank"] == "S")
	
	var b_count = 0
	var a_count = 0
	var s_count = 0

	match main.current_room:
		0:
			b_count = 4
		1:
			b_count = 3
			a_count = 1
		2:
			b_count = 1
			a_count = 3
		3:
			a_count = 3
			s_count = 1
		_:
			b_count = 2
			a_count = 2

	var selected_cards = []
	
	selected_cards += draw_cards(b_pool, b_count)
	selected_cards += draw_cards(a_pool, a_count)
	selected_cards += draw_cards(s_pool, s_count)
	
	var remaining = 4 - selected_cards.size()
	if remaining > 0:
		var fallback_pool = pool.duplicate()
		for card in selected_cards:
			fallback_pool.erase(card)
		selected_cards += draw_cards(fallback_pool, remaining)
		
	selected_cards.shuffle()
	for data in selected_cards:
		create_card(data)
	
	previous_cards.clear()
	for c in card_container.get_children():
		previous_cards.append(c.card_id)
	
func show_card_selection_async():
	picked_cards.clear()
	show_rewards()
	visible = true
	
	await self.selection_done
	visible = false
	
func create_card(data):
	var card = CARD_SCENE.instantiate()
	card.card_id = data["id"]
	card.card_name = data["name"]
	card.card_rank = data["rank"]

	card.card_selected.connect(self._on_card_selected)
	card_container.add_child(card)

func clear_cards():
	for child in card_container.get_children():
		child.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _on_card_selected(card_id):
	if picked_cards.has(card_id):
		return
	
	picked_cards.append(card_id)
	print("Card selected signal received:", card_id)
	print("Player selected card:", card_id)
	apply_reward(card_id)
	
	if picked_cards.size() >= max_picks:
		visible = false
		emit_signal("selection_done")
		picked_cards.clear()
	
	
func apply_reward(card_id):
	match card_id:
		0:
			print("Solar Coin Passive")
			main.has_solar_coin = true
		1:
			print("Lunar Coin")
			main.has_lunar_coin = true
		2:
			print("Wish Bone")
			main.has_wishbone = true
			player.silver_flip_rate += 0.1
		3:
			print("Golden Clover")
			main.has_golden_clover = true
			player.gold_flip_rate += 0.05
		4:
			print("Merchant Scroll Passive")
			main.has_merchant_scroll = true
		5:
			print("Impromptu Flip Passive")
			main.has_impromptu_flip = true
		6:
			print("Advanced Planning Passive")
			main.has_advanced_planning = true
		7:
			print("Value Increase Passive")
			main.has_value_increase = true
		8:
			print("Lending Charge Passive")
			main.has_lending_charge = true
		9:
			print("Coin Snipe Passive")
			main.has_coin_snipe = true
		10:
			print("Simple Interest Passive")
			main.has_simple_interest = true
		11:
			print("Lucky Pair")
			main.has_lucky_pair = true
		12:
			print("A-Rank: Sleight of Hand")
			main.has_sleight_of_hand = true
			player.max_flip += 3
			player.max_reserve += 2
		13:
			print("A-Rank: Piggy")
			main.has_piggy = true
		14:
			print("A-Rank: Pocket Money")
			main.has_pocket_money = true
		15:
			print("A-Rank: Passive Income")
			main.has_passive_income = true
		16:
			print("A-Rank: Magic Trick")
			main.has_magic_trick = true
		17:
			print("A-Rank: Reimbursement")
			main.has_reimbursement = true
		18:
			print("A-Rank: Payback")
			main.has_payback = true
		19:
			print("A-Rank: Loan Shark")
			main.has_loan_shark = true
		20:
			print("A-Rank: Spare Change")
			main.has_spare_change = true
		21:
			print("A-Rank:Triple Nickel")
			main.has_triple_nickel = true
		22:
			print("S-Rank: Inflation")
			main.has_inflation = true
		23:
			print("S-Rank: Active Income")
			main.has_active_income = true
		24:
			print("S-Rank: Pay Down")
			main.has_pay_down = true
		25:
			print("S-Rank: Refund")
			main.has_refund = true
			
		_:
			print("Other reward")

	
func is_card_owned(card_id: int) -> bool:
	match card_id:
		0: 
			return main.has_solar_coin
		1: 
			return main.has_lunar_coin
		2: 
			return main.has_wishbone
		3: 
			return main.has_golden_clover
		4: 
			return main.has_merchant_scroll
		5: 
			return main.has_impromptu_flip
		6: 
			return main.has_advanced_planning
		7: 
			return main.has_value_increase
		8: 
			return main.has_lending_charge
		9: 
			return main.has_coin_snipe
		10: 
			return main.has_simple_interest
		11: 
			return main.has_lucky_pair
		12: 
			return main.has_sleight_of_hand
		13: 
			return main.has_piggy
		14: 
			return main.has_pocket_money
		15: 
			return main.has_passive_income
		16: 
			return main.has_magic_trick
		17: 
			return main.has_reimbursement
		18: 
			return main.has_payback
		19: 
			return main.has_loan_shark
		20: 
			return main.has_spare_change
		21: 
			return main.has_triple_nickel
		22: 
			return main.has_inflation
		23: 
			return main.has_active_income
		24: 
			return main.has_pay_down
		25: 
			return main.has_refund
		_:
			return false
