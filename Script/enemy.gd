#Enemy
extends Node

@onready var health_ui = $"../CanvasLayer/EnemyCoinHealth"

var health = 10
var max_health = 10
	
	
func take_damage(amount):
	health -= amount
	health = max(health, 0)
	
	health_ui.health = health
	health_ui.update_coins()
	
	
	print("Enemy HP: ", health)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	health_ui.max_health = max_health
	health_ui.health = health
	health_ui.update_coins()
	print(health_ui)
	
func gain_health(amount: int) -> void:
	health += amount
	health = min(health, max_health)
	health_ui.health = health
	health_ui.update_coins()
	print("Enemy HP: ", health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
