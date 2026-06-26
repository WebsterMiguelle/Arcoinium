extends Node2D

@onready var lower_bite: TextureRect = $"Lower Bite"
@onready var upper_bite: TextureRect = $"Upper Bite"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bite_tween = create_tween()
	upper_bite.position.y = -20
	lower_bite.position.y = 20
	
	bite_tween.parallel().tween_property(upper_bite,"self_modulate",Color("#ffffff"),0.2)
	bite_tween.parallel().tween_property(lower_bite,"self_modulate",Color("#ffffff"),0.2)
	bite_tween.parallel().tween_property(upper_bite,"position:y", 0, 0.2)
	bite_tween.parallel().tween_property(lower_bite,"position:y", 0, 0.2)
	await bite_tween.finished
	var fade_tween = create_tween()
	fade_tween.parallel().tween_property(upper_bite,"self_modulate",Color("#ffffff00"),0.2)
	fade_tween.parallel().tween_property(lower_bite,"self_modulate",Color("#ffffff00"),0.2)
	await fade_tween.finished
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
