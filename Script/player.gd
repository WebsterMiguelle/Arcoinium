extends Node2D

#PLAYER STATS
var max_coin = 100 #Max Coin Capacity
var coin = 100:
	set(value):
		coin = clamp(value,0,max_coin)
var max_flip: = 18 #Max Flips Per Turn
var current_flip: = 0: #Current Flip Count
	set(value):
		current_flip = clamp(value,0,max_flip)
var max_re_flip = 9 #Max Re-Flips Per Turn
var current_re_flip = 0: #Current Re-Flip Count
	set(value):
		current_re_flip = clamp(value,0,max_re_flip)
var silver_flip_rate = 0.1: #Chance to Flip a Silver Coin
	set(value): 
		silver_flip_rate = clamp(value,0.0,100.0) 
var gold_flip_rate = 0.05: #Chance to Flip a Gold Coin
	set(value): 
		gold_flip_rate = clamp(value,0.0,100.0) 

#STATUS EFFECTS

var gain = 0 #Coin to be gained next turn
var debt = 0 #Damage to be receieved

func take_damage(amount):
	coin -= amount
	print("Player HP: ", coin)

func gain_coin():
	coin += gain
	gain = 0
	print("Player HP: ", coin)

	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
