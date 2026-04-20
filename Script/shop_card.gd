extends Button

# --- DATA ---
@export var card_id : int
@export var card_name : String
@export var price : int = 5
@export var stock: int = 1
@export var card_rank : String
@export var card_desc : String # NEW: For the global description box!

# --- UI NODES ---
@onready var label: Label = $Label
@onready var stock_label = $StockStatus
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var icon_sprite: AnimatedSprite2D = $Icon
@onready var glow_panel: Panel = $GlowPanel # NEW: The glow panel

# --- ANIMATION VARIABLES ---
var normal_scale = Vector2(1.0, 1.0)
var hover_scale = Vector2(1.2, 1.2) 
var float_tween: Tween
var original_y_position: float 

# --- SIGNALS ---
signal card_bought(card_id, price)
signal card_hovered(description: String) # NEW
signal card_unhovered() # NEW

var main
const SCROLL_OPEN = preload("uid://ciyhsb2lowwtt")
const GAIN_EFFECT = preload("uid://cr366klr6aivy")

func setup(m):
	main = m

func _ready() -> void:
	# UI Setup
	update_stock_display()
	label.text = "%s" % [card_name] + "\n$" + str(price)
	add_theme_color_override("font_color", Color.WHITE)
	sprite.play(card_rank)
	
	# NEW: Prepare the icon and glow for their entrance animations
	glow_panel.self_modulate.a = 0
	icon_sprite.scale = Vector2(10.0, 10.0)
	icon_sprite.self_modulate.a = 0
	icon_sprite.play(card_name)
	
	# Signal Connections
	if not self.pressed.is_connected(_on_pressed):
		self.pressed.connect(_on_pressed)
	if not self.mouse_entered.is_connected(_on_mouse_entered):
		self.mouse_entered.connect(_on_mouse_entered)
	if not self.mouse_exited.is_connected(_on_mouse_exited):
		self.mouse_exited.connect(_on_mouse_exited)
		
	_animate_entrance()

func update_state(player_coin):
	# Darken the card if they can't afford it or it's sold out
	if player_coin < price or stock <= 0:
		disabled = true
		modulate.a = 0.5
	else:
		disabled = false
		modulate.a = 1.0

func _animate_entrance():
	# Start invisible
	modulate.a = 0.0
	
	# Wait for the UI Container to place the card perfectly
	await get_tree().process_frame
	await get_tree().process_frame
	
	original_y_position = self.position.y
	
	var final_x = position.x
	position.x += 400
	var tween = create_tween()
	var index = get_index()
	
	# 1. Slide the card in
	tween.tween_interval(index * 0.1)
	tween.tween_property(self, "position:x", final_x, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	# NEW: Safely check what transparency the card should be based on affordability!
	var target_alpha = 0.5 if disabled else 1.0
	tween.parallel().tween_property(self, "modulate:a", target_alpha, 0.2)
	
	# 2. Wait for the scroll to unfurl
	tween.tween_interval(0.3) 
	
	# 3. Slam the icon onto the card
	tween.tween_property(icon_sprite, "scale", Vector2(3.059, 2.938), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(icon_sprite, "self_modulate:a", 1.0, 0.4)

func _on_mouse_entered() -> void:
	# Even if disabled (can't afford), we can still float and show the description!
	pivot_offset = size / 2.0
	var tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, 0.2).set_trans(Tween.TRANS_SINE)
	
	# Only show the glow if they can actually afford it (not disabled)
	if not disabled:
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

func _on_pressed() -> void:
	
	if stock <= 0:
		return
	main.sound_manager.play_sound(SCROLL_OPEN)
	main.sound_manager.play_sound(GAIN_EFFECT)
	stock -= 1
	card_bought.emit(card_id, price)
	update_stock_display()
	
	# If the card is completely sold out, play the dramatic roll-up animation!
	if stock <= 0:
		glow_panel.visible = false
		label.visible = false
		stock_label.visible = false
		
		# Animate the icon fading away
		var tween = create_tween()
		tween.tween_property(icon_sprite, "scale", Vector2(10.0, 10.0), 0.3).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property(icon_sprite, "self_modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
		
		# Roll up the scroll
		sprite.play_backwards(card_rank)
		await sprite.animation_finished
	else:
		# If they bought one but there is still stock left, just do a little "purchased" bounce
		var bounce_tween = create_tween()
		bounce_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		bounce_tween.tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

func update_stock_display():
	if stock <= 0:
		stock_label.text = "SOLD OUT"
		stock_label.add_theme_color_override("font_color", Color.RED)
		label.text = card_name 
		
		# Automatically disable it and dim it upon selling out
		disabled = true
		modulate.a = 0.5
	else:
		stock_label.text = str(stock)
		stock_label.add_theme_color_override("font_color", Color.WHITE)
		label.text = "%s\n$%s" % [card_name, str(price)]
