extends CanvasLayer

signal node_selected(type)
@onready var player = $Background/PlayerPoint
@onready var battle_button = $Background/VBoxContainer/Battle
@onready var background = $Background

var start_index: int = 0

@onready var battle_points = [
	$Background/Enemy1,
	$Background/Enemy2,
	$Background/Enemy3,
	$Background/Enemy4,
	$Background/Enemy5,
	$Background/Enemy6,
	$Background/Enemy7,
	$Background/Enemy8
]

var current_index = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position = battle_points[current_index].position
	get_tree().paused = true

func move_to_next_enemy():
	if current_index >= battle_points.size() - 1:
		print("Reached last boss!")
		return
		
	current_index += 1
	
	var target_pos = battle_points[current_index].position
	var offset = target_pos - player.position
	
	var tween = create_tween().set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	tween.tween_property(player, "position", target_pos, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(background, "position", background.position - offset, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	return tween
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func advance_and_wait():
	#move_to_next_enemy()
	battle_button.disabled = true
	await get_tree().create_timer(1.5).timeout
	battle_button.disabled = false
	
	# Now wait for player to press a button
	var choice = await node_selected
	return choice

func _on_battle_pressed() -> void:
	#move_to_next_enemy()
	print("clicked")
	battle_button.disabled = true
	
	var tween = move_to_next_enemy()
	if tween:
		await get_tree().create_timer(1.5).timeout
	
	emit_signal("node_selected", "battle")
	queue_free()
	
func _on_shop_pressed():
	emit_signal("node_selected", "shop")
	queue_free()
	
func close():
	get_tree().paused = false
	queue_free()
