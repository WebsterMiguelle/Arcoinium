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
	refresh_sprite()
	pass 

func setup(s,pos):
	state = s
	global_position = pos
	reserved = false
	type = CoinType.COPPER
	base_value = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func re_flip():
	state = randi() % 2
	
func upgrade():
	match type:
		CoinType.COPPER:
			type = CoinType.SILVER
		CoinType.SILVER:
			type = CoinType.GOLD

func upgrade_to_silver():
	type = CoinType.SILVER

func upgrade_to_gold():
	type = CoinType.GOLD
	
func refresh_sprite():
	var appear_tween = create_tween()
	
	appear_tween.tween_property(animated_sprite_2d, "position:y", 0, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	appear_tween.parallel().tween_property(animated_sprite_2d, "modulate:a", 1.0, 0.2)
	
	match type:
		CoinType.COPPER:
			base_value = 2
			animated_sprite_2d.play("copper_to_head" if state == 0 else "copper_to_tail")
			await animated_sprite_2d.animation_finished
			animated_sprite_2d.play("copper_head" if state == 0 else "copper_tail")
		CoinType.SILVER:
			base_value = 4
			animated_sprite_2d.play("silver_to_head" if state == 0 else "silver_to_tail")
			await animated_sprite_2d.animation_finished
			animated_sprite_2d.play("silver_head" if state == 0 else "silver_tail")
		CoinType.GOLD:
			base_value = 6
			animated_sprite_2d.play("gold_to_head" if state == 0 else "gold_to_tail")
			await animated_sprite_2d.animation_finished
			animated_sprite_2d.play("gold_head" if state == 0 else "gold_tail")
	
