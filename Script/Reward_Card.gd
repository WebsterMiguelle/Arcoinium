extends Button

@export var card_id : int
@export var card_name : String
@export var card_rank : String
@onready var label: Label = $Label

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var icon_sprite: AnimatedSprite2D = $Icon

var normal_scale = Vector2(1.0, 1.0)
var hover_scale = Vector2(1.2, 1.2) # 20% bigger

signal card_selected(card_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	#sprite.z_index = -1
	add_theme_color_override("font_color", Color.WHITE)
	# 1. Play your existing animation
	sprite.play(card_rank)
	label.text = "%s" % [card_name] 
	if not self.pressed.is_connected(_on_pressed):
		self.pressed.connect(_on_pressed)
	if not self.mouse_entered.is_connected(_on_mouse_entered):
		self.pressed.connect(_on_mouse_entered)
	if not self.mouse_exited.is_connected(_on_mouse_exited):
		self.pressed.connect(_on_mouse_exited)
	_animate_entrance()
	icon_sprite.play(card_name)

func _animate_entrance():
	modulate.a = 0
	await get_tree().process_frame
	await get_tree().process_frame
	var final_x = position.x
	position.x += 400
	var tween = create_tween()
	var index = get_index()
	tween.tween_interval(index * 0.1)
	tween.tween_property(self, "position:x", final_x, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	icon_sprite.visible = false
	sprite.play_backwards(card_rank)
	await sprite.animation_finished
	
	emit_signal("card_selected", card_id)
	
	
func _on_mouse_entered() -> void:
	var tween = create_tween()
	# TRANS_SINE makes the swelling look smooth and natural
	tween.tween_property(self, "scale", hover_scale, 0.2).set_trans(Tween.TRANS_SINE)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	# Shrink back down to the normal resting size
	tween.tween_property(self, "scale", normal_scale, 0.2).set_trans(Tween.TRANS_SINE)
