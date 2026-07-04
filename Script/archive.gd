extends ColorRect

@onready var sound_manager: Node2D = $SoundManager
const BUTTON = preload("uid://bwn6ufooc31uy")
const SCROLL_OPEN = preload("uid://ciyhsb2lowwtt")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	sound_manager.play_sound(BUTTON)
	SceneTransition.load_scene("res://Scene/Shop_keepers Room.tscn")


func _on_info_button_pressed() -> void:
	sound_manager.play_sound(BUTTON)
	SceneTransition.load_scene("res://Scene/profile.tscn")


func _on_passive_button_pressed() -> void:
	sound_manager.play_sound(BUTTON)
	SceneTransition.load_scene("res://Scene/passive_archive.tscn")


func _on_spell_status_button_pressed() -> void:
	sound_manager.play_sound(BUTTON)
	SceneTransition.load_scene("res://Scene/status_spell_archive.tscn")
