extends TextureRect

var target_x
var is_already_calculating

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	target_x = global_position.x

func entrance(is_calcu):
	if !is_already_calculating:
		visible = true
		global_position.x = target_x - 10
		modulate.a = 0
		
		var tween = create_tween()
		tween.parallel().tween_property(self,"position:x",target_x,0.2)
		tween.parallel().tween_property(self,"modulate:a",1,0.2)
		is_already_calculating = is_calcu

func exit():
	is_already_calculating = false
	var tween = create_tween()
	tween.parallel().tween_property(self,"position:x",target_x-10,0.2)
	tween.parallel().tween_property(self,"modulate:a",0,0.2)
	await get_tree().create_timer(0.3).timeout
	visible = false

	
