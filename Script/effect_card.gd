extends Button

@export var card_id : int
@export var card_name : String
@export var card_rank : String
@export var card_desc : String
@onready var label: Label = $Label

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var icon_sprite: AnimatedSprite2D = $Icon


var main
const SCROLL_OPEN = preload("uid://ciyhsb2lowwtt")

var original_y_position: float 

signal card_selected(card_id)
static var current_active_card: Button = null
var is_active := false

func _ready():
	add_theme_color_override("font_color", Color.WHITE)
	icon_sprite.scale = Vector2(3.0, 3.0)
	icon_sprite.self_modulate.a = 1.0
	sprite.play(card_rank)
	label.text = "%s" % [card_name] 
	icon_sprite.play(card_name)

func setup(m):
	main = m

func _process(_delta: float) -> void:
	pass

func _on_pressed() -> void:
	if current_active_card and current_active_card != self:
		current_active_card.reset_card()
	if is_active:
		reset_card()
	else:
		activate_card()

	emit_signal("card_selected", card_id)
	
func activate_card() -> void:
	is_active = true
	current_active_card = self
	sprite.play_backwards(card_rank)
	icon_sprite.self_modulate.a = 0.0
	icon_sprite.visible = false
	label.visible = false
		
func reset_card() -> void:
	is_active = false
	if current_active_card == self:
		current_active_card = null
	sprite.play(card_rank)
	icon_sprite.self_modulate.a = 1.0
	icon_sprite.visible = true
	label.visible = true


func _on_card_selected(card_id: Variant) -> void:
	pass # Replace with function body.
