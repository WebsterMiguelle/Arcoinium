extends ColorRect

@onready var Card_Container = $"ScrollContainer/GridContainer"
@onready var Card_View = $"CardView"

@onready var view_name: Label = $"CardView/CardName"
@onready var view_desc: Label = $"CardView/Description"
@onready var view_icon = $"CardView/Icon"
@onready var view_spell_icon: AnimatedSprite2D = $CardView/SpellIcon
@onready var view_rank: AnimatedSprite2D = $"CardView/Sprite"
var c = null

const Effect_CARD = preload("res://Scene/Archives_card.tscn")
const COIN = preload("res://Scene/coin.tscn")
var card_nodes: Array = []
var current_filter: String = ""

const ENTITY_ICON_NODES = {
	"Tally": "Tally Effect",
	
}
var all_cards = [
	{"id": 0, "name": "Shine","rank": "unfurl_down","type": "Coin" ,"desc": "Coin Status.\n\nSHINED Sun: +3 DMG\nSHINED Moon: +3 GAIN"},
	{"id": 1, "name": "Dazzle","rank": "unfurl_down","type": "Coin" ,"desc": "Coin Status.\n\nThis coin will flip to its other side at the end of the turn."},
	{"id": 2, "name": "Void","rank": "unfurl_down","type": "Coin" ,"desc": "Coin Status.\n\n0 Base Value. Can be cleansed via Re-Flips or Upgrades."},
	{"id": 3, "name": "Stamp","rank": "unfurl_down","type": "Coin" ,"desc": "Coin Status.\n\nThis Coin cannot be re-flipped."},
	{"id": 4, "name": "Damage","rank": "unfurl_down","type": "Entity" ,"desc": "Damaging Spell.\n\nReduce enemy Coins."},
	{"id": 5, "name": "Debt","rank": "unfurl_down","type": "Entity" ,"desc": "Debuff Spell.\n\nReduce enemy's incoming GAIN next turn."},
	{"id": 6, "name": "Gain","rank": "unfurl_down","type": "Entity" ,"desc": "Healing Spell.\n\nGain X Coins next turn."},
	{"id": 7, "name": "Thrift","rank": "unfurl_down","type": "Entity" ,"desc": "Control Spell.\n\nBlock X Slots on the Arcane Circle next turn."},
	{"id": 8, "name": "Spend","rank": "unfurl_down","type": "Entity" ,"desc": "Debuff Spell.\n\nEach Flip costs 2 Coins instead."},
	{"id": 9, "name": "Tally","rank": "unfurl_down","type": "Entity" ,"desc": "Control Spell.\n\nReduces by 1 for each Flip/Reserve. Immediately ends the turn when it reaches 0."},
	{"id": 10, "name": "Drowse","rank": "unfurl_down","type": "Entity" ,"desc": "Control Spell.\n\nRe-Flip for each coin only works 50% at a time."},
	{"id": 11, "name": "Starstruck","rank": "unfurl_down","type": "Entity" ,"desc": "Debuff Spell.\n\nEnemy Coin Flip has a 50% Chance to be DAZZLED."},
	{"id": 11, "name": "Voided","rank": "unfurl_down","type": "Entity" ,"desc": "Control Spell.\n\nLock the enemy's Reserve. All Coins within becomes VOID."},
	{"id": 12, "name": "Radiant","rank": "unfurl_down","type": "Entity" ,"desc": "Buff Spell.\n\nEach played Coin has a 50% Chance to be SHINED during End Turn."}
	
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Card_View.visible = false
	_populate_cards()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _populate_cards() -> void:
	for data in all_cards:
		var card = Effect_CARD.instantiate()
		card.mouse_default_cursor_shape = 2
		card.is_spell = true
		card.card_id   = data["id"]
		card.card_name = data["name"]
		card.card_rank = data["rank"]
		card.card_desc = data["desc"]
		card.use_coin_icon = data["type"] == "Coin"
		card.custom_minimum_size = Vector2(150, 250)
		card.setup(get_node("/root/Main"))
		card.pressed.connect(_on_effect_card_pressed.bind(data))
		card_nodes.append({"node": card, "data": data})
		Card_Container.add_child(card)

func _on_effect_card_pressed(data: Dictionary) -> void:
	Card_View.visible = true
	if view_name: view_name.text = data["name"]
	if view_desc: view_desc.text = data["desc"]
	if data["type"] == "Coin":
		show_coin_icon(data)
		view_spell_icon.play("NONE")
	elif data["type"] == "Entity":
		show_entity_icon(data)
		view_spell_icon.play(data["name"])
	if view_rank: view_rank.play(data["rank"])

func _on_back_pressed() -> void:
	SceneTransition.load_scene("res://Scene/archive.tscn")


func _on_entity_pressed() -> void:
	_filter_by_type("Entity")


func _on_coin_status_pressed() -> void:
	_filter_by_type("Coin")
	
	
func _filter_by_type(type: String) -> void:
	if current_filter == type:
		current_filter = ""
	else:
		current_filter = type

	for entry in card_nodes:
		var node: Control = entry["node"]
		var data: Dictionary = entry["data"]
		if current_filter == "" or data["type"] == current_filter:
			node.visible = true
		else:
			node.visible = false
			
func show_coin_icon(data):
	for child in view_icon.get_children():
		child.queue_free()
	c = COIN.instantiate()
	view_icon.add_child(c)
	c.state = 0 # Head
	c.type = c.CoinType.COPPER
	
	match data["name"]:
		"Shine":
			c.add_status(c.CoinStatus.SHINED)
			c.is_archive = true
		"Dazzle":
			c.add_status(c.CoinStatus.DAZZLED)
			c.is_archive = true
		"Void":
			c.add_status(c.CoinStatus.VOIDED)
		"Stamp":
			c.is_stamped = true
	c.is_archive = true
	c.scale = Vector2(2.0,2.0)
	c.position = Vector2(15, 35)
	c.refresh_sprite()

func show_entity_icon(data: Dictionary) -> void:
	if is_instance_valid(c):
		c.queue_free()
	pass
	
