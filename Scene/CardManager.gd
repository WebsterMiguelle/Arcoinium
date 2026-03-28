extends CanvasLayer
@onready var main = get_node("/root/Main")
@onready var passive_manager = get_node("/root/Main/PassiveManager")
@onready var card_container = $Background/CenterContainer/VBoxContainer/CardContainer
@onready var refresh_button = $Background/CenterContainer/VBoxContainer/Refresh
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

var shuffled_cards = []
var picked_cards = []
var max_picks = 2
var refresh_count = 1
var player_progress = 0
var previous_cards = []
signal selection_done

func show_rewards():
	visible = true
	clear_cards()
	
	var available_cards = []

	match player_progress:
		0:
			available_cards = all_cards.filter(func(c): return c["rank"] == "B")
		1:
			available_cards = all_cards.filter(func(c): return c["rank"] == "B" or c["rank"] == "A")
		2:
			available_cards = all_cards.duplicate()
			
	available_cards.shuffle()
	
	var count = 0
	for card in available_cards:
		if not previous_cards.has(card["id"]):
			create_card(card)
			count += 1
		if count >= 3:
			break
	if count < 3:
		var i = 0
		while count < 3 and i < available_cards.size():
			create_card(available_cards[i])
			count += 1
			i += 1
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
	card.card_id = data.id
	card.card_name = data.name
	card.card_rank = data.rank

	card.card_selected.connect(self._on_card_selected)

	card_container.add_child(card)

func clear_cards():
	for child in card_container.get_children():
		child.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	if not refresh_button.pressed.is_connected(_on_refresh_pressed):
		refresh_button.pressed.connect(_on_refresh_pressed)

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
			main.has_wish_bone = true
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

func set_cards_enabled(enabled: bool):
	for card in card_container.get_children():
		if card is Button:
			card.disabled = not enabled
	refresh_button.disabled = not enabled



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_refresh_pressed():
	show_rewards()
	if refresh_count <= 0:
		refresh_button.disabled = true
		return
	
	refresh_count -= 1
	show_rewards()
	
