extends ColorRect

@onready var Card_Container = $"ScrollContainer/GridContainer"
@onready var Card_View = $"CardView"

@onready var view_name: Label = $"CardView/CardName"
@onready var view_desc: Label = $"CardView/Description"
@onready var view_icon = $"CardView/Icon"
@onready var view_rank: AnimatedSprite2D = $"CardView/Sprite"

const Effect_CARD = preload("res://Scene/Archives_card.tscn")
const COIN = preload("res://Scene/coin.tscn")
var card_nodes: Array = []
var current_filter: String = ""

var all_cards = [
	{"id": 0, "name": "Shine","rank": "unfurl_down","type": "Coin" ,"desc": "Description"},
	{"id": 1, "name": "Dazzle","rank": "unfurl_down","type": "Coin" ,"desc": "Description"},
	{"id": 2, "name": "Void","rank": "unfurl_down","type": "Coin" ,"desc": "Description"},
	{"id": 3, "name": "Stamp","rank": "unfurl_down","type": "Coin" ,"desc": "Description"},
	{"id": 5, "name": "Debt","rank": "unfurl_down","type": "Entity" ,"desc": "Description"},
	{"id": 6, "name": "Gain","rank": "unfurl_down","type": "Entity" ,"desc": "Description"},
	{"id": 7, "name": "Thrift","rank": "unfurl_down","type": "Entity" ,"desc": "Description"},
	{"id": 8, "name": "Spend","rank": "unfurl_down","type": "Entity" ,"desc": "Description"},
	{"id": 9, "name": "Tally","rank": "unfurl_down","type": "Entity" ,"desc": "Description"},
	{"id": 10, "name": "Drowse","rank": "unfurl_down","type": "Entity" ,"desc": "Description"},
	{"id": 11, "name": "Starstruck","rank": "unfurl_down","type": "Entity" ,"desc": "Description"},
	{"id": 11, "name": "Voided","rank": "unfurl_down","type": "Entity" ,"desc": "Description"}
	
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
	if data["type"] == "Coin": show_coin_icon(data)
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
	var c = COIN.instantiate()
	view_icon.add_child(c)
	c.state = 0 # Head
	c.type = c.CoinType.COPPER
	
	match data["name"]:
		"Shine":
			c.add_status(c.CoinStatus.SHINED)
		"Dazzle":
			c.add_status(c.CoinStatus.DAZZLED)
		"Void":
			c.add_status(c.CoinStatus.VOIDED)
		"Stamp":
			c.is_stamped = true
	c.scale = Vector2(2.0,2.0)
	c.position = Vector2(15, 35)
	c.refresh_sprite()

		
