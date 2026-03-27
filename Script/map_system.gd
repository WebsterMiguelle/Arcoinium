extends CanvasLayer

signal node_selected(type)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_battle_pressed() -> void:
	emit_signal("node_selected", "battle")
	queue_free()
	
func _on_shop_pressed():
	emit_signal("node_selected", "shop")
	queue_free()
	
func close():
	get_tree().paused = false
	queue_free()
