#Enemy
extends Node

enum Enemy{
	MAGE,
	DWARF,
	COLLECTOR,
	TRADER,
	THRIFTER,
	ARISTOCRAT,
	SUN_CASTER,
	MOON_CASTER,
	TWILIGHT_SAGE
}

#ENEMY STATS
var bounty = 0 #Coin Drop on Death
var type #Enemy Type
var max_coin = 0 #Max Coin Capacity
var coin = 0:
	set(value):
		coin = clamp(value,0,max_coin)
var max_flip: = 0: #Max Flips Per Turn
	set(value):
		max_flip = clamp(value,0,16)
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

var gain = 0: #Coin to be gained next turn
	set(value):
		gain = clamp(value,0,1000) 
var debt = 0: #Gain Blocked
	set(value):
		debt = clamp(value,0,1000) 

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
	var temp = gain
	gain -= debt
	debt -= temp
	coin += gain
	gain = 0
	print("Player HP: ", coin)

func setup(enemy):
	print("Hello" + str(enemy))
	match enemy:
		Enemy.MAGE:
			max_coin = 200
			coin = 10
			max_flip = 1
			silver_flip_rate = 0.0
			gold_flip_rate = 0.0
			bounty = 15
			type = Enemy.MAGE
		Enemy.DWARF:
			max_coin = 200
			coin = 14
			max_flip = 2
			silver_flip_rate = 0.0
			gold_flip_rate = 0.0
			bounty = 10
			type = Enemy.DWARF
		Enemy.COLLECTOR:
			max_coin = 200
			coin = 24
			max_flip = 6
			silver_flip_rate = 0.05
			gold_flip_rate = 0.0
			bounty = 30
			type = Enemy.COLLECTOR
		Enemy.TRADER:
			max_coin = 200
			coin = 28
			max_flip = 2
			silver_flip_rate = 0.05
			gold_flip_rate = 0.0
			bounty = 30
			type = Enemy.TRADER
		Enemy.THRIFTER:
			max_coin = 200
			coin = 36
			max_flip = 8
			silver_flip_rate = 0.1
			gold_flip_rate = 0
			bounty = 45
			type = Enemy.THRIFTER
		Enemy.ARISTOCRAT:
			max_coin = 200
			coin = 120
			max_flip = 16
			silver_flip_rate = 1
			gold_flip_rate = 0
			bounty = 45
			type = Enemy.ARISTOCRAT
		Enemy.SUN_CASTER:
			max_coin = 200
			coin = 100
			max_flip = 12
			silver_flip_rate = 0.5
			gold_flip_rate = 0
			bounty = 60
			type = Enemy.SUN_CASTER
		Enemy.MOON_CASTER:
			max_coin = 200
			coin = 100
			max_flip = 12
			silver_flip_rate = 0.5
			gold_flip_rate = 0
			bounty = 60
			type = Enemy.MOON_CASTER
			
