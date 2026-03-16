extends Node2D

@onready var container = $EnemyCointainer
@onready var coin_scene = preload("res://enemy_coin.tscn")
@onready var coinlabel = $EnemyCoinLabel

var max_health = 10
var health = 10
var overlap = 12

# Called when the node enters the scene tree for the first time.
func _ready():
	if container == null:
		print("Error: container is null!")
	else:
		update_coins()
	print(container)
	

func take_damage(amount):
	health -= amount
	health = max(health, 0)
	update_coins()


func update_coins():
	
	if container == null:
		print("Error: container is null!")
		return
		
	# clear old coins
	for c in container.get_children():
		c.queue_free()
		
	for i in range(health):
		var coin = coin_scene.instantiate()
		container.add_child(coin)

		coin.position.x = i * overlap
		
	if coinlabel != null:	
		coinlabel.text = "Coin: " + str(health) + " / " + str(max_health)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
