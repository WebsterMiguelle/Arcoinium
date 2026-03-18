#Enemy
extends Node

enum Enemy{
	MAGE,
	DWARF
}

#ENEMY STATS
var bounty = 0 #Coin Drop on Death
var type #Enemy Type
var max_coin = 0 #Max Coin Capacity
var coin = 0:
	set(value):
		coin = clamp(value,0,max_coin)
var max_flip: = 0 #Max Flips Per Turn
var current_flip: = 0: #Current Flip Count
	set(value):
		current_flip = clamp(value,0,max_flip)
var silver_flip_rate = 0.0: #Chance to Flip a Silver Coin
	set(value): 
		silver_flip_rate = clamp(value,0.0,100.0) 
var gold_flip_rate = 0.00: #Chance to Flip a Gold Coin
	set(value): 
		gold_flip_rate = clamp(value,0.0,100.0) 

#STATUS EFFECTS

var gain = 0 #Coin to be gained next turn
var debt = 0 #Damage to be receieved

func take_damage(amount):
	coin-= amount
	coin = max(coin, 0)
	print("Enemy HP: ", coin)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gain_coin():
	coin += gain
	gain = 0
	print("Enemy HP: ", coin)

func setup(enemy):
	print("Hello" + str(enemy))
	match enemy:
		Enemy.MAGE:
			max_coin = 15
			coin = 15
			max_flip = 1
			silver_flip_rate = 0.0
			gold_flip_rate = 0.0
			bounty = 10
			type = Enemy.MAGE
		Enemy.DWARF:
			max_coin = 20
			coin = 20
			max_flip = 2
			silver_flip_rate = 0.0
			gold_flip_rate = 0.0
			bounty = 10
			type = Enemy.DWARF
