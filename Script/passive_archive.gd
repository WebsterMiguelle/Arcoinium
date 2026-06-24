extends ColorRect
@onready var Card_Container = $"ScrollContainer/GridContainer"
@onready var Card_View = $"CardView"

@onready var view_name: Label = $"CardView/CardName"
@onready var view_desc: Label = $"CardView/Description"
@onready var view_icon: AnimatedSprite2D = $"CardView/Icon"
@onready var view_rank: AnimatedSprite2D = $"CardView/Sprite"

const ARCHIVE_CARD = preload("res://Scene/Archives_card.tscn")
var card_nodes: Array = []
var current_filter: String = ""
var all_cards = [
	{"id": 0, "name": "Solar Blessing", "rank": "B", "desc": "When 8 or more SUN Coins are played this turn, all Odd Flips next turn are guaranteed SUN."},
	{"id": 1, "name": "Lunar Blessing", "rank": "B", "desc": "When 8 or more MOON Coins are played this turn, all Even Flips next turn are guaranteed MOON."},
	{"id": 2, "name": "Wish Bone", "rank": "B", "desc": "+20% SILVER Flip Rate."},
	{"id": 3, "name": "Golden Clover", "rank": "B", "desc": "+10% GOLD Flip Rate."},
	{"id": 4, "name": "Merchant's Scroll", "rank": "B", "desc": "25% Shop Discount. The Shopkeeper will stock 1 extra S-Rank Passive."},
	{"id": 5, "name": "Flip Sequence", "rank": "B", "desc": "Flip the Last Coin played to its other side. For each Flip/Upgrade that occurred during End Turn Sequence, Deal 1 DAMAGE."},
	{"id": 6, "name": "Seal of Approval", "rank": "B", "desc": "The first 2 Coins placed on the Arcane Circle become STAMPED. At the end of the turn, Remove all STAMP from Played Coins and Upgrade them."},
	{"id": 7, "name": "Value Increase", "rank": "B", "desc": "Upgrade all RESERVED Coins next turn."},
	{"id": 8, "name": "Lending Charge", "rank": "B", "desc": "SUN-MOON Pairs apply 3 DEBT. If all played Pairs are SUN-MOON, apply double DEBT."},
	{"id": 9, "name": "Coin Snipe", "rank": "B", "desc": "Flipping a SILVER or GOLD Coin deals 1 DAMAGE. Generated Coins deal 3 DAMAGE instead."},
	{"id": 10, "name": "Simple Interest", "rank": "B", "desc": "RESERVING a Coin applies 1 GAIN to yourself."},
	{"id": 11, "name": "Lucky Pair", "rank": "A", "desc": "+10% GOLD Flip Rate. The 9th and 10th Coin on the Arcane Circle are SHINED at the end of the turn."},
	{"id": 12, "name": "Pickpocket", "rank": "A", "desc": "+2 Re-Flips. Re-Flipping deals 1 DAMAGE and generates a RESERVED Coin with a Random Status Effect."},
	{"id": 13, "name": "Piggy", "rank": "A", "desc": "End Turn: Generate and RESERVE a SHINED copy of your last Coin Pair."},
	{"id": 14, "name": "Pocket Money", "rank": "A", "desc": "Generate 8 STAMPED SILVER MOON Coins at the start of each battle. Half of these Coins will be RESERVED."},
	{"id": 15, "name": "Passive Income", "rank": "A", "desc": "Generate RESERVED DAZZLED Coins equal to 10% of Enemy Damage taken."},
	{"id": 16, "name": "Magic Trick", "rank": "A", "desc": "If you played 8+ Coins, the 1st Coin Pair generates copies of itself into the 2nd, 3rd, and 4th Pair at the end of the turn."},
	{"id": 17, "name": "Tax Evasion", "rank": "A", "desc": "When DEBT is applied to you, halve it, return the removed DEBT to the Enemy, and deal DAMAGE equal to the returned DEBT."},
	{"id": 18, "name": "Payback", "rank": "A", "desc": "Fatal Damage leaves you at 1 Coin, cleanses all Debuffs, and generates 12 SHINED GOLD SUN Coins next turn. (Once per Battle)"},
	{"id": 19, "name": "Loan Shark", "rank": "A", "desc": "For each Enemy Coin Flip, detonate 5% of their DEBT as DAMAGE. Each Enemy Coin Flip has a chance equal to their current DEBT (up to 100%) to become DAZZLED."},
	{"id": 20, "name": "Spare Change", "rank": "A", "desc": "Re-Flipping retrieves all RESERVED Coins. Retrieving a STAMPED Coin restores 1 Re-Flip."},
	{"id": 21, "name": "Triple Nickel", "rank": "A", "desc": "+20% SILVER Flip Rate. Your first 3 Flips each turn are guaranteed SHINED SILVER Coins."},
	{"id": 22, "name": "Inflation", "rank": "S", "desc": "You Cannot Manually Reserve. Each Re-Flip has a 50% Chance for each Coin to Upgrade. Upgrading Beyond Gold consumes 1 Coin and applies SHINE. SHINE is now Stackable."},
	{"id": 23, "name": "Fully Paid", "rank": "S", "desc": "Everytime you SETTLE all your DEBT, Deal 15 DAMAGE and apply 4 THRIFT. For each successful SETTLE, DAMAGE further increases by 15."},
	{"id": 24, "name": "Bankrupt", "rank": "S", "desc": "Your Coin Bar will only flip VOIDED Coins. For each VOIDED Coin Played/Cleansed, apply 2 DEBT to Self/Enemy. Execute the enemy if their DEBT is higher than their Coins."},
	{"id": 25, "name": "All In", "rank": "S", "desc": "If the Arcane Circle is empty at End Turn, automatically Flip 20 SILVER Coins with a 50% Chance of being STAMPED. Each Statused Coin flipped this way deals 3 DAMAGE."},
	{"id": 26, "name": "Withdraw", "rank": "B", "desc": "Removing a RESERVED Coin deals 1 DAMAGE. Statused Coins deal 3 DAMAGE instead."},
	{"id": 27, "name": "Deposit", "rank": "A", "desc": "+4 Max Reserve. Overflowing Reserve applies 3 GAIN per Coin."},
	{"id": 28, "name": "Dividend", "rank": "A", "desc": "Each RESERVED Coin has a 30% chance to generate a copy of itself next turn."},
	{"id": 29, "name": "Cash Out", "rank": "S", "desc": "If there are 4 or more RESERVED Coins at the end of a Player or Enemy Turn, gain an EXTRA TURN. During Extra Turns, you can only Re-Flip and cannot gain additional Extra Turns."}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Card_View.visible = false
	_populate_cards()

func _populate_cards() -> void:
	for data in all_cards:
		var card = ARCHIVE_CARD.instantiate()
		card.card_id   = data["id"]
		card.card_name = data["name"]
		card.card_rank = data["rank"]
		card.card_desc = data["desc"]
		card.custom_minimum_size = Vector2(150, 250)
		card.setup(get_node("/root/Main"))
		card_nodes.append({"node": card, "data": data})
		card.pressed.connect(_on_archive_card_pressed.bind(data))
		Card_Container.add_child(card)
		
func _on_archive_card_pressed(data: Dictionary) -> void:
	Card_View.visible = true
	if view_name: view_name.text = data["name"]
	if view_desc: view_desc.text = data["desc"]
	if view_icon: view_icon.play(data["name"])
	if view_rank: view_rank.play(data["rank"])
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	SceneTransition.load_scene("res://Scene/archive.tscn")


func _on_brank_pressed() -> void:
	_filter_by_rank("B")


func _on_arank_pressed() -> void:
	_filter_by_rank("A")


func _on_srank_pressed() -> void:
	print("S rank button pressed")
	_filter_by_rank("S")
	
func _filter_by_rank(rank: String) -> void:
	
	if current_filter == rank:
		current_filter = ""
	else:
		current_filter = rank

	for entry in card_nodes:
		var node: Control = entry["node"]
		var data: Dictionary = entry["data"]
		if current_filter == "" or data["rank"] == current_filter:
			node.visible = true
		else:
			node.visible = false
