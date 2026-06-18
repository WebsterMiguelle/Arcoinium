extends Button

@export var card_id : int
@export var card_name : String
@export var card_rank : String
@export var card_desc : String
@onready var label: Label = $Label

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var icon_sprite: AnimatedSprite2D = $Icon

@onready var glow_panel: Panel = $GlowPanel

var normal_scale = Vector2(1.0, 1.0)
var hover_scale = Vector2(1.2, 1.2) # 20% bigger
var float_tween: Tween
var main
const SCROLL_OPEN = preload("uid://ciyhsb2lowwtt")


# 1. Remove @onready. We will set this when the container is finished loading!
var original_y_position: float 

signal card_selected(card_id)
signal card_hovered(description: String)
signal card_unhovered()

func _ready():
	add_theme_color_override("font_color", Color.WHITE)
	glow_panel.self_modulate.a = 0
	icon_sprite.scale = Vector2(10.0, 10.0)
	icon_sprite.self_modulate.a = 0
	sprite.play(card_rank)
	label.text = "%s" % [card_name] 

	if not self.pressed.is_connected(_on_pressed):
		self.pressed.connect(_on_pressed)
	if not self.mouse_entered.is_connected(_on_mouse_entered):
		self.mouse_entered.connect(_on_mouse_entered)
	if not self.mouse_exited.is_connected(_on_mouse_exited):
		self.mouse_exited.connect(_on_mouse_exited)
	
	_animate_entrance()
	icon_sprite.play(card_name)

func setup(m):
	main = m

func _animate_entrance():
	modulate.a = 0
	
	await get_tree().process_frame
	await get_tree().process_frame

	original_y_position = self.position.y
	
	var final_x = position.x
	position.x += 400
	var tween = create_tween()
	var index = get_index()
	
	tween.tween_interval(index * 0.1)
	tween.tween_property(self, "position:x", final_x, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.2)
	
	tween.tween_interval(0.3) 
	
	tween.tween_property(icon_sprite, "scale", Vector2(4.0, 4.0), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(icon_sprite, "self_modulate:a", 1.0, 0.4)

func _process(_delta: float) -> void:
	pass

func _on_pressed() -> void:
	main.sound_manager.play_sound(SCROLL_OPEN)
	glow_panel.visible = false
	var tween = create_tween()
	tween.tween_property(icon_sprite,"scale",Vector2(10.0,10.0), 0.3).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(icon_sprite,"self_modulate:a", 0, 0.3).set_trans(Tween.TRANS_SINE)
	
	label.visible = false
	main.sound_manager.play_sound(SCROLL_OPEN)
	sprite.play_backwards(card_rank)
	await sprite.animation_finished
	
	emit_signal("card_selected", card_id)
	
func _on_mouse_entered() -> void:
	pivot_offset = size / 2.0
	var tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, 0.2).set_trans(Tween.TRANS_SINE)
	
	tween.parallel().tween_property(glow_panel, "self_modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE)
	
	if float_tween: float_tween.kill() 
	
	float_tween = create_tween().set_loops()
	float_tween.tween_property(self, "position:y", original_y_position - 15.0, 0.5).set_trans(Tween.TRANS_SINE)
	float_tween.tween_property(self, "position:y", original_y_position + 15.0, 0.5).set_trans(Tween.TRANS_SINE)
	card_hovered.emit(card_desc)

func _on_mouse_exited() -> void:
	if float_tween: float_tween.kill()
	
	var tween = create_tween()
	
	tween.tween_property(self, "scale", normal_scale, 0.2).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "position:y", original_y_position, 0.2).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(glow_panel, "self_modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_SINE)
	card_unhovered.emit()
