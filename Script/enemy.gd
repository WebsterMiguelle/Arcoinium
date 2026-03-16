#Enemy
extends Node
	
@onready var health_bar = $"../Battle UI/EnemyHealthBar"
@onready var health_label = $"../Battle UI/EnemyHealthBar/EnemyHealthLabel"


var health = 200
var max_health = 200
	
	
func take_damage(amount):
	health -= amount
	health = max(health, 0)
	update_health()
	print("Enemy HP: ", health)
	
	
func update_health():

	health_bar.value = health
	health_label.text = str(health) + " / " + str(max_health)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = max_health
	update_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
