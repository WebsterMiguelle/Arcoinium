extends Control

@onready var sprite: AnimatedSprite2D = $Icons

func _ready() -> void:
	# 1. FORCE THE HITBOX SIZE! 
	# Change "32, 32" to whatever the actual width/height of your Sprite is!
	custom_minimum_size = Vector2(32, 32) 
	
	# 2. Force the mouse filter to Pass just to be safe
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	# 3. Local debug test
	mouse_entered.connect(func(): print("SUCCESS: THE MOUSE TOUCHED THE ICON!"))

func setup(passive_name: String, description: String) -> void:
	sprite.play(passive_name)
