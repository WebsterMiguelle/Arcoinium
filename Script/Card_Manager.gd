extends CanvasLayer

@onready var card_container = $Background/CenterContainer/CardContainer

const CARD_SCENE = preload("res://Scene/reward_card.tscn")

var all_cards = [
	{"id": 0, "name": "Card 1"},
	{"id": 1, "name": "Card 2"},
	{"id": 2, "name": "Card 3"},
	{"id": 3, "name": "Card 4"},
	{"id": 4, "name": "Card 5"},
	{"id": 5, "name": "Card 6"},
	{"id": 6, "name": "Card 7"},
	{"id": 7, "name": "Card 8"},
	{"id": 8, "name": "Card 9"},
	{"id": 9, "name": "Card 10"},
	{"id": 10, "name": "Card 11"},
	{"id": 11, "name": "Card 12"},
	{"id": 12, "name": "Card 13"},
	{"id": 13, "name": "Card 14"},
	{"id": 14, "name": "Card 15"},
	{"id": 15, "name": "Card 16"},
	{"id": 16, "name": "Card 17"},
	{"id": 16, "name": "Card 18"},
	{"id": 16, "name": "Card 19"},
	{"id": 16, "name": "Card 20"},
	{"id": 16, "name": "Card 21"},
	{"id": 16, "name": "Card 22"},
	{"id": 16, "name": "Card 23"},
	{"id": 16, "name": "Card 24"},
	{"id": 16, "name": "Card 25"},
	{"id": 16, "name": "Card 26"},
	{"id": 16, "name": "Card 27"},
	{"id": 16, "name": "Card 28"},
	{"id": 16, "name": "Card 29"},
	{"id": 16, "name": "Card 30"}
]

var shuffled_cards = []


func show_rewards():
	visible = true
	clear_cards()
	
	shuffled_cards = all_cards.duplicate()
	shuffled_cards.shuffle()
	
	for i in range(3):
		var data = shuffled_cards[i]
		create_card(data)
	
func create_card(data):
	var card = CARD_SCENE.instantiate()
	card.card_id = data.id
	card.card_name = data.name
	card.text = data.name

	card.card_selected.connect(_on_card_selected)

	card_container.add_child(card)

func clear_cards():
	for child in card_container.get_children():
		child.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _on_card_selected(card_id):
	print("Player selected card:", card_id)
	apply_reward(card_id)
	visible = false
	
	
	
func apply_reward(card_id):
	match card_id:
		0:
			print("Increase Max HP")
		1:
			print("Increase Silver Rate")
		2:
			print("Increase Gold Rate")
		_:
			print("Other reward")





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
