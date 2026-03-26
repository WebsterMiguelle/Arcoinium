extends Node2D

var current_coins: int = 0
var max_capacity: int = 18
var slots: Array = []

@onready var _1: ColorRect = $"Deck/Row 1/1"
@onready var _2: ColorRect = $"Deck/Row 1/2"
@onready var _3: ColorRect = $"Deck/Row 1/3"
@onready var _4: ColorRect = $"Deck/Row 1/4"
@onready var _5: ColorRect = $"Deck/Row 1/5"
@onready var _6: ColorRect = $"Deck/Row 1/6"

@onready var _7: ColorRect = $"Deck/Row 2/7"
@onready var _8: ColorRect = $"Deck/Row 2/8"
@onready var _9: ColorRect = $"Deck/Row 2/9"
@onready var _10: ColorRect = $"Deck/Row 2/10"
@onready var _11: ColorRect = $"Deck/Row 2/11"
@onready var _12: ColorRect = $"Deck/Row 2/12"

@onready var _13: ColorRect = $"Deck/Row 3/13"
@onready var _14: ColorRect = $"Deck/Row 3/14"
@onready var _15: ColorRect = $"Deck/Row 3/15"
@onready var _16: ColorRect = $"Deck/Row 3/16"
@onready var _17: ColorRect = $"Deck/Row 3/17"
@onready var _18: ColorRect = $"Deck/Row 3/18"

@onready var coin_reserve: ColorRect = $CoinReserve



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	slots = [
		$"Deck/Row 1/1", $"Deck/Row 1/2", $"Deck/Row 1/3", $"Deck/Row 1/4", $"Deck/Row 1/5", $"Deck/Row 1/6",
		$"Deck/Row 2/7", $"Deck/Row 2/8", $"Deck/Row 2/9", $"Deck/Row 2/10", $"Deck/Row 2/11", $"Deck/Row 2/12",
		$"Deck/Row 3/13", $"Deck/Row 3/14", $"Deck/Row 3/15", $"Deck/Row 3/16", $"Deck/Row 3/17", $"Deck/Row 3/18"
	]
	current_coins = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_vacant_slot(current_flip: int) -> Vector2:
	if current_flip <= 0 or current_flip > slots.size():
		print("Warning: Invalid flip index:", current_flip)
		return Vector2.ZERO
	return slots[current_flip - 1].global_position

func get_reserve_slot() -> Vector2:
	return coin_reserve.global_position
