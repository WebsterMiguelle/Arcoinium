extends ColorRect

enum Turn {
	PLAYER,
	ENEMY
}

@onready var player = $Player
@onready var enemy = $Enemy
@onready var endTurn_button = $CanvasLayer/Endturn
@onready var infoLabel = $CanvasLayer/EndturnLabel
@onready var flip_button = $CanvasLayer/Flip



var current_turn = Turn.PLAYER


# Called when the node enters the scene tree for the first time.
func _ready():
	start_player_turn()
	randomize()
	
	flip_button.pressed.connect(_on_flip_pressed)
	endTurn_button.pressed.connect(_on_endturn_pressed)
	


func start_player_turn():
	current_turn = Turn.PLAYER
	infoLabel.text = "Player Turn"
	flip_button.disabled = false
	endTurn_button.disabled = false
	
func start_enemy_turn():
	current_turn = Turn.ENEMY
	infoLabel.text = "Enemy Turn"
	
	flip_button.disabled = true
	endTurn_button.disabled = true
	
	await get_tree().create_timer(1.0).timeout
	
	enemy_flip()

	
func enemy_attack():
	player.take_damage(1)
	infoLabel.text = "Enemy attacks!"
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_endturn_pressed():
	if current_turn == Turn.PLAYER:
		start_enemy_turn()


func _on_flip_pressed():
	if current_turn != Turn.PLAYER:
		return
		
	var coin = randi() % 2
	
	if coin == 0:
		infoLabel.text = "Player got Heads! Player loses 1 HP"
		player.take_damage(1)
	else:
		infoLabel.text = "Player got Tails! Enemy loses 1 HP"
		enemy.take_damage(1)
		
	check_defeat()
	
		
	
func enemy_flip():
	
	var coin = randi() % 2
	
	if coin == 0:
		infoLabel.text = "Enemy got Heads! Player loses 1 HP"
		player.take_damage(1)
	else:
		infoLabel.text = "Enemy got Tails! Enemy loses 1 HP"
		enemy.take_damage(1)
	
	check_defeat()
	await get_tree().create_timer(1.0).timeout
	start_player_turn()
	

func check_defeat():
	if player.health <= 0:
		infoLabel.text = "Player Defeated"
		
	if enemy.health <= 0:
		infoLabel.text = "Enemy Defeated"
