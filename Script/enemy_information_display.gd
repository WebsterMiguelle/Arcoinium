extends HBoxContainer

enum Status{
	GAIN,
	DEBT,
	THRIFT,
	SPEND,
	
	DROWSE,
	VOIDED,
	TALLY,
	STARSTRUCK,
	SEALED,
	SUNLIT_CURSE,
	MOONLIT_CURSE,
	SOLAR_BLESSED,
	LUNAR_BLESSED,
	
	BENCHMARK,
	AUDIT,
	SETTLE,
	EMPOWERED,
	RADIANT,
	
	MOMENTUM,
	TRUST,
	UNCHARGABLE
}

const STATUS_EFFECT = preload("uid://bmy7mewa8qp5l")

# --- LEFT PANEL (Enemy Lore) ---
# Update these paths to match exactly where your labels are in the EnemyLore container!
@onready var enemy_name: Label = $ProfilePanel/MarginContainer/VBoxContainer/EnemyName
@onready var enemy_stats: Label = $ProfilePanel/MarginContainer/VBoxContainer/HBoxContainer/EnemyStats
@onready var portrait: AnimatedSprite2D = $ProfilePanel/MarginContainer/VBoxContainer/HBoxContainer/Portrait
@onready var story_label: Label = $ProfilePanel/MarginContainer/VBoxContainer/EnemyLore
@onready var status_container: VFlowContainer = $StatusEffectsPanel/MarginContainer/StatusContainer

# --- MIDDLE PANEL (Status Effects) ---

# --- RIGHT PANEL (Mechanics) ---
@onready var enemy_ability: Label =$EnemyMechanics/MarginContainer/VBoxContainer/EnemyAbility
@onready var player_tip: Label =$EnemyMechanics/MarginContainer/VBoxContainer/PlayerTip

var is_closing: bool = false
var is_open: bool = false
var slide_distance: float = 30.0 
var target_y: float
var stagger_delay: float = 0.1
var enemy_node
# ==========================================
# THE ENEMY DATABASE
# Keys map directly to your Enemy enum (0 = MAGE, 1 = DWARF, etc.)
# ==========================================
var ENEMY_DATA = {
	0: { # MAGE
		"name": "Apprentice Mage",
		"story": "Apprentice Mages are not much of a threat, often blinded by their desperation to become like their masters.",
		"ability": "Flips standard coins. Simple and predictable.",
		"tip": "A great target to build your RESERVE against!",
		"greed":"Much more aggresive in flipping. Applies SPEND for each SUN Flip.",
		"greed tip": "Don't overspend your first few turns. GAIN Coins first to build momentum."
	},
	1: { # DWARF
		"name": "Coin Dwarf",
		"story": "Generally pleasant unless provoked. Do not get in the way of them and their coins.",
		"ability": "SUN pairs deal combined damage.",
		"tip": "Watch out for HEAD-HEAD pairs dealing massive damage.",
		"greed": "Flips more Coins than usual. Applies THRIFT for each MOON Flip.",
		"greed tip": "THRIFT reduces max playable coins. Make every Coin Pair count."
	},
	2: { # COLLECTOR
		"name": "Tax Collector",
		"story": "Questionable forms of tax collections, often overlooked by The Council. Best not to offend them.",
		"ability": "SUN-MOON Pairs apply DEBT. Whenever you settle your DEBT, he self-applies GAIN.",
		"tip": "It's better to play aggresively. GAINing may cause lifesteal if you have current DEBT!",
		"greed": "Applies DEBT that can lifesteal. Additionally STAMPs your Odd Coin Flips.",
		"greed tip": "He will try to limit your board control. Utilize RESERVE to strategize upcoming Odd Flips."
	},
	3: { # TRADER
		"name": "Trader",
		"story": "Mysteriously comes in and out of towns trying to settle infamously striking deals.",
		"ability": "Copies your number of played coins.",
		"tip": "You can hide some of your Coins in the Reserve. These are not counted as Played Coins.",
		"greed": "Copies your number of played coins. This time, he will VOID your Reserve.",
		"greed tip": "No more hiding Coins in the Reserve. Play fair and square, and control your Flip Count!"
	},
	4: { # THRIFTER
		"name": "Thrifter",
		"story": "Known to rarely come out of their home, unless they really, really need to. Had an interesting encounter with a Trader once.",
		"ability": "Applies THRIFT on SUN Pairs.",
		"tip": "He will try to limit your Max Coin Flips. Make each Coin Pair count.",
		"greed": "SUN Pairs apply THRIFT. MOON Pairs apply TALLY.",
		"greed tip": "Tally is Stackable. You can RESERVE Coins in advance if you have no Tally."
	},
	5: { # ARISTOCRAT
		"name": "Aristocrat",
		"story": "Aside from their over-inflated ego, Aristocrats are nothing more than a boot-licking pawn of The Council.",
		"ability": "Starts with massive DEBT. If DEBT reaches 0, you lose.",
		"tip": "Play as aggressive as possible. She cannot deal damage but will attempt to clear her DEBT quickly!",
		"greed": "You instantly perish if her DEBT reaches 0. Applies STARSTRUCK at the end of her turn.",
		"greed tip": "When Coins are DAZZLED, carefully set it up to be MOON to deal more damage."
	},
	6: { # SUN_CASTER
		"name": "Sun Caster",
		"story": "A corrupted vessel of the sun who both reflect the same arrogance, power, and greed.",
		"ability": "Powers up if you play 9 or more SUN coins.",
		"tip": "Limit your SUN coin usage. Pivot to MOON coins to starve their power.",
		"greed": "GUARANTEED SUN FLIP Curse. Powers up if you play 9 or more SUN Coins.",
		"greed tip": "Utilize Re-Flips and careful Flip Count to avoid the 9 SUN activation."
	},
	7: { # MOON_CASTER
		"name": "Moon Caster",
		"story": "A chosen vessel of the corruption of the moon due to their greed, often seen seeking a fight from Sun Caster.",
		"ability": "Powers up if you play 9 or more MOON coins.",
		"tip": "Limit your MOON coin usage. Focus on SUN damage to win.",
		"greed": "GUARANTEED MOON FLIP Curse. Powers up if you play 9 or more MOON Coins.",
		"greed tip": "Utilize Re-Flips and careful Flip Count to avoid the 9 MOON activation."
	},
	8: { # TWILIGHT_SAGE
		"name": "Twilight Sage",
		"story": "Merely a vessel for the opposing forces in the Twilight Zone, but was once a great and powerful mage.",
		"ability": "Alternates between Dawn and Dusk stances.",
		"tip": "Pay attention to the background color! Play MOON during Dawn, and SUN during Dusk.",
		"greed": "Switches between Dawn and Dusk. Applies DROWSE during Dawn, and VOIDED during Dusk.",
		"greed tip": "Time your combo accordingly. Some turns will have a Locked Reserve, some have ineffective Re-Flips."
	},
	9:{ # SHOPKEEPER
		"name": "Shopkeeper",
		"story": "As pleasant a companion as she is a business woman, but everything else about her is unknown.",
		"ability": "Flips coins to cast basic spells.",
		"tip": "Learn on balancing DAMAGE and GAIN. Avoid losing all coins. Defeat her to win.",
	}
}
func _ready() -> void:
	for child in get_children():
		child.modulate.a = 0.0
		
func setup(enemy: Node) -> void:
	enemy_node = enemy
	var type_id = enemy_node.type # Grabs the enum integer (0-8)
	var data = ENEMY_DATA[type_id]
	
	# ==========================================
	# 1. POPULATE STATIC LORE & TIPS
	# ==========================================
	enemy_name.text = data["name"] 
	if enemy_node.greed:
		data["ability"] = data["greed"]
		data["tip"] = data["greed tip"]
	# Pass in the Label, the Text, the Max Height (e.g., 180 pixels), and Default Font Size
	set_and_shrink_text(story_label, data["story"], 250.0, 32)
	set_and_shrink_text(enemy_ability, data["ability"], 120.0, 32)
	set_and_shrink_text(player_tip, data["tip"], 100.0, 32)
	
	# ==========================================
	# 2. POPULATE LIVE COMBAT STATS
	# ==========================================
	var stats_text = ""
	stats_text += "Coins: " + str(enemy_node.coin) + " / " + str(enemy_node.max_coin) + "\n"
	stats_text += "Silver Flip Rate: " + str(int(enemy_node.silver_flip_rate * 100)) + "%\n"
	stats_text += "Gold Flip Rate: " + str(int(enemy_node.gold_flip_rate * 100)) + "%\n"
	stats_text += "Max Flip: " + str(enemy_node.max_playable_coins) + "\n"
	# Give the stats block its own max height as well
	set_and_shrink_text(enemy_stats, stats_text, 100.0, 32)
	portrait.play(str(enemy_node.type))
	
	# ==========================================
	# 3. POPULATE STATUS EFFECTS
	# ==========================================
	if enemy_node.has_benchmark:
		print("I AM TRADER")
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.BENCHMARK,1)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
	if enemy_node.has_audit:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.AUDIT,1)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
	if enemy_node.settle > 0:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.SETTLE,enemy_node.settle)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
	if enemy_node.has_radiant:
		var s = STATUS_EFFECT.instantiate()
		if enemy_node.greed:s.set_status(Status.RADIANT,1)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
	if enemy_node.has_empowered:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.EMPOWERED,1)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
	if enemy_node.unchargable:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.UNCHARGABLE,1)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
		
	if enemy_node.gain > 0:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.GAIN,enemy_node.gain)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
		print("I AM GAINING")
	if enemy_node.debt > 0:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.DEBT,enemy_node.debt)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
	if enemy_node.thrift > 0:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.THRIFT,enemy_node.thrift)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
	if enemy_node.spend > 0:
		var s = STATUS_EFFECT.instantiate()
		s.set_status(Status.SPEND,enemy_node.spend)
		s.add_to_group("enemy_status")
		status_container.add_child(s)
		
	
func open() -> void:
	target_y = global_position.y
	global_position.y += slide_distance
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position:y", target_y, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var delay = 0.0
	for child in get_children():
		tween.tween_property(child, "modulate:a", 1.0, 0.3).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		delay += stagger_delay
	tween.chain().tween_callback(func(): is_open = true)

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
	
func _input(event: InputEvent) -> void:
	if is_open and not is_closing:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var menu_box = get_global_rect()
			var mouse_pos = get_global_mouse_position()
			if not menu_box.has_point(mouse_pos):
				close()
				get_viewport().set_input_as_handled()
				
func set_and_shrink_text(label: Label, new_text: String, max_height: float, default_font_size: int = 16) -> void:
	label.text = new_text
	var current_size = default_font_size
	
	var font = label.get_theme_font("font")
	
	var max_width = label.size.x
	if max_width == 0: 
		max_width = label.custom_minimum_size.x
		
	var text_height = font.get_multiline_string_size(new_text, HORIZONTAL_ALIGNMENT_LEFT, max_width, current_size).y
	
	while text_height > max_height and current_size > 24:
		current_size -= 2
		text_height = font.get_multiline_string_size(new_text, HORIZONTAL_ALIGNMENT_LEFT, max_width, current_size).y
		
	label.add_theme_font_size_override("font_size", current_size)
	label.custom_minimum_size.y = max_height
