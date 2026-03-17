extends ColorRect

enum Turn {
	PLAYER,
	ENEMY
}

#USER INTERFACE
@onready var player = $Player
@onready var enemy = $Enemy
@onready var endTurn_button = $"Battle UI/Endturn"
@onready var infoLabel: Label = $"Battle UI/Turn"
@onready var flip_button = $"Battle UI/PlayerHealthBar/Flip"
@onready var re_flip_button: Button = $"Battle UI/Re-Flip"
@onready var turn_calculation: Label = $"Battle UI/Turn Calculation"

@onready var player_health_bar = $"Battle UI/PlayerHealthBar"
@onready var player_health_label = $"Battle UI/PlayerHealthBar/HealthLabel"

@onready var enemy_health_bar = $"Battle UI/EnemyHealthBar"
@onready var enemy_health_label = $"Battle UI/EnemyHealthBar/EnemyHealthLabel"

#COIN DECK 
@onready var coin_deck: Node2D = $CoinDeck

#COIN
const COIN = preload("uid://ddet242jm5v23")

#CALCULATIONS
var damage = 0
var gain = 0
var debt = 0
var reserved_coin = null

var current_turn = Turn.PLAYER


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	flip_button.pressed.connect(_on_flip_pressed)
	endTurn_button.pressed.connect(_on_endturn_pressed)
	start_player_turn()

func start_player_turn():
	
	
	#Initialize Global Stats
	damage = 0
	gain = 0
	debt = 0
	
	#Coin Gain Triggers
	player.gain_coin()

	#Reset Player Stats
	player.current_flip = 0
	player.current_re_flip = 0
	
	#Check Coin Reserve

	if reserved_coin != null:
		var coin = COIN.instantiate()
		player.current_flip += 1
		coin.setup(reserved_coin.base_value,reserved_coin.state,coin_deck.get_vacant_slot(player.current_flip))
		coin.add_to_group("coins")
		add_child(coin);
		reserved_coin.queue_free()
	
	current_turn = Turn.PLAYER
	infoLabel.text = "Player Turn"
	flip_button.disabled = false
	re_flip_button.disabled = false
	endTurn_button.disabled = false
	turn_calculation.text = ""
	
	
func start_enemy_turn():
	
	#Initialize Stats
	damage = 0
	gain = 0
	debt = 0
	
	current_turn = Turn.ENEMY
	infoLabel.text = "Enemy Turn"
	turn_calculation.text = ""
	
	flip_button.disabled = true
	re_flip_button.disabled = true
	endTurn_button.disabled = true
	
	await get_tree().create_timer(1.0).timeout
	
	enemy_flip()

	
func enemy_attack():
	player.take_damage(1)
	update_player_coin()
	infoLabel.text = "Enemy attacks!"
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_endturn_pressed():
	
	enemy.take_damage(damage)
	update_enemy_coin()
	player.gain += gain
	reserve_left_over_coin()
	if current_turn == Turn.PLAYER:
		start_enemy_turn()
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if coin.reserved == false:
			coin.queue_free()


func _on_flip_pressed():
	if current_turn != Turn.PLAYER:
		return
		
	var state = randi() % 2
	player.current_flip += 1
	player.take_damage(1)
	var coin = COIN.instantiate()
	coin.setup(2,state,coin_deck.get_vacant_slot(player.current_flip))
	coin.add_to_group("coins")
	add_child(coin);
	
	
	print(player.current_flip)
	if player.current_flip == player.max_flip or player.coin == 1:
		flip_button.disabled = true
	coin_calculation()
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
	if player.coin <= 0:
		infoLabel.text = "Player Defeated"
		
	if enemy.coin <= 0:
		infoLabel.text = "Enemy Defeated"


func _on_re_flip_pressed() -> void:
	player.current_re_flip += 1
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		coin.re_flip()
	
	if player.current_re_flip == player.max_re_flip:
		re_flip_button.disabled = true
	coin_calculation()

func coin_calculation():
	var is_left = true # true - Left Coin, false - Right Coin
	var left_coin
	var right_coin
	damage = 0
	gain = 0
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		if is_left == true:
			left_coin = coin
		if is_left == false:
			right_coin = coin
		
		if left_coin != null and right_coin != null:
			# 1. HEAD-HEAD PAIR
			if left_coin.state == 0 and right_coin.state == 0:
				damage += (left_coin.base_value + right_coin.base_value)
			# 2. TAIL-TAIL PAIR
			elif left_coin.state == 1 and right_coin.state == 1:
				gain += (left_coin.base_value + right_coin.base_value)
			# 3. HEAD-TAIL PAIR
			elif left_coin.state == 0 and right_coin.state == 1:
				damage += (left_coin.base_value / 2)
				gain += (right_coin.base_value / 2)
			else:
				damage += (right_coin.base_value / 2)
				gain += (left_coin.base_value / 2)
			left_coin = null
			right_coin = null
		else:
			pass
		is_left = !is_left
	if damage != 0 or gain != 0:
		var text = "DMG: " + str(damage) + " GAIN: " + str(gain)
		turn_calculation.text = text

func reserve_left_over_coin():
	var is_left = true # true - Left Coin, false - Right Coin
	var left_coin
	var right_coin
	var coins = get_tree().get_nodes_in_group("coins")
	for coin in coins:
		
		if is_left == true:
			left_coin = coin
		if is_left == false:
			right_coin = coin
		
		if left_coin != null and right_coin != null:
			left_coin = null
			right_coin = null
		is_left = !is_left

	if left_coin != null and right_coin == null:
		left_coin.reserved = true
		left_coin.global_position = coin_deck.get_reserve_slot()
		reserved_coin = left_coin

func update_player_coin():
	player_health_bar.value = player.coin
	player_health_label.text = "Coins: " + str(player.coin)
	
func update_enemy_coin():
	enemy_health_bar.value = enemy.coin
	enemy_health_label.text = "Coins: " + str(player.coin)
