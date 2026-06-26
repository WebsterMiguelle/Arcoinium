extends Control

# ==========================================
# ANIMATION & BACKGROUND NODES
# ==========================================
@onready var left_door: Control = $LeftSideBricks
@onready var right_door: Control = $RightSideBricks
@onready var left_edge: TextureRect = $LeftSideBricks/OpenTile
@onready var right_edge: TextureRect = $RightSideBricks/OpenTile
@onready var dark_overlay: ColorRect = $DarkOverlay
@onready var ui_layer: Control = $UILayer

# ==========================================
# LEFT PANEL NODES (Result & Passives)
# ==========================================
@onready var left_panel: PanelContainer = $UILayer/HBoxContainer/LeftPanel
@onready var left_vbox: VBoxContainer = $UILayer/HBoxContainer/LeftPanel/MarginContainer/VBoxContainer
@onready var end_result: Label = $UILayer/HBoxContainer/LeftPanel/MarginContainer/VBoxContainer/EndResult
@onready var mini_message: Label = $UILayer/HBoxContainer/LeftPanel/MarginContainer/VBoxContainer/Mini_message
@onready var passives_grid: GridContainer = $UILayer/HBoxContainer/LeftPanel/MarginContainer/VBoxContainer/PassivesGrid

# ==========================================
# RIGHT PANEL NODES (Stats)
# ==========================================
@onready var right_panel: PanelContainer = $UILayer/HBoxContainer/RightPanel
@onready var right_vbox: VBoxContainer = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer
@onready var statistics_title: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/StatisticsTitle

@onready var stats_container: VBoxContainer = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS
@onready var remaining_coins: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/RemainingCoins
@onready var highest_dmg: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/HighestDMG
@onready var total_dmg: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalDMG
@onready var highest_gain: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/HighestGAIN
@onready var total_gain: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalGAIN
@onready var enemies_defeated: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/EnemiesDefeated
@onready var sun_coins_flipped: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/SunCoinsFlipped
@onready var moon_coins_flipped: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/MoonCoinsFlipped
@onready var total_flips: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalFlips
@onready var total_reflips: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalReflips
@onready var total_reserve_coins: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/MarginContainer/STATISTICS/TotalReserveCoins

@onready var grade: Label = $UILayer/HBoxContainer/RightPanel/MarginContainer/VBoxContainer/Grade

# ==========================================
# DATA PRELOADS
# ==========================================
const PASSIVE_ICON = preload("res://Scene/Passive_Bar_Icon.tscn") 
var stat_sequence: Array = []


func _ready() -> void:
	# 1. Setup UI Layer initial state
	ui_layer.modulate.a = 0.0
	ui_layer.scale = Vector2(0.8, 0.8) 
	ui_layer.pivot_offset = ui_layer.size / 2 
	dark_overlay.modulate.a = 0.0
	
	# 2. Hide LEFT panel items
	for child in left_vbox.get_children():
		child.modulate.a = 0.0
	for child in passives_grid.get_children():
		child.modulate.a = 0.0

	# 3. Hide RIGHT panel items individually (so parent containers don't break)
	statistics_title.modulate.a = 0.0
	grade.modulate.a = 0.0
	for child in stats_container.get_children():
		child.modulate.a = 0.0

	# 4. Start the sequence
	play_slam_animation()

func play_slam_animation() -> void:
	# 1. Force Starting Positions
	right_edge.visible = true
	left_edge.visible = true
	left_door.position.x = -329
	right_door.position.x = 1476.0
	
	var tween = create_tween()
	
	# ==========================================
	# PHASE 1: THE DOORS SLAM INWARD
	# ==========================================
	tween.set_parallel(true) 
	
	tween.tween_property(left_door, "position:x", 400.0, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		
	tween.tween_property(right_door, "position:x", 737.0, 2.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)

	# ==========================================
	# PHASE 2: THE IMPACT PAUSE
	# ==========================================
	tween.set_parallel(false) 
	
	tween.tween_callback(func():
		left_edge.visible = false
		right_edge.visible = false
	)
	
	tween.tween_interval(0.4) 
	
	# ==========================================
	# PHASE 3: THE UI POPS UP
	# ==========================================
	tween.set_parallel(true)
	
	tween.tween_property(dark_overlay, "modulate:a", 0.6, 0.1)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(ui_layer, "modulate:a", 1.0, 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(ui_layer, "scale", Vector2(1.0, 1.0), 0.5)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	# ==========================================
	# PHASE 4: STAGGER THE CONTENTS (Left to Right)
	# ==========================================
	tween.set_parallel(false) 
	
	tween.tween_callback(func():
		# 1. Left Panel (Result + Message + Passives)
		var left_text_finish_time = stagger_pop_in(left_vbox, 0.0)
		var left_total_finish_time = stagger_pop_in(passives_grid, left_text_finish_time)
		
		# 2. Right Panel (Title)
		pop_in_single(statistics_title, left_total_finish_time)
		
		# 3. Right Panel (Counting Stats Sequence)
		var current_delay = left_total_finish_time + 0.2
		var stat_stagger = 0.15
		
		for stat_data in stat_sequence:
			animate_counting_stat(stat_data["label"], stat_data["prefix"], stat_data["val"], current_delay)
			current_delay += stat_stagger
			
		# 4. Right Panel (Final Grade)
		pop_in_single(grade, current_delay + 0.5) # Wait half a second after stats finish to show the grade!
	)

# ==========================================
# ANIMATION HELPERS
# ==========================================
func stagger_pop_in(container: Control, start_delay: float = 0.0) -> float:
	var delay = start_delay
	var stagger_time = 0.1
	
	for child in container.get_children():
		child.modulate.a = 0.0
		child.scale = Vector2(1.5, 1.5)
		child.pivot_offset = child.size / 2 
		
		var tween = create_tween().set_parallel(true)
		
		tween.tween_property(child, "modulate:a", 1.0, 0.3)\
			.set_delay(delay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			
		tween.tween_property(child, "scale", Vector2(1.0, 1.0), 0.4)\
			.set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			
		delay += stagger_time 
		
	return delay

func pop_in_single(node: Control, delay: float) -> void:
	node.modulate.a = 0.0
	node.scale = Vector2(1.5, 1.5)
	node.pivot_offset = node.size / 2 
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(node, "modulate:a", 1.0, 0.3)\
		.set_delay(delay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2(1.0, 1.0), 0.4)\
		.set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func animate_counting_stat(label: Label, prefix: String, target_value: int, delay: float) -> void:
	label.modulate.a = 0.0
	label.scale = Vector2(1.5, 1.5)
	label.pivot_offset = label.size / 2 
	label.text = prefix + "0" 
	
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(label, "modulate:a", 1.0, 0.3)\
		.set_delay(delay).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.4)\
		.set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	# The count up animation takes 0.8 seconds
	tween.tween_method(
		func(current_val: int): label.text = prefix + str(current_val),
		0, target_value, 0.8 
	).set_delay(delay).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

# ==========================================
# DATA HANDOFF (Called from main.gd)
# ==========================================
func setup(stats: Dictionary, player_won: bool, title_text: String, killer_text: String, passives_list: Array) -> void:
	end_result.text = title_text
	mini_message.text = killer_text
	
	# Package the target values for the animation to read
	stat_sequence = [
		{"label": remaining_coins, "prefix": "Remaining Coins: ", "val": stats["remaining_coins"]},
		{"label": highest_dmg, "prefix": "Highest DMG: ", "val": stats["highest_damage_dealt"]},
		{"label": total_dmg, "prefix": "Overall Total DMG: ", "val": stats["overall_total_damage"]},
		{"label": highest_gain, "prefix": "Highest GAIN: ", "val": stats["highest_gain"]},
		{"label": total_gain, "prefix": "Overall Total GAIN: ", "val": stats["overall_total_gain"]},
		{"label": enemies_defeated, "prefix": "Enemies Defeated: ", "val": stats["enemies_defeated"]},
		{"label": sun_coins_flipped, "prefix": "Sun Coins Flipped: ", "val": stats["heads"]},
		{"label": moon_coins_flipped, "prefix": "Moon Coins Flipped: ", "val": stats["tails"]},
		{"label": total_flips, "prefix": "Total Flips: ", "val": stats["flips"]},
		{"label": total_reflips, "prefix": "Re-Flips: ", "val": stats["reflips"]},
		{"label": total_reserve_coins, "prefix": "Total Reserve Coins: ", "val": stats["total_reserved_coins"]}
	]
	
	# Spawn the passive icons!
	for passive_id in passives_list:
		var icon = PASSIVE_ICON.instantiate()
		passives_grid.add_child(icon)
		if icon.has_method("setup"):
			icon.setup(passive_id)
