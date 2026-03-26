extends CanvasLayer

@onready var container = $Background/CenterContainer/VBoxContainer/CardContainer
const Shop_card = preload("res://Scene/shop_card.tscn")
@onready var bg = $Background
@onready var back_button = $Background/Back

@onready var coin_label = $Background/CoinLabel

var player_ref

signal item_purchased(card_id, price)

func show_shop(player):
	player_ref = player
	get_parent().reward_manager.set_cards_enabled(false)
	
	bg.visible = true
	visible = true
	back_button.disabled = false 
	
	generate_shop()
	
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 0.5, 0.5)
	
func generate_shop():
	for child in container.get_children():
		child.queue_free()
	
	for i in range(6):
		var card = Shop_card.instantiate()
		
		card.card_id = randi() % 5
		card.card_name = "Item " + str(card.card_id)
		card.price = randi_range(3, 10)
		card.stock = randi_range(1, 3)
		
		card.card_bought.connect(_on_card_bought)
		container.add_child(card)
		
		
func _on_card_bought(card_id, price):
	if player_ref.coin >= price:
		emit_signal("item_purchased", card_id, price)
	else:
		print("Not enough coins!")
		
		
		
func apply_item(card_id):
	match card_id:
		0:
			player_ref.max_flip += 1
		1:
			player_ref.gold_flip_rate += 0.1
		2:
			player_ref.max_re_flip += 1
			
			
func close_shop():
	bg.visible = false
	visible = false
	get_parent().reward_manager.set_cards_enabled(true)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not visible or player_ref == null:
		return
		
	for card in container.get_children():
		card.update_state(player_ref.coin)
		
	coin_label.text = "Coins: " + str(player_ref.coin)


func _on_back_pressed() -> void:
	close_shop()
