extends Button

@export var card_id : int
@export var card_name : String
@export var card_tier : String
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal card_selected(card_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	# 1. Play your existing animation
	sprite.play("unfurl_down")
	text = card_name + " (" + card_tier + ")"
	if not self.pressed.is_connected(_on_pressed):
		self.pressed.connect(_on_pressed)
	_animate_entrance()

func _animate_entrance():
	modulate.a = 0
	await get_tree().process_frame
	await get_tree().process_frame
	var final_x = position.x
	position.x += 400
	var tween = create_tween()
	var index = get_index()
	tween.tween_interval(index * 0.1)
	tween.tween_property(self, "position:x", final_x, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	emit_signal("card_selected", card_id)
