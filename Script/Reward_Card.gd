extends Button

@export var card_id : int
@export var card_name : String

signal card_selected(card_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "%s" % [card_name]
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	emit_signal("card_selected", card_id)
