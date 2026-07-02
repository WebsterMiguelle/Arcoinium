extends CanvasLayer
const GAME_OVER_WALL_CLOSE = preload("uid://dcogb5vig426m")
const GAME_OVER_WALL = preload("uid://cen1jkl1h44jj")
@onready var sound_manager: Node2D = $SoundManager
# ==========================================
# DOOR NODES (Update these paths to match your scene!)
# ==========================================
@onready var left_door: Control = $LeftSideBricks
@onready var right_door: Control = $RightSideBricks
@onready var right_open_tile: TextureRect = $RightSideBricks/OpenTile
@onready var left_open_tile: TextureRect = $LeftSideBricks/OpenTile

var tutorial_advance_mode: bool = false
var tutorial_from_startup: bool = false

func _ready():
	layer = 100 
	right_open_tile.visible = true
	left_open_tile.visible = true
	var screen_width = get_viewport().get_visible_rect().size.x
	left_door.position.x = -left_door.size.x - 140
	right_door.position.x = screen_width + 140

# ==========================================
# ANIMATION HELPERS
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
	
	# 3. Play the grinding stone sound as they pull apart
	sound_manager.play_sound(GAME_OVER_WALL)
	
	tween.tween_property(left_door, "position:x", -left_door_width - 160, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(right_door, "position:x", screen_width + 160, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	return tween
# ==========================================
# SCENE MANAGEMENT
# ==========================================
func load_scene(target_scene: String):
	if "tutorial_main" not in target_scene:
		tutorial_advance_mode = false
		
	get_tree().root.gui_disable_input = true
	
	var slam_tween = _slam_doors_shut()
	await slam_tween.finished
	
	get_tree().change_scene_to_file(target_scene)
	
	var open_tween = _open_doors()
	await open_tween.finished
	
	get_tree().root.gui_disable_input = false

func reload_scene():

	get_tree().root.gui_disable_input = true

	var slam_tween = _slam_doors_shut()
	await slam_tween.finished
	
	get_tree().reload_current_scene() 
	
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
	
	var open_tween = _open_doors()
	await open_tween.finished
	
	get_tree().root.gui_disable_input = false
