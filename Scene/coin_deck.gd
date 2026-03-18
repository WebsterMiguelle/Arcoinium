extends Node2D

var current_coins: int
var max_capacity: int = 18

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
@onready var texture_rect: TextureRect = $Deck/TextureRect

@onready var coin_reserve: ColorRect = $CoinReserve

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_coins = 0;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_vacant_slot(current_flip):
	var slot = get("_" + str(current_flip))
	return slot.global_position

func get_reserve_slot():
	return coin_reserve.global_position
