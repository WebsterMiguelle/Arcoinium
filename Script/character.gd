extends Node2D

@export var max_health = 10
var health = 10

@export var health_ui: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	if health_ui:
		health_ui.health = health
		health_ui.max_health = max_health
		health_ui.update_coins()

func take_damage(amount: int):
	health -= amount
	health = max(health, 0)
	if health_ui:
		health_ui.health = health
		health_ui.update_coins()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
