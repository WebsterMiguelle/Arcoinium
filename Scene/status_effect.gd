extends HFlowContainer

var stack = 0

var STATUS_DATA = {
	#PLAYER AND ENEMY STATUS
	0: {"name": "GAIN",
	"desc": "Gain " + str(stack) + " Coins next turn.",
	"color":"#e0652f"},
	1: {"name": "DEBT",
	"desc": "The next Coin Gain is reduced by " + str(stack) + ".",
	"color":"#7325ff"},
	2: {"name": "THRIFT",
	"desc": "Block " + str(stack) + " Slots on the Arcane Circle.",
	"color":"#007ed7"},
	3: {"name": "SPEND",
	"desc": "The next " + str(stack) + " Flips deal 2 damage instead.",
	"color":"#cd0005"},
	
	#PLAYER STATUS

	4: {"name": "DROWSE",
	"desc": "Re-Flip only has a 50% Chance for each Coin.",
	"color":"#5c6fcf"},
	5: {"name": "VOIDED",
	"desc": "Cannot Add or Retrieve Coins in the RESERVE. RESERVED Coins become VOIDED.",
	"color":"#000000"},
	6: {"name": "TALLY",
	"desc": "Flipping or Reserving " + str(stack) + " more times will immediately End the turn.",
	"color": "#b05700"},
	7: {"name": "STARSTRUCK",
	"desc": "Each Coin Flip has a 50% Chance to be DAZZLED.",
	"color": "#ef00c6"},
	8: {"name": "SEALED",
	"desc": "Odd Flips are STAMPED.",
	"color": "#91002f"},
	9: {"name": "SUNLIT CURSE",
	"desc": "All Flips are guaranteed SUN.",
	"color": "#e51100"},
	10: {"name": "MOONLIT CURSE",
	"desc": "All Flips are guaranteed MOON.",
	"color": "#1071fa"},
	11: {"name": "SOLAR BLESSED",
	"desc": "Odd Flips are Guaranteed SUN.",
	"color": "#ff7527"},
	12: {"name": "LUNAR BLESSED",
	"desc": "Even Flips are Guaranteed MOON.",
	"color": "#00b5de"},

	#ENEMY STATUS
	
	13: {"name": "BENCHMARK",
	"desc": "Plays " + str(stack) + " Coins next turn.",
	"color": "#276000"},
	14: {"name": "AUDIT",
	"desc": "Self-Apply 1 GAIN for 1 DEBT settled by the enemy.",
	"color": "#b073e1"},
	15: {"name": "SETTLE",
	"desc": "Deal " + str(stack) + " Damage if all DEBT is cleared.",
	"color": "#00a9a5"},
	16: {"name": "EMPOWERED",
	"desc": "100% Gold Flip Rate this turn.",
	"color": "#e5a400"},
	17: {"name": "RADIANT",
	"desc": "505 Chance for each Coin to be SHINED after ending the turn.",
	"color": "#ff8d71"},
	
	#SHOPKEEPER
	18: {"name": "MOMENTUM",
	"desc": "Additionally Flip 2 More Coins each turn.",
	"color": "#910098"},
	19: {"name": "TRUST",
	"desc": "Shopkeeper's TRUST to Coin Caster. Higher TRUST enables new spells.",
	"color": "#5b87c0"
	}
	
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func set_status(id,status_stack):
	print("I AM HERE STATUS SETTING")
	var status_name: Label = $"VBoxContainer/Status Name"
	var description: Label = $VBoxContainer/Description
	update_desc(status_stack)
	var status = STATUS_DATA[id]
	status_name.add_theme_color_override("font_color",Color(status["color"]))
	if status_stack > 1:
		status_name.text = status["name"] + " (" + str(status_stack) + ")"
	else:
		status_name.text = status["name"]
	description.text = status["desc"]
	
func update_desc(stack):
	STATUS_DATA = {
	#PLAYER AND ENEMY STATUS
	0: {"name": "GAIN",
	"desc": "Gain " + str(stack) + " Coins next turn.",
	"color":"#e0652f"},
	1: {"name": "DEBT",
	"desc": "The next Coin Gain is reduced by " + str(stack) + ".",
	"color":"#7325ff"},
	2: {"name": "THRIFT",
	"desc": "Block " + str(stack) + " Slots on the Arcane Circle.",
	"color":"#007ed7"},
	3: {"name": "SPEND",
	"desc": "The next " + str(stack) + " Flips deal 2 damage instead.",
	"color":"#cd0005"},
	
	#PLAYER STATUS

	4: {"name": "DROWSE",
	"desc": "Re-Flip only has a 50% Chance for each Coin.",
	"color":"#5c6fcf"},
	5: {"name": "VOIDED",
	"desc": "Cannot Add or Retrieve Coins in the RESERVE. RESERVED Coins become VOIDED.",
	"color":"#000000"},
	6: {"name": "TALLY",
	"desc": "Flipping or Reserving " + str(stack) + " more times will immediately End the turn.",
	"color": "#b05700"},
	7: {"name": "STARSTRUCK",
	"desc": "Each Coin Flip has a 50% Chance to be DAZZLED.",
	"color": "#ef00c6"},
	8: {"name": "SEALED",
	"desc": "Odd Flips are STAMPED.",
	"color": "#91002f"},
	9: {"name": "SUNLIT CURSE",
	"desc": "All Flips are guaranteed SUN.",
	"color": "#e51100"},
	10: {"name": "MOONLIT CURSE",
	"desc": "All Flips are guaranteed MOON.",
	"color": "#1071fa"},
	11: {"name": "SOLAR BLESSED",
	"desc": "Odd Flips are Guaranteed SUN.",
	"color": "#ff7527"},
	12: {"name": "LUNAR BLESSED",
	"desc": "Even Flips are Guaranteed MOON.",
	"color": "#00b5de"},

	#ENEMY STATUS
	
	13: {"name": "BENCHMARK",
	"desc": "Play the same amount of Coins as the enemy.",
	"color": "#276000"},
	14: {"name": "AUDIT",
	"desc": "Self-Apply 1 GAIN for 1 DEBT settled by the enemy.",
	"color": "#b073e1"},
	15: {"name": "SETTLE",
	"desc": "Deal " + str(stack) + " Damage if all DEBT is cleared.",
	"color": "#00a9a5"},
	16: {"name": "EMPOWERED",
	"desc": "100% Gold Flip Rate this turn.",
	"color": "#e5a400"},
	17: {"name": "RADIANT",
	"desc": "50% Chance for each Coin to be SHINED after ending the turn.",
	"color": "#ff8d71"},
	
	#SHOPKEEPER
	18: {"name": "MOMENTUM",
	"desc": "Additionally Flip 2 More Coins each turn.",
	"color": "#910098"},
	19: {"name": "TRUST",
	"desc": "Shopkeeper's TRUST to Coin Caster. Higher TRUST enables new spells.",
	"color": "#5b87c0"
	},
	
	#OTHERS
	20:{"name": "UNCHARGABLE",
	"desc": "Immune to any DEBT application.",
	"color": "#e5a400"
	},
	
	21: {"name": "COUNTER",
	"desc": "If an ally was attacked, gain a Turn.",
	"color": "#c84eab"
	},
		
	22: {"name": "FULLY PAID",
	"desc": "If an ally SETTLEs all their DEBT, gain a Turn.",
	"color": "#f2aa00"
	},
	23:{"name": "FOCUSED",
	"desc": "Immune to Crowd Control Debuffs.",
	"color": "#0085d1"
	}, 
}
