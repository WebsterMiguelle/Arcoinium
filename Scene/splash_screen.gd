extends Node2D

@onready var foreground: TextureRect = $CanvasLayer/Foreground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	var fade_tween = create_tween()
	fade_tween.tween_property(foreground,"self_modulate",Color("#ffffff00"),1.0)
	await get_tree().create_timer(3.0).timeout
	fade_tween = create_tween()
	fade_tween.tween_property(foreground,"self_modulate",Color.WHITE,1.0)
	await fade_tween.finished
	SceneTransition.load_scene("res://Scene/Main_Menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
