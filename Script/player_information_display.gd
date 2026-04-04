extends HBoxContainer

var is_closing: bool = false
var slide_distance: float = 30.0 
var target_y: float
var stagger_delay: float = 0.1

func _ready() -> void:
	for child in get_children():
		child.modulate.a = 0.0

func open() -> void:
	target_y = global_position.y
	global_position.y += slide_distance
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position:y", target_y, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var delay = 0.0
	for child in get_children():
		tween.tween_property(child, "modulate:a", 1.0, 0.3).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		delay += stagger_delay

func close() -> void:
	if is_closing: return
	is_closing = true
	var tween = create_tween().set_parallel(true)
	var children = get_children()
	children.reverse()
	var delay = 0.0
	for child in children:
		tween.tween_property(child, "modulate:a", 0.0, 0.2).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		delay += stagger_delay
	tween.tween_property(self, "global_position:y", target_y + slide_distance, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(self.queue_free)
