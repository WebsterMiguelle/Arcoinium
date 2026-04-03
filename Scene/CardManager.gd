extends CanvasLayer
@onready var main = get_node("/root/Main")
@onready var passive_manager = get_node("/root/Main/PassiveManager")
@onready var sound_manager: Node2D = $"../SoundManager"

@onready var card_container = $Background/CenterContainer/VBoxContainer/CardContainer
#@onready var refresh_button = $Background/CenterContainer/VBoxContainer/Refresh
const CARD_SCENE = preload("res://Scene/reward_card.tscn")
@onready var player: Node2D = $"../Player"

@onready var card_description: Label = $Background/Card_Description


const SCROLL_OPEN = preload("uid://ciyhsb2lowwtt")
const SCROLL_HOVERED = preload("uid://dpcddmlbji61k")


var all_cards = [
	{"id": 0, "name": "Solar Coin", "rank": "B", "desc": "Guarantee that the 1st and 3rd coin flip is a Sun."},
	{"id": 1, "name": "Lunar Coin", "rank": "B", "desc": "Guarantee that the 2nd and 4th coin flip is a Moon."},
	{"id": 2, "name": "Wish Bone", "rank": "B", "desc": "Raise chances of flipping a Silver Coin by 20%."},
	{"id": 3, "name": "Golden Clover", "rank": "B", "desc": "Raise chances of flipping a Gold Coin by 10%."},
	{"id": 4, "name": "Merchant's Scroll", "rank": "B", "desc": "25% Shop Discount."},
	{"id": 5, "name": "Impromptu Flip", "rank": "B", "desc": "Upon ending the turn, the last coin on the Arcane Circle will be upgraded, and flipped to its other side."},
	{"id": 6, "name": "Advanced Planning", "rank": "B", "desc": "The first 2 coins on the Arcane Circle will not be affected by Re-Flips. Upgrade these coins at the end of the turn."},
	{"id": 7, "name": "Value Increase", "rank": "B", "desc": "Upgrade all reserved coins next turn."},
	{"id": 8, "name": "Lending Charge", "rank": "B", "desc": "Each Sun-Moon Pairs played this turn applies 3 DEBT to the enemy."},
	{"id": 9, "name": "Coin Snipe", "rank": "B", "desc": "If Coin Caster flipped a Silver or Gold Coin, Deal 1 Damage to the enemy."},
	{"id": 10, "name": "Simple Interest", "rank": "B", "desc": "For each reserved coin added to the Arcane Circle next turn, apply 1 Gain to self."},
	{"id": 11, "name": "Lucky Pair", "rank": "A", "desc": "+10% Gold Flip Rate. The 7th and 8th Flipped Coin on every turn is guaranteed to be upgraded."},
	{"id": 12, "name": "Sleight of Hand", "rank": "A", "desc": "+4 Extra Re-Flips."},
	{"id": 13, "name": "Piggy", "rank": "A", "desc": "At the end of each turn, Piggy will duplicate your Last Coin Pair and add it to the Reserve."},
	{"id": 14, "name": "Pocket Money", "rank": "A", "desc": "Start each battle with 8 Silver Moon Coins."},
	{"id": 15, "name": "Passive Income", "rank": "A", "desc": "In every battle, the first enemy damage will be turned into Coins. (Caps at 30 Coin Gain)"},
	{"id": 16, "name": "Magic Trick", "rank": "A", "desc": "Upon ending the turn with 8 or more Coins, the 1st Coin Pair will be copied to the 2nd, 3rd, and 4th Coin Pair."},
	{"id": 17, "name": "Reimbursement", "rank": "A", "desc": "Each Flip and Re-Flip has a 30% Chance to apply 1 DEBT."},
	{"id": 18, "name": "Payback", "rank": "A", "desc": " If Coin Caster receives a killing blow, set Coin back to 1, Apply 16 THRIFT to the Enemy, and immediately generate 8 Silver Sun Coins next turn. (One-Time per Battle)"},
	{"id": 19, "name": "Loan Shark", "rank": "A", "desc": "At the start of the enemy’s turn, immediately deal damage based on half of the Enemy’s DEBT."},
	{"id": 20, "name": "Spare Change", "rank": "A", "desc": "Upon a Re-Flip, retrieve all reserved coins on the deck."},
	{"id": 21, "name": "Triple Nickel", "rank": "A", "desc": "+20% Silver Flip Rate. The first 3 Flips on every turn are guaranteed to be Silver Coins."},
	{"id": 22, "name": "Inflation", "rank": "S", "desc": "There is a 50% chance for each coin on the Arcane Circle to upgrade every Re-Flip. For every Gold Coin played, apply 1 SPEND to Enemy."},
	{"id": 23, "name": "Jar'O Savings", "rank": "S", "desc":"When Coin Caster deals 0 Damage this turn, gain an Extra Turn, apply 16 THRIFT to the enemy, and generate 16 Silver Moon Coins. Cannot Flip or Re-Flip during Extra Turns."},
	{"id": 24, "name": "Pay Down", "rank": "S", "desc": "Add 5 DEBT at the end of the Enemy’s Turn. If Enemy DEBT is greater than their Current Coins at the end of their turn, perish instantly."},
	{"id": 25, "name": "Refund", "rank": "S", "desc": "+1 Extra Re-Flip. There is a 20% chance to retrieve all coins from the Arcane Circle upon a Re-Flip. Refresh Re-Flip Count afterwards."},
	{"id": 26, "name": "Withdraw", "rank": "B", "desc": "For each reserved coin added to the Arcane Circle next turn, deal 1 Damage."},
	{"id": 27, "name": "Deposit", "rank": "A", "desc": "+4 Max Reserve."},
	{"id": 28, "name": "Dividend", "rank": "A", "desc": "There is a 30% chance to duplicate each reserved coin on the next turn."},
	{"id": 29, "name": "Cash Out", "rank": "S", "desc": "When Coin Reserve is full at the end of the turn, immediately gain an Extra Turn. Coin Caster cannot Flip or Re-Flip during Extra Turns."}
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
	main.sound_manager.play_sound(SCROLL_OPEN)
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
			b_count = 5
		1:
			b_count = 4
			a_count = 1
		2:
			b_count = 2
			a_count = 3
		3:
			b_count = 1
			a_count = 3
			s_count = 1
		_:
			b_count = 2
			a_count = 2

	var selected_cards = []
	
	selected_cards += draw_cards(b_pool, b_count)
	selected_cards += draw_cards(a_pool, a_count)
	selected_cards += draw_cards(s_pool, s_count)
	
	var remaining = 5 - selected_cards.size()
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
	card.card_desc = data["desc"]

	card.card_selected.connect(self._on_card_selected)
	
	card.card_hovered.connect(self._on_card_hovered)
	card.card_unhovered.connect(self._on_card_unhovered)
	card.setup(main)
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

func _on_card_hovered(description_text: String) -> void:
	# Add [center] tags if you want the text to always be centered!
	main.sound_manager.play_sound(SCROLL_HOVERED)
	card_description.text = description_text

func _on_card_unhovered() -> void:
	# Clear the text box when the mouse leaves the card
	card_description.text = ""
