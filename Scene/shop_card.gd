extends Button

@export var card_id : int
@export var card_name : String
@export var price : int = 5


signal card_bought(card_id, price)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = card_name + "\n$" + str(price)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_state(player_coin):
	disabled = player_coin < price
	modulate = Color(1,1,1,0.5) if disabled else Color(1,1,1,1)
	
func _on_pressed() -> void:
	card_bought.emit(card_id, price)
