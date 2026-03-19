extends Button

@onready var player_node: Node2D = $"../../Player"
@onready var coin_bar: HBoxContainer = $HBoxContainer

func _ready() -> void:
	if player_node:
		player_node.hp_changed.connect(_on_player_hp_changed)
		_update_visuals(player_node.coin)

func _on_player_hp_changed(new_hp: int) -> void:
	_update_visuals(new_hp)

func _update_visuals(current_hp: int) -> void:
	var coins = coin_bar.get_children()
	
	if current_hp > 20 :
		for i in range(coins.size()):
			coins[i].visible = true
	else:
		for i in range(coins.size()):
			if i < current_hp:
				coins[i].visible = true
			else:
				coins[i].visible = false
