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
@onready var playerFlipLabel = $CanvasLayer/PlayerRecord
@onready var enemyFlipLabel = $CanvasLayer/EnemyRecord



var current_flips = []
var current_turn = Turn.PLAYER
var turn_counter = 0


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
		turn_counter += 1
		if current_flips.size() == 1:
			playerFlipLabel.text += current_flips[0] + "\n"
		
		current_flips.clear()
		
		if turn_counter >= 4:
			reset_records()
			turn_counter = 0
			
		start_enemy_turn()
		
func reset_records():
	playerFlipLabel.text = ""
	enemyFlipLabel.text = ""
	

func _on_flip_pressed():
	if current_turn != Turn.PLAYER:
		return
	
	# Flip one coin
	var coin = randi() % 2
	if coin == 0:
		current_flips.append("H")
	else:
		current_flips.append("T")
			
		
		player.take_damage(1)
	
	if current_flips.size() == 2:
		playerFlipLabel.text += current_flips[0] + current_flips[1] + "\n"
		infoLabel.text = evaluate_combo(current_flips, true)
		current_flips.clear()
		
	
	check_defeat()
	
	#if coin == 0:
		#playerFlipLabel.text += "H"
		#infoLabel.text = "Player got Heads!"
	#else:
		#playerFlipLabel.text += "T"
		#infoLabel.text = "Player got Tails!"
		
	
func enemy_flip():
	
	var num_flips = 2
	var flips = []
	for i in range(num_flips):
		var coin = randi() % 2
	
		
	
		if coin == 0:
			flips.append("H")
		else:
			flips.append("T")
			
		enemyFlipLabel.text += flips[-1]
		enemy.take_damage(1)
		await get_tree().create_timer(1.0).timeout
		
	if num_flips == 2:
		infoLabel.text = evaluate_combo(flips, false)
	else:
		infoLabel.text = "Enemy flipped: " + flips[0]
		
		
	enemyFlipLabel.text += "\n"
	check_defeat()
	start_player_turn()
	

func check_defeat():
	if player.health <= 0:
		infoLabel.text = "Player Defeated"
		
	if enemy.health <= 0:
		infoLabel.text = "Enemy Defeated"
		
func evaluate_combo(flips: Array, is_player: bool) -> String:
	if flips[0] == "H" and flips[1] == "H":
		if is_player:
			enemy.take_damage(4)
			return "Player Combo HH! Enemy takes 4 damage"
		else:
			player.take_damage(4)
			return "Enemy Combo HH! Player takes 4 damage"
	elif flips[0] == "T" and flips[1] == "T":
		if is_player:
			player.gain_health(4)
			return "Player Combo TT! Player gains 4 HP"
		else:
			enemy.gain_health(4)
			return "Enemy Combo TT! Enemy gains 4 HP"
	else:
		if is_player:
			enemy.take_damage(1)
			player.gain_health(1)
			return "Player Combo HT/TH! 1 Damage & 1 HP Gain"
		else:
			player.take_damage(1)
			enemy.gain_health(1)
			return "Enemy Combo HT/TH! 1 Damage & 1 HP Gain"
