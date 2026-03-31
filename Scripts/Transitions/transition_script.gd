extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	color_rect.visible = true 
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.material.set_shader_parameter("circle_size", 1.05)
		
func load_scene(target_scene: String):
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target_scene)
	animation_player.play_backwards("Fade")
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func reload_scene():
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().reload_current_scene() 
	animation_player.play_backwards("Fade")
	await animation_player.animation_finished
	
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
