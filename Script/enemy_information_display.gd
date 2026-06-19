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
		"story": "A wandering apprentice learning the basic arts of coin casting.",
		"ability": "Flips standard coins. Simple and predictable.",
		"tip": "A great target to build your Reserve against!"
	},
	1: { # DWARF
		"name": "Dwarf",
		"story": "A sturdy subterranean miner with a heavy purse.",
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
	story_label.text = data["story"]
	enemy_ability.text = data["ability"]
	player_tip.text = data["tip"]
	
	# ==========================================
	# 2. POPULATE LIVE COMBAT STATS
	# ==========================================
	var stats_text = ""
	
	# Shows current vs max coins (e.g., "Coins: 120 / 200")
	stats_text += "Coins: " + str(enemy_node.coin) + " / " + str(enemy_node.max_coin) + "\n"
	
	# Converts the decimal rates to clean percentages
	stats_text += "Silver Flip Rate: " + str(enemy_node.silver_flip_rate * 100) + "%\n"
	stats_text += "Gold Flip Rate: " + str(enemy_node.gold_flip_rate * 100) + "%"
	
	enemy_stats.text = stats_text
	# ==========================================
	# 3. POPULATE LIVE STATUS EFFECTS
	# ==========================================
	gain.text = "Gain ( " + str(enemy_node.gain) + " )"
	debt.text = "Debt ( " + str(enemy_node.debt) + " )"
	thrift.text = "Thrift ( " + str(enemy_node.thrift) + " )"
	
func open() -> void:
	target_y = global_position.y
	global_position.y += slide_distance
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position:y", target_y, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var delay = 0.0
	for child in get_children():
		tween.tween_property(child, "modulate:a", 1.0, 0.3).set_delay(delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		delay += stagger_delay

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
