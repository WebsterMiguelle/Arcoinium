extends CanvasLayer
@onready var main = get_node("/root/Main")
@onready var passive_manager = get_node("/root/Main/PassiveManager")
@onready var card_container = $Background/CenterContainer/VBoxContainer/CardContainer
@onready var refresh_button = $Background/CenterContainer/VBoxContainer/Refresh
const CARD_SCENE = preload("res://Scene/reward_card.tscn")

var all_cards = [
	{"id": 0, "name": "B-Rank: Solar Coin", "rank": "B"},
	{"id": 1, "name": "B-Rank: Lunar Coin", "rank": "B"},
	{"id": 2, "name": "B-Rank: Wish Bone", "rank": "B"},
	{"id": 3, "name": "B-Rank: Golden Clover", "rank": "B"},
	{"id": 4, "name": "B-Rank: Merchant’s Scroll", "rank": "B"},
	{"id": 5, "name": "B-Rank: Impromptu Flip", "rank": "B"},
	{"id": 6, "name": "B-Rank: Advanced Planning", "rank": "B"},
	{"id": 7, "name": "B-Rank: Value Increase", "rank": "B"},
	{"id": 8, "name": "B-Rank: Lending Charge", "rank": "B"},
	{"id": 9, "name": "B-Rank: Coin Snipe", "rank": "B"},
	{"id": 10, "name": "B-Rank: Simple Interest", "rank": "B"},
	{"id": 11, "name": "A-Rank: Lucky Pair", "rank": "A"},
	{"id": 12, "name": "A-Rank: Sleight of Hand", "rank": "A"},
	{"id": 13, "name": "A-Rank: Piggy", "rank": "A"},
	{"id": 14, "name": "A-Rank: Pocket Money", "rank": "A"},
	{"id": 15, "name": "A-Rank: Passive Income", "rank": "A"},
	{"id": 16, "name": "A-Rank: Magic Trick", "rank": "A"},
	{"id": 17, "name": "A-Rank: Reimbursement", "rank": "A"},
	{"id": 18, "name": "A-Rank: Loan Shark", "rank": "A"},
	{"id": 19, "name": "A-Rank: Spare Change", "rank": "A"},
	{"id": 20, "name": "A-Rank: Triple Nickel", "rank": "A"},
	{"id": 21, "name": "S-Rank: Inflation", "rank": "S"},
	{"id": 22, "name": "S-Rank: Active Income", "rank": "S"},
	{"id": 23, "name": "S-Rank: Pay Down", "rank": "S"},
	{"id": 24, "name": "S-Rank: Refund", "rank": "S"}
	
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
			main.trigger_passive("solar_coin")
		1:
			print("Lunar Coin")
			main.trigger_passive("lunar_coin")
		2:
			print("Wish Bone")
			main.trigger_passive("wish_bone")
		3:
			print("Golden Clover")
			main.trigger_passive("golden_clover")
		4:
			print("Merchant Scroll Passive")
			main.trigger_passive("merchant_scroll")
		5:
			print("Impromptu Flip Passive")
			main.trigger_passive("impromptu_flip")
		6:
			print("Advanced Planning Passive")
			main.trigger_passive("advanced_planning")
		7:
			print("Value Increase Passive")
			main.trigger_passive("value_increase")
		8:
			print("Lending Charge Passive")
			main.trigger_passive("lending_charge")
		9:
			print("Coin Snipe Passive")
			main.trigger_passive("coin_snipe")
		10:
			print("Simple Interest Passive")
			main.trigger_passive("simple_interest")
		11:
			print("Lucky Pair")
			main.trigger_passive("lucky_pair")
		12:
			print("A-Rank: Sleight of Hand")
			main.trigger_passive("sleight_of_hand")
		13:
			print("A-Rank: Piggy")
			main.trigger_passive("piggy")
		14:
			print("A-Rank: Pocket Money")
			main.trigger_passive("pocket_money")
		15:
			print("A-Rank: Passive Income")
			main.trigger_passive("passive_income")
		16:
			print("A-Rank: Magic Trick")
			main.trigger_passive("magic_trick")
		17:
			print("A-Rank: Reimbursement")
			main.trigger_passive("reimbursement")
		18:
			print("B-Rank: Simple Interest")
			main.trigger_passive("simple_interest")
		19:
			print("A-Rank: Loan Shark")
			main.trigger_passive("loan_shark")
		20:
			print("A-Rank: Spare Change")
			main.trigger_passive("spare_change")
		21:
			print("A-Rank:Triple Nickel")
			main.trigger_passive("triple_nickel")
		22:
			print("S-Rank: Inflation")
			main.trigger_passive("inflation")
		23:
			print("S-Rank: Active Income")
			main.trigger_passive("active_income")
		24:
			print("S-Rank: Pay Down")
			main.trigger_passive("pay_down")
		25:
			print("S-Rank: Refund")
			main.trigger_passive("refund")
			
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
	
