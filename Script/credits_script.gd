extends Control

# ==========================================
# CONFIGURATION
# ==========================================
@onready var credits_container: Control =  $VBoxContainer
# NEW: Add the path to your scroll sprite!
@onready var scroll_sprite: AnimatedSprite2D =  $AnimatedSprite2D
@onready var scroll_texture: TextureRect = $ScrollSpritew
@onready var game_title: Label = $"VBoxContainer/1/GameTitle"

@export var scroll_speed: float = 60.0 
@export var slide_distance: float = 40.0 

var last_stamped_char: int = 0

var unplayed_nodes: Array = []
var trigger_y: float = 0.0
var is_scrolling: bool = false 
var is_exiting: bool = false

func _ready() -> void: 
	mouse_filter = Control.MOUSE_FILTER_STOP
	scroll_sprite.visible = false
	scroll_texture.visible = true
	# 1. Set the trigger line near the bottom of the screen
	var screen_height = get_viewport_rect().size.y
	trigger_y = screen_height * 0.70 
	scroll_sprite.frame = 0
	# 2. Gather and prep the text nodes
	var all_nodes = get_all_visual_nodes(credits_container)
	for child in all_nodes:
		child.position.y += slide_distance
		child.modulate.a = 0.0
		unplayed_nodes.append(child)
		
	# 3. PLAY THE INTRO SEQUENCE
	await play_intro_sequence()

# ==========================================
# NEW: SCROLL INTRO SEQUENCE
# ==========================================
func play_intro_sequence() -> void:
	# 1. Remember the exact position and scale you set in the editor!
	var target_pos = scroll_texture.position
	var target_scale = scroll_texture.scale
	
	# 2. Force it off-screen to the LEFT and cut its scale in half
	scroll_texture.position.x -= 1500 
	scroll_texture.scale = target_scale * 0.5 
	
	# 3. Create the animation sequence
	var tween = create_tween()
	
	# STEP A: Slide in from the left to its target position
	# (TRANS_BACK makes it slightly overshoot and bounce into place)
	tween.tween_property(scroll_texture, "position:x", target_pos.x, 1.0)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	# STEP B: Enlarge to its full original scale
	# (Because we didn't use .set_parallel(true), this automatically waits for Step A to finish!)
	tween.tween_property(scroll_texture, "scale", target_scale, 0.6)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(scroll_texture, "position:y", 00, 1.0)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	# Wait for both the slide and the scale animations to finish
	await tween.finished
	scroll_sprite.visible = true
	scroll_texture.visible = false
	scroll_sprite.play("default")
	await scroll_sprite.animation_finished
	stamp_effect(game_title, 0.2)
	await get_tree().create_timer(0.8).timeout
	
	is_scrolling = true

# ==========================================
# THE MOVIE SCROLL
# ==========================================
func _process(delta: float) -> void:
	if not is_scrolling or is_exiting: 
		return

	# If the intro hasn't finished yet, do absolutely nothing!
	if not is_scrolling: 
		return
		
	# 1. Move BOTH the text container and the scroll sprite upwards
	credits_container.position.y -= scroll_speed * delta
	scroll_sprite.position.y -= scroll_speed * delta
	
	# 2. Check if nodes have crossed the invisible line
	# 2. THE STAGGER TRIGGER: Check if nodes have crossed the invisible line
	for i in range(unplayed_nodes.size() - 1, -1, -1):
		var node: Control = unplayed_nodes[i]
		
		if node.global_position.y <= trigger_y:
			#add if else here if you want to make a certain node have an animation of its own
			animate_in(node)
				
			unplayed_nodes.remove_at(i)
	if credits_container.position.y < -2100:
		queue_free()
	
# ==========================================
# INDIVIDUAL ENTRANCE ANIMATION
# ==========================================
func animate_in(node: Control) -> void:
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(node, "modulate:a", 1.0, 0.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	var target_y = node.position.y - slide_distance
	tween.tween_property(node, "position:y", target_y, 0.8)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

# ==========================================
# RECURSIVE SEARCH ALGORITHM
# ==========================================
func get_all_visual_nodes(parent: Node) -> Array:
	var visuals = []
	for child in parent.get_children():
		if child is Label or child is TextureRect or child is RichTextLabel or child is AnimatedSprite2D:
			visuals.append(child)
		if child.get_child_count() > 0:
			visuals.append_array(get_all_visual_nodes(child))
	return visuals
 
func stamp_effect(node: Control, duration: float = 0.1) -> void:
	# 1. Ensure the node scales from its center
	node.pivot_offset = node.size / 2.0
	
	# 2. Briefly scale up (the "impact")
	node.scale = Vector2(1.5, 1.5)
	
	# 3. Tween back to original size (the "settle")
	var tween = create_tween()
	
	tween.tween_property(node, "scale", Vector2.ONE, duration)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(node, "modulate:a", 1.0 , duration)
	
func _gui_input(event: InputEvent) -> void:
	# If we are already exiting, ignore any spam clicks
	if is_exiting:
		return
		
	# Check if the user clicked the Left Mouse Button
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		play_exit_sequence()
		
func play_exit_sequence() -> void:
	is_exiting = true # Lock out further interactions
	
	var screen_width = get_viewport_rect().size.x
	var tween = create_tween()
	
	# Slide the ENTIRE scene (self) off to the right side of the screen
	# We use TRANS_EXPO and EASE_IN so it starts slow and whips off screen really fast
	tween.tween_property(self, "position:x", screen_width + 200, 0.8)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		
	# Wait for the slide to finish, then delete the credits scene
	await tween.finished
	queue_free()
