extends Control

# Changed from Node2D to Node because your Enemy script "extends Node"
@onready var enemy_node = $"../../Enemy"
@onready var coin_bar: HBoxContainer = $HBoxContainer

# Tracks what the UI is currently showing
var current_displayed_hp: int = 0 

func _ready() -> void:
	if enemy_node:
		# Set up the exact amount of coins on load
		_initialize_visuals(enemy_node.coin) 

# --- NEW: The Watcher ---
# Because the Enemy script doesn't have signals, we check the health every frame.
func _process(_delta: float) -> void:
	if enemy_node:
		# If the enemy's actual coin count doesn't match our UI, trigger the update!
		if enemy_node.coin != current_displayed_hp:
			_on_hp_changed(enemy_node.coin)

# --- 1. INITIAL SETUP ---
func _initialize_visuals(starting_hp: int) -> void:
	current_displayed_hp = starting_hp
	var slots = coin_bar.get_children()
	
	for i in range(slots.size()):
		var slot = slots[i]
		if i < starting_hp:
			slot.visible = true
			slot.modulate.a = 1.0
			slot.position.y = 0
		else:
			slot.visible = false

# --- 2. THE LOGIC ---
func _on_hp_changed(new_hp: int) -> void:
	var slots = coin_bar.get_children()
	
	# SCENARIO A: The enemy lost coins (Took Damage)
	if new_hp < current_displayed_hp:
		for i in range(current_displayed_hp - 1, new_hp - 1, -1):
			if i >= 0 and i < slots.size():
				_animate_damage(slots[i])
				
	# SCENARIO B: The enemy gained coins (Healed/Spawned)
	elif new_hp > current_displayed_hp:
		for i in range(current_displayed_hp, new_hp):
			if i >= 0 and i < slots.size():
				var slot = slots[i]
				slot.visible = true
				slot.modulate.a = 1.0
				slot.position.y = 0
				var sprite = slot.get_child(0) as AnimatedSprite2D
				sprite.play("Sun_Static")
				
	# Instantly update our tracker so we don't trigger the animation twice
	current_displayed_hp = new_hp

# --- 3. THE ANIMATION ---
func _animate_damage(slot: Control) -> void:
	var sprite = slot.get_child(0) as AnimatedSprite2D
	
	var active_tween = create_tween()
	active_tween.tween_property(slot, "position:y", -20.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	active_tween.parallel().tween_property(slot, "modulate:a", 0.0, 0.25).set_ease(Tween.EASE_IN)
	
	sprite.play("Flipped Sun to Sun") 
	
	await sprite.animation_finished
	
	slot.visible = false
	slot.position.y = 0 
	slot.modulate.a = 1.0 # Reset alpha for when it heals
	sprite.play("Sun_Static")
