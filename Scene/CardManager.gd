#CardManager
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
	{"id": 0, "name": "Solar Blessing", "rank": "B", "desc": "When 8 or more SUN Coins are played this turn, all Odd Flips next turn are guaranteed SUN."},
	{"id": 1, "name": "Lunar Blessing", "rank": "B", "desc": "When 8 or more MOON Coins are played this turn, all Even Flips next turn are guaranteed MOON."},
	{"id": 2, "name": "Wish Bone", "rank": "B", "desc": "+20% SILVER Flip Rate."},
	{"id": 3, "name": "Golden Clover", "rank": "B", "desc": "+10% GOLD Flip Rate."},
	{"id": 4, "name": "Keeper's Scroll", "rank": "B", "desc": "The Shopkeeper accompanies you. When you receive Damage, she gains a Turn and flips 1 STAMPED COPPER MOON-SUN Pair. Max Coin Flip increases by 2 each succeeding turn."},
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
	{"id": 18, "name": "Payback", "rank": "A", "desc": "After taking Heavy Damage, generate 8 SHINED COPPER SUN COINs."},
	{"id": 19, "name": "Loan Shark", "rank": "A", "desc": "Loan Shark accompanies you. For each Enemy Coin Flip, Loan Shark detonates 2% of their DEBT as DAMAGE. Each Enemy Coin Flip has a chance equal to their current DEBT (up to 100%) to become DAZZLED."},
	{"id": 20, "name": "Spare Change", "rank": "A", "desc": "Re-Flipping retrieves all RESERVED Coins. Retrieving a STAMPED Coin restores 1 Re-Flip."},
	{"id": 21, "name": "Coin Barrage", "rank": "A", "desc": "+20% Silver Flip Rate. Every time you Flip 10 SILVER/GOLD Coins in a turn, deal 10 Damage."},

	{"id": 22, "name": "Inflation", "rank": "S", "desc": "You Cannot Manually Reserve. Each Re-Flip has a 50% Chance for each Coin to Upgrade. Upgrading Beyond Gold consumes 1 Coin and applies SHINE. SHINE is now Stackable."},
	{"id": 23, "name": "Fully Paid", "rank": "S", "desc": "The Shopkeeper accompanies you. Everytime you SETTLE all your DEBT, Shopkeeper gains a Turn and Flips 2 GOLD SUN Coins. Max Coin Flip increases by 2 each succeeding turn."},
	{"id": 24, "name": "Bankrupt", "rank": "S", "desc": "Your Coin Bar will only flip VOIDED Coins. For each VOIDED Coin Played/Cleansed, apply 2 DEBT to Self/Enemy. Execute the enemy if their DEBT is higher than their Coins."},
	{"id": 25, "name": "All In", "rank": "S", "desc": "If the Arcane Circle is empty at End Turn, automatically Flip 20 SILVER Coins with a 50% Chance of being STAMPED. Each Statused Coin flipped this way deals 3 DAMAGE."},
	{"id": 26, "name": "Withdraw", "rank": "B", "desc": "Removing a RESERVED Coin deals 1 DAMAGE. Statused Coins deal 3 DAMAGE instead."},
	{"id": 27, "name": "Deposit", "rank": "A", "desc": "Max Reserve +2. RESERVING a Coin applies 2 GAIN with a 20% Chance to be STAMPED."},
	{"id": 28, "name": "Dividend", "rank": "A", "desc": "Each RESERVED Coin has a 30% chance to generate a copy of itself next turn."},
	{"id": 29, "name": "Cash Out", "rank": "S", "desc": "If there are 4 or more RESERVED Coins at the end of a Player or Enemy Turn, gain an EXTRA TURN. During Extra Turns, you can only Re-Flip and cannot gain additional Extra Turns."}
];


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
			b_count = 4
		1:
			b_count = 3
			a_count = 1
		2:
			b_count = 2
			a_count = 2
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
	
	for child in card_container.get_children():
		if child.card_id == card_id:
			child.disabled = true
			child.modulate.a = 0.5
			break
	
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
			main.shopkeeper.trust += 1
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
			main.player.max_reserve += 2
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
	if is_instance_valid(main.player_info_menu):
		return
	# Add [center] tags if you want the text to always be centered!
	main.sound_manager.play_sound(SCROLL_HOVERED)
	card_description.text = description_text

func _on_card_unhovered() -> void:
	# Clear the text box when the mouse leaves the card
	card_description.text = ""
