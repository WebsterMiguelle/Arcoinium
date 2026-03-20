extends Node2D

var current_coins: int
var max_capacity: int = 18
#@onready var texture_rect: TextureRect = $Deck/TextureRect
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


@onready var a1: TextureRect = $"Deck/Wheels/Rune_Layer1/1"
@onready var a2: TextureRect = $"Deck/Wheels/Rune_Layer1/2"
@onready var a3: TextureRect = $"Deck/Wheels/Rune_Layer1/3"
@onready var a4: TextureRect = $"Deck/Wheels/Rune_Layer1/4"
@onready var a5: TextureRect = $"Deck/Wheels/Rune_Layer2/5"
@onready var a6: TextureRect = $"Deck/Wheels/Rune_Layer2/6"
@onready var a7: TextureRect = $"Deck/Wheels/Rune_Layer2/7"
@onready var a8: TextureRect = $"Deck/Wheels/Rune_Layer2/8"
@onready var a9: TextureRect = $"Deck/Wheels/Rune_Layer3/9"
@onready var a10: TextureRect = $"Deck/Wheels/Rune_Layer3/10"
@onready var a11: TextureRect = $"Deck/Wheels/Rune_Layer3/11"
@onready var a12: TextureRect = $"Deck/Wheels/Rune_Layer3/12"
@onready var a13: TextureRect = $"Deck/Wheels/Rune_Layer4/13"
@onready var a14: TextureRect = $"Deck/Wheels/Rune_Layer4/14"
@onready var a15: TextureRect = $"Deck/Wheels/Rune_Layer4/15"
@onready var a16: TextureRect = $"Deck/Wheels/Rune_Layer4/16"


@onready var sigil_textures: Array = [a1, a2, a3, a4,a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16]

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
	sigil_textures[current_flip - 1].visible = true
	var pos_x = slot.global_position.x - 16
	var pos_y = slot.global_position.y + 20
	return [pos_x,pos_y]

func get_reserve_slot():
	return coin_reserve.global_position
	
func reset_sigils():
	for sigil in sigil_textures:
		sigil.visible = false
