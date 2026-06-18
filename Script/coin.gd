extends Node2D
@onready var shined: AnimatedSprite2D = $SHINED
@onready var voided: AnimatedSprite2D = $VOIDED
@onready var dazzled: AnimatedSprite2D = $DAZZLED
@onready var stamped: TextureRect = $STAMPED
@onready var shine_stack_label: Label = $"Shine Stack Label"

enum CoinType{
	COPPER,
	SILVER,
	GOLD
}

enum CoinStatus{
	NONE,
	SHINED,
	VOIDED,
	DAZZLED
}

#COIN VARIABLES
var is_stamped = false
var shine_stack = 0
var initial_status = CoinStatus.NONE #If VOIDED, remember what status it was beforehand.
var type
var base_value:int
var state:int # If 0, then Head, Else, then Tail
var status:CoinStatus
var reserved:bool
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	refresh_sprite()

func setup(s,pos):
	state = s
	global_position.x = pos[0]
	global_position.y = pos[1]
	reserved = false
	type = CoinType.COPPER
	base_value = 2
	status = CoinStatus.NONE
	shine_stack = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func re_flip():
	state = randi() % 2
	if !reserved:
		refresh_sprite()
	
		
func upgrade():
	match type:
		CoinType.COPPER:
			type = CoinType.SILVER
			base_value = 4
		CoinType.SILVER:
			type = CoinType.GOLD
			base_value = 6

func upgrade_to_silver():
	type = CoinType.SILVER
	base_value = 4

func upgrade_to_gold():
	type = CoinType.GOLD
	base_value = 6

func degrade_to_copper():
	type = CoinType.COPPER
	base_value = 2
	
func copy_coin(coin):
	base_value = coin.base_value
	reserved = coin.reserved
	type = coin.type
	state = coin.state
	status = coin.status
	initial_status = coin.initial_status
	is_stamped = coin.is_stamped
	shine_stack = coin.shine_stack

func add_status(stat):
	if stat != CoinStatus.VOIDED:
		initial_status = stat
		status = stat
	else:
		status = stat
	
func refresh_sprite():
	var appear_tween = create_tween()
	
	appear_tween.tween_property(animated_sprite_2d, "position:y", 0, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	appear_tween.parallel().tween_property(animated_sprite_2d, "modulate:a", 1.0, 0.2)
	
	stamped.visible = false
	shine_stack_label.visible = false
	
	if status == CoinStatus.VOIDED:
		voided.visible = true
	else:
		voided.visible = false
		status = initial_status
		
	if status == CoinStatus.SHINED:
		shined.visible = true
	else:
		shined.visible = false
		
	if status == CoinStatus.DAZZLED:
		dazzled.visible = true
	else:
		dazzled.visible = false

	match type:
		CoinType.COPPER:
			base_value = 2
			animated_sprite_2d.play("copper_to_head" if state == 0 else "copper_to_tail")
			voided.play("copper_to_head" if state == 0 else "copper_to_tail")
			voided.play("copper_to_head" if state == 0 else "copper_to_tail")
			dazzled.play("copper_to_head" if state == 0 else "copper_to_tail")
			await animated_sprite_2d.animation_finished
			animated_sprite_2d.play("copper_head" if state == 0 else "copper_tail")
			shined.play("copper_head" if state == 0 else "copper_tail")
			voided.play("copper_head" if state == 0 else "copper_tail")
			dazzled.play("copper_head" if state == 0 else "copper_tail")
		CoinType.SILVER:
			base_value = 4
			animated_sprite_2d.play("silver_to_head" if state == 0 else "silver_to_tail")
			shined.play("silver_to_head" if state == 0 else "silver_to_tail")
			voided.play("copper_to_head" if state == 0 else "copper_to_tail")
			dazzled.play("silver_to_head" if state == 0 else "silver_to_tail")
			await animated_sprite_2d.animation_finished
			
			animated_sprite_2d.play("silver_head" if state == 0 else "silver_tail")
			shined.play("silver_head" if state == 0 else "silver_tail")
			voided.play("copper_head" if state == 0 else "copper_tail")
			dazzled.play("silver_head" if state == 0 else "silver_tail")
			
		CoinType.GOLD:
			base_value = 6
			animated_sprite_2d.play("gold_to_head" if state == 0 else "gold_to_tail")
			shined.play("gold_to_head" if state == 0 else "gold_to_tail")
			voided.play("copper_to_head" if state == 0 else "copper_to_tail")
			dazzled.play("gold_to_head" if state == 0 else "gold_to_tail")
			await animated_sprite_2d.animation_finished
			animated_sprite_2d.play("gold_head" if state == 0 else "gold_tail")
			shined.play("gold_head" if state == 0 else "gold_tail")
			voided.play("copper_head" if state == 0 else "copper_tail")
			dazzled.play("gold_head" if state == 0 else "gold_tail")
	if is_stamped:
		stamped.visible = true
	if status == CoinStatus.SHINED and shine_stack > 0:
		shine_stack_label.visible = true
		shine_stack_label.text = "x" + str(shine_stack+1)

# Inside your Coin.gd script
var glow_tween: Tween

func pulse_glow() -> void:
	# If it's already glowing, kill the old animation to prevent overlapping glitches
	if glow_tween and glow_tween.is_running():
		glow_tween.kill()
		
	glow_tween = create_tween().set_parallel(true)
	
	# Swell slightly and brighten the color
	glow_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.4).set_trans(Tween.TRANS_SINE)
	glow_tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5, 1.0), 0.4).set_trans(Tween.TRANS_SINE)
	
	# Chain it to shrink back to normal slowly
	glow_tween.chain().tween_property(self, "scale", Vector2(1.0, 1.0), 0.6).set_trans(Tween.TRANS_SINE)
	glow_tween.chain().tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.6).set_trans(Tween.TRANS_SINE)
