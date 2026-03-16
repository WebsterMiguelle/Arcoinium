extends Node2D

#COIN VARIABLES
var base_value:int
var state:int # If 0, then Head, Else, then Tail
var reserved:bool
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass 

func setup(bv,s,pos):
	base_value = bv
	state = s
	global_position = pos
	reserved = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == 0:
		animated_sprite_2d.play("head")
	else:
		animated_sprite_2d.play("tail")
	

func re_flip():
	state = randi() % 2
