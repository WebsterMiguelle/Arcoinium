extends Control

@onready var sprite: AnimatedSprite2D = $Icons

func setup(passive_name: String, description: String, anim_name: String) -> void:
	tooltip_text = passive_name + "\n" + description
	sprite.play(anim_name)
