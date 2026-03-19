extends Node2D

@onready var light_layer_1: Node2D = $"../LightLayer1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees -= 30 * delta
	pass
