extends Node2D

enum CoinType{
	COPPER,
	SILVER,
	GOLD
}
#COIN VARIABLES
var type
var base_value:int
var state:int # If 0, then Head, Else, then Tail
var reserved:bool
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass 

func setup(s,pos):
	state = s
	global_position = pos
	reserved = false
	type = CoinType.COPPER
	base_value = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match type:
		CoinType.COPPER:
			if state == 0:
				animated_sprite_2d.play("head")
			else:
				animated_sprite_2d.play("tail")
		CoinType.SILVER:
			if state == 0:
				animated_sprite_2d.play("head_silver")
			else:
				animated_sprite_2d.play("tail_silver")
		CoinType.GOLD:
			if state == 0:
				animated_sprite_2d.play("head_gold")
			else:
				animated_sprite_2d.play("tail_gold")
	

func re_flip():
	state = randi() % 2
	
func upgrade():
	match type:
		CoinType.COPPER:
			type = CoinType.SILVER
			base_value = 4
		CoinType.SILVER:
			base_value = 6
			type = CoinType.GOLD

func upgrade_to_silver():
	base_value = 4
	type = CoinType.SILVER

func upgrade_to_gold():
	base_value = 6
	type = CoinType.GOLD
	
func copy_coin(coin):
	base_value = coin.base_value
	state = coin.state
	reserved = coin.reserved
	type = coin.type
