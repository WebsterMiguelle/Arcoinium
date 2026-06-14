extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shine_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func shine_animation() -> void:
	var tween = create_tween().set_loops() # Infinite loop
	tween.tween_property(self, "modulate", Color("ffffff00"), 0.5)
	tween.tween_property(self, "modulate", Color("ffb632"), 0.5)
