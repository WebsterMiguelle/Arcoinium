extends Button

@onready var stock_label = $StockStatus
@export var card_id : int
@export var card_name : String
@export var price : int = 5
@export var stock: int = 1


signal card_bought(card_id, price)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_stock_display()
	text = card_name + "\n$" + str(price)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_state(player_coin):
	if player_coin < price or stock <= 0:
		disabled = true
		modulate = Color(1,1,1,0.5)
	else:
		disabled = false
		modulate = Color(1,1,1,1)
	
func _on_pressed() -> void:
	if stock <= 0:
		return
	stock -= 1
	card_bought.emit(card_id, price)
	update_stock_display()
	
func update_stock_display():
	if stock <= 0:
		stock_label.text = "SOLD OUT"
		stock_label.add_theme_color_override("font_color", Color.RED)
		text = card_name 
		disabled = true
	else:
		stock_label.text = "Stock: " + str(stock)
		stock_label.add_theme_color_override("font_color", Color.WHITE)
		text = card_name + " (" + str(price) + "g)"
