extends CanvasLayer

signal node_selected(type)
@onready var player = $Background/PlayerPoint
@onready var battle_button = $Background/VBoxContainer/Enter
@onready var background = $Background

var start_index: int = 0


@onready var battle_points = [
	$Background/Enemy1,
	$Background/Enemy2,
	$Background/Enemy3,
	$Background/EliteEnemy,
	$Background/Shop,
	$Background/Boss
]




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func setup(current_room):
	player.global_position = battle_points[current_room].global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_battle_pressed() -> void:
	battle_button.disabled = true
	var tween = create_tween()
	tween.tween_property(background,"position:y",1000,0.4)
	tween.tween_callback(self.queue_free)
	
