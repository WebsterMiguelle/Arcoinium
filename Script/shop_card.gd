extends Button

@onready var stock_label = $StockStatus
@export var card_id : int
@export var card_name : String
@export var price : int = 5
@export var stock: int = 1
@export var card_rank : String
@onready var label: Label = $Label

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var icon_sprite: AnimatedSprite2D = $Icon


signal card_bought(card_id, price)

var normal_scale = Vector2(1.0, 1.0)
var hover_scale = Vector2(1.2, 1.2) # 20% bigger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_stock_display()
	label.text = "%s" % [card_name] + "\n$" + str(price)
	add_theme_color_override("font_color", Color.WHITE)
	sprite.play(card_rank)
	if not self.pressed.is_connected(_on_pressed):
		self.pressed.connect(_on_pressed)
	if not self.mouse_entered.is_connected(_on_mouse_entered):
		self.mouse_entered.connect(_on_mouse_entered)
	if not self.mouse_exited.is_connected(_on_mouse_exited):
		self.mouse_exited.connect(_on_mouse_exited)
	_animate_entrance()
	icon_sprite.play(card_name)
	 
	pivot_offset = size / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_state(player_coin):
	if player_coin < price or stock <= 0:
		disabled = true
		#modulate = Color(1,1,1)
		modulate.a = 0.5
	else:
		disabled = false
		#modulate = Color(1,1,1)
		modulate.a = 1.0
	
func _on_pressed() -> void:
	if stock <= 0:
		return
	stock -= 1
	card_bought.emit(card_id, price)
	update_stock_display()
	icon_sprite.visible = false
	sprite.play_backwards(card_rank)
	await sprite.animation_finished
	
	
	
func _animate_entrance():
	modulate.a = 0.0 
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var final_x = position.x
	position.x += 400
	
	var target_alpha = 1.0
	if disabled: 
		target_alpha = 0.5
		
	var tween = create_tween()
	var index = get_index()
	
	tween.tween_interval(index * 0.1)
	tween.tween_property(self, "position:x", final_x, 0.4).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(self, "modulate:a", target_alpha, 0.2)
	
func _on_mouse_entered() -> void:
	var tween = create_tween()
	# TRANS_SINE makes the swelling look smooth and natural
	#tween.tween_property(self, "scale", hover_scale, 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", hover_scale, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
func _on_mouse_exited() -> void:
	var tween = create_tween()
	# Shrink back down to the normal resting size
	#tween.tween_property(self, "scale", normal_scale, 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", normal_scale, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
func update_stock_display():
	if stock <= 0:
		stock_label.text = "SOLD OUT"
		stock_label.add_theme_color_override("font_color", Color.RED)
		text = card_name 
		disabled = true
	else:
		stock_label.text = str(stock)
		stock_label.add_theme_color_override("font_color", Color.WHITE)
		text = " (" + str(price) + "g)"
	
