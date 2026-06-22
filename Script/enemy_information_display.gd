extends HBoxContainer


# --- LEFT PANEL (Enemy Lore) ---
# Update these paths to match exactly where your labels are in the EnemyLore container!
@onready var enemy_name: Label = $ProfilePanel/MarginContainer/VBoxContainer/EnemyName
@onready var enemy_stats: Label = $ProfilePanel/MarginContainer/VBoxContainer/EnemyStats

@onready var story_label: Label = $ProfilePanel/MarginContainer/VBoxContainer/EnemyLore

# --- MIDDLE PANEL (Status Effects) ---
@onready var gain: Label = $StatusEffectsPanel/MarginContainer/VBoxContainer/Gain
@onready var debt: Label = $StatusEffectsPanel/MarginContainer/VBoxContainer/Debt
@onready var thrift: Label = $StatusEffectsPanel/MarginContainer/VBoxContainer/Thrift


# --- RIGHT PANEL (Mechanics) ---
@onready var enemy_ability: Label =$EnemyMechanics/MarginContainer/VBoxContainer/EnemyAbility
@onready var player_tip: Label =$EnemyMechanics/MarginContainer/VBoxContainer/PlayerTip

var is_closing: bool = false
var is_open: bool = false
var slide_distance: float = 30.0 
var target_y: float
var stagger_delay: float = 0.1
# ==========================================
# THE ENEMY DATABASE
# Keys map directly to your Enemy enum (0 = MAGE, 1 = DWARF, etc.)
# ==========================================
const ENEMY_DATA = {
	0: { # MAGE
		"name": "Mage",
		"story": "Apprentice mages are mages in training, taken in by a more powerful mage as their own. Be it out of pity or the goodness of the mages' heart, no one ever knows. They say there is a chance for an apprentice mage to take over their masters' repertoire. But being taken in is already a telling sign that it's all they will ever be. It is not surprising if an apprentice mage suddenly disappears, stricken with the grief of not being something more.They're not much of a threat, but they will try to take down whoever threatens their masters' seats in power.",
		"ability": "Flips standard coins. Simple and predictable.",
		"tip": "A great target to build your Reserve against!"
	},
	1: { # DWARF
		"name": "Dwarf",
		"story": "Coin dwarves are generally pleasant, unless provoked. They spend most of their days searching for coins that have been tossed out in hopes to add it to their stash.
	However, when they get desperate, they may target whoever they think exudes an abundance of coins. Some say they are what becomes of the missing apprentice mages after losing their minds – destined to search for a value that isn’t there anymore.
",
		"ability": "SUN pairs deal combined damage. MOON flips apply THRIFT in Greed mode.",
		"tip": "Watch out for HEAD-HEAD pairs dealing massive damage."
	},
	2: { # COLLECTOR
		"name": "Collector",
		"story": "Obsessed with rare coins, they will tax you for every flip.",
		"ability": "Value Added Tax. Mixed pairs (SUN/MOON) apply DEBT.",
		"tip": "Avoid playing mixed pairs, and beware of their high Silver/Gold flip rates!"
	},
	3: { # TRADER
		"name": "Trader",
		"story": "A merchant of equivalence. What you give is what you get.",
		"ability": "Fair Trade: Copies your number of played coins.",
		"tip": "If you play aggressively, the Trader hits back just as hard. Control your flips!"
	},
	4: { # THRIFTER
		"name": "Thrifter",
		"story": "Frugal and punishing. They hoard wealth and punish spenders.",
		"ability": "Learn to Save: Applies THRIFT for non-matching pairs.",
		"tip": "Only play perfect pairs (SUN-SUN or MOON-MOON) to avoid crippling THRIFT."
	},
	5: { # ARISTOCRAT
		"name": "Aristocrat",
		"story": "Born into unimaginable wealth, but drowning in inherited debt.",
		"ability": "Fully Paid: Starts with massive DEBT. If DEBT reaches 0, you die.",
		"tip": "DO NOT clear their DEBT! Use direct damage, not DEBT-clearing passives."
	},
	6: { # SUN_CASTER
		"name": "Sun Caster",
		"story": "A zealot of the blazing dawn. Their flames burn the greedy.",
		"ability": "Sunlit Curse: Powers up if you play 9 or more SUN coins.",
		"tip": "Limit your SUN coin usage. Pivot to MOON coins to starve their power."
	},
	7: { # MOON_CASTER
		"name": "Moon Caster",
		"story": "A scholar of the midnight sky. They draw power from the shadows.",
		"ability": "Midnight Curse: Powers up if you play 9 or more MOON coins.",
		"tip": "Limit your MOON coin usage. Focus on SUN damage to win."
	},
	8: { # TWILIGHT_SAGE
		"name": "Twilight Sage",
		"story": "Master of both dawn and dusk. The rules change every turn.",
		"ability": "Stance Shifter: Alternates between Dawn and Dusk stances.",
		"tip": "Pay attention to the background color! Play MOON during Dawn, and SUN during Dusk."
	}
}
func _ready() -> void:
	for child in get_children():
		child.modulate.a = 0.0
		
func setup(enemy_node: Node) -> void:
	var type_id = enemy_node.type # Grabs the enum integer (0-8)
	var data = ENEMY_DATA[type_id]
	
	# ==========================================
	# 1. POPULATE STATIC LORE & TIPS
	# ==========================================
	enemy_name.text = data["name"] 
	
	# Pass in the Label, the Text, the Max Height (e.g., 180 pixels), and Default Font Size
	set_and_shrink_text(story_label, data["story"], 250.0, 32)
	set_and_shrink_text(enemy_ability, data["ability"], 120.0, 32)
	set_and_shrink_text(player_tip, data["tip"], 100.0, 32)
	
	# ==========================================
	# 2. POPULATE LIVE COMBAT STATS
	# ==========================================
	var stats_text = ""
	stats_text += "Coins: " + str(enemy_node.coin) + " / " + str(enemy_node.max_coin) + "\n"
	stats_text += "Silver Flip Rate: " + str(enemy_node.silver_flip_rate * 100) + "%\n"
	stats_text += "Gold Flip Rate: " + str(enemy_node.gold_flip_rate * 100) + "%"
	
	# Give the stats block its own max height as well
	set_and_shrink_text(enemy_stats, stats_text, 100.0, 32)
	
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
	
	while text_height > max_height and current_size > 16:
		current_size -= 2
		text_height = font.get_multiline_string_size(new_text, HORIZONTAL_ALIGNMENT_LEFT, max_width, current_size).y
		
	label.add_theme_font_size_override("font_size", current_size)
	label.custom_minimum_size.y = max_height
