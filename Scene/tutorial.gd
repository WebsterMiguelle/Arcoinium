extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a",1,0.2)
	tween.parallel().tween_property(self,"position:y",global_position.y - 50, 0.2)
	
func setup(tit, txt, pos, offset):
	var tutorial_name: Label = $"Tutorial Panel/MarginContainer/VBoxContainer/Tutorial Name"
	var tutorial_info: Label = $"Tutorial Panel/MarginContainer/VBoxContainer/Tutorial Info"
	tutorial_name.text = tit
	tutorial_info.text = txt
	global_position = pos
	global_position.y += offset

func close():
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a",0,0.2)
	tween.parallel().tween_property(self,"position:y",global_position.y + 10, 0.2)
	await get_tree().create_timer(0.8).timeout
	queue_free()
