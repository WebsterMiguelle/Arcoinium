extends Button

@export var card_id : int
@export var card_name : String
@export var card_tier: String = "Copper"


signal card_selected(card_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	text = card_name + " (" + card_tier + ")"
	self.pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	print("CLICKED:", card_name, "-", card_tier)
	emit_signal("card_selected", card_id)
