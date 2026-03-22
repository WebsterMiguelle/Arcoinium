extends Node2D


# Called when the node enters the scene tree for the first time.
@onready var glow_aura = $"../../../Glow Aura" # Make sure the name matches your node
@onready var _1: TextureRect = $"1"

func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees += 20 * delta
	pass
