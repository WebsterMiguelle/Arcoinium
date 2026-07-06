extends CanvasLayer
const GAME_OVER_WALL_CLOSE = preload("uid://dcogb5vig426m")
const GAME_OVER_WALL = preload("uid://cen1jkl1h44jj")
@onready var sound_manager: Node2D = $SoundManager

# ==========================================
# TRANSITION NODES
# ==========================================
@onready var left_door: Control = $LeftSideBricks
@onready var right_door: Control = $RightSideBricks
@onready var right_open_tile: TextureRect = $RightSideBricks/OpenTile
@onready var left_open_tile: TextureRect = $LeftSideBricks/OpenTile

# NEW: The Fade Rectangle
@onready var fade_rect: ColorRect = $FadeRect

var tutorial_advance_mode: bool = false
var tutorial_from_startup: bool = false

func _ready():
	layer = 100 
	
	# Setup Doors
	right_open_tile.visible = true
	left_open_tile.visible = true
	var screen_width = get_viewport().get_visible_rect().size.x
	left_door.position.x = -left_door.size.x - 140
	right_door.position.x = screen_width + 140
	
	# Setup Fade Rect
	fade_rect.modulate.a = 0.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	GameSettings.apply_lights_to_group()

# ==========================================
# ANIMATION HELPERS (DOORS)
# ==========================================
func _slam_doors_shut() -> Tween:
	var screen_width = get_viewport().get_visible_rect().size.x
	var half_screen = screen_width / 2.0
	var left_door_width = left_door.size.x
	
	var overlap_correction = 15.0 
	
	left_door.visible = true
	right_door.visible = true
	
	var tween = create_tween()
	
	sound_manager.play_sound(GAME_OVER_WALL)
	
	tween.set_parallel(true)
	tween.tween_property(left_door, "position:x", half_screen - left_door_width, 1.5)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(right_door, "position:x", half_screen, 1.5)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	tween.set_parallel(false)
	tween.tween_callback(func():
		sound_manager.play_sound(GAME_OVER_WALL_CLOSE)
		right_open_tile.visible = false
		left_open_tile.visible = false
		
		left_door.position.x = (half_screen - left_door_width) + overlap_correction
		right_door.position.x = half_screen - overlap_correction
	)
	
	return tween
	
func _open_doors() -> Tween:
	var screen_width = get_viewport().get_visible_rect().size.x
	var half_screen = screen_width / 2.0
	var left_door_width = left_door.size.x
	
	left_door.position.x = half_screen - left_door_width
	right_door.position.x = half_screen
	
	right_open_tile.visible = true
	left_open_tile.visible = true
	
	var tween = create_tween().set_parallel(true)
	
	sound_manager.play_sound(GAME_OVER_WALL)
	
	tween.tween_property(left_door, "position:x", -left_door_width - 160, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(right_door, "position:x", screen_width + 160, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	return tween

# ==========================================
# ANIMATION HELPERS (FADE)
# ==========================================
func _fade_out(duration: float = 0.5) -> Tween:
	# Block clicks while fading
	fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP 
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	return tween

func _fade_in(duration: float = 0.5) -> Tween:
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
	# Allow clicks again once fully invisible
	tween.tween_callback(func(): fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE)
	return tween

# ==========================================
# SCENE MANAGEMENT (DOORS)
# ==========================================
func load_scene(target_scene: String):
	if "tutorial_main" not in target_scene:
		tutorial_advance_mode = false
		
	get_tree().root.gui_disable_input = true
	
	var slam_tween = _slam_doors_shut()
	await slam_tween.finished
	
	get_tree().change_scene_to_file(target_scene)
	await get_tree().process_frame
	_sync_toggle_settings()
	
	var open_tween = _open_doors()
	await open_tween.finished
	
	get_tree().root.gui_disable_input = false

func reload_scene():
	get_tree().root.gui_disable_input = true

	var slam_tween = _slam_doors_shut()
	await slam_tween.finished
	
	get_tree().reload_current_scene() 
	await get_tree().process_frame
	_sync_toggle_settings()
	
	var open_tween = _open_doors()
	await open_tween.finished
	
	get_tree().root.gui_disable_input = false
	
func change_scene_from_closed(target_scene: String):
	if "tutorial_main" not in target_scene:
		tutorial_advance_mode = false
		
	get_tree().root.gui_disable_input = true
	
	var screen_width = get_viewport().get_visible_rect().size.x
	var half_screen = screen_width / 2.0
	var left_door_width = left_door.size.x
	var overlap_correction = 15.0 
	
	left_door.visible = true
	right_door.visible = true
	left_open_tile.visible = false
	right_open_tile.visible = false
	
	left_door.position.x = (half_screen - left_door_width) + overlap_correction
	right_door.position.x = half_screen - overlap_correction
	
	get_tree().change_scene_to_file(target_scene)
	await get_tree().process_frame
	_sync_toggle_settings()
	
	var open_tween = _open_doors()
	await open_tween.finished
	
	get_tree().root.gui_disable_input = false

func reload_scene_from_closed():
	get_tree().root.gui_disable_input = true
	
	var screen_width = get_viewport().get_visible_rect().size.x
	var half_screen = screen_width / 2.0
	var left_door_width = left_door.size.x
	var overlap_correction = 15.0 
	
	left_door.visible = true
	right_door.visible = true
	left_open_tile.visible = false
	right_open_tile.visible = false
	
	left_door.position.x = (half_screen - left_door_width) + overlap_correction
	right_door.position.x = half_screen - overlap_correction
	
	get_tree().reload_current_scene() 
	await get_tree().process_frame
	_sync_toggle_settings()
	
	var open_tween = _open_doors()
	await open_tween.finished
	
	get_tree().root.gui_disable_input = false

# ==========================================
# SCENE MANAGEMENT (FADE)
# ==========================================
func load_scene_fade(target_scene: String, fade_time: float = 0.5):
	if "tutorial_main" not in target_scene:
		tutorial_advance_mode = false
		
	get_tree().root.gui_disable_input = true
	
	var fade_out_tween = _fade_out(fade_time)
	await fade_out_tween.finished
	
	get_tree().change_scene_to_file(target_scene)
	await get_tree().process_frame
	_sync_toggle_settings()
	
	var fade_in_tween = _fade_in(fade_time)
	await fade_in_tween.finished
	
	get_tree().root.gui_disable_input = false

func reload_scene_fade(fade_time: float = 0.5):
	get_tree().root.gui_disable_input = true
	
	var fade_out_tween = _fade_out(fade_time)
	await fade_out_tween.finished
	
	get_tree().reload_current_scene()
	await get_tree().process_frame
	_sync_toggle_settings()

	var fade_in_tween = _fade_in(fade_time)
	await fade_in_tween.finished
	
	get_tree().root.gui_disable_input = false

# ==========================================
# UTILITIES
# ==========================================
func _sync_toggle_settings() -> void:
	GameSettings.apply_lights_to_group()
	GameSettings.apply_particles_to_group()
