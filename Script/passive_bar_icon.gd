extends Control

@onready var sprite: AnimatedSprite2D = $Icons

func _ready() -> void:
	custom_minimum_size = Vector2(48, 48) 
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_entered.connect(func(): print("SUCCESS: THE MOUSE TOUCHED THE ICON!"))

func setup(passive_name: String, description: String) -> void:
	sprite.play(passive_name)
