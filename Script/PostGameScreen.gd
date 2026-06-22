extends Control

@onready var left_door: Control = $LeftSideBricks
@onready var right_edge: TextureRect = $RightSideBricks/OpenTile
@onready var left_edge: TextureRect = $LeftSideBricks/OpenTile
@onready var dark_overlay: ColorRect = $DarkOverlay

@onready var right_door: Control = $RightSideBricks
@onready var ui_layer: Control = $UILayer

func _ready() -> void:

	ui_layer.modulate.a = 0.0
	ui_layer.scale = Vector2(0.8, 0.8) # Start slightly shrunken
	dark_overlay.modulate.a = 0.0

	ui_layer.pivot_offset = ui_layer.size / 2 
	
	play_slam_animation()

func play_slam_animation() -> void:
	# Get the exact width of the game window
	var screen_width = get_viewport_rect().size.x
	var half_screen = screen_width / 2.0
	right_edge.visible = true
	left_edge.visible = true
	left_door.position.x = -329
	right_door.position.x = 1476.0
	
	# ==========================================
	# 2. PHASE 1: THE DOORS SLAM INWARD
	# ==========================================
	var tween = create_tween()
	tween.set_parallel(true) 
	
	# Left door slides to the right, stopping at X: 0
	tween.tween_property(left_door, "position:x", 400, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		
	# Right door slides to the left, stopping exactly in the middle of the screen
	tween.tween_property(right_door, "position:x", 737.0, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	# ==========================================
	# 3. PHASE 2: THE IMPACT PAUSE
	# ==========================================
	tween.set_parallel(false) 
	tween.tween_callback(func():
		left_edge.visible = false
		right_edge.visible = false
	)
	tween.tween_interval(0.4) 
	# ==========================================
	# 4. PHASE 3: THE UI POPS UP
	# ==========================================
	tween.set_parallel(true)
	
	tween.tween_property(dark_overlay, "modulate:a", 0.6, 0.1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(ui_layer, "modulate:a", 1.0, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(ui_layer, "scale", Vector2(1.0, 1.0), 0.5)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
