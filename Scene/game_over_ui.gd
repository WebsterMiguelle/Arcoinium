extends CanvasLayer


func show_stats(stats: Dictionary):
	var label = $ColorRect/StatsLabel
	
	label.text = \
	"Remaining Coins: " + str(stats["remaining_coins"]) + "\n" + \
	"Total DMG: " + str(stats["total_damage_dealt"]) + "\n" + \
	"Highest DMG: " + str(stats["highest_damage_dealt"]) + "\n" + \
	"Overall Total DMG: " + str(stats["overall_total_damage"]) + "\n" + \
	"Overall Highest DMG: " + str(stats["overall_highest_damage"]) + "\n" + \
	"Total GAIN: " + str(stats["total_gain"]) + "\n" + \
	"Highest GAIN: " + str(stats["highest_gain"]) + "\n" + \
	"Overall Total GAIN: " + str(stats["overall_total_gain"]) + "\n" + \
	"Overall Highest GAIN: " + str(stats["overall_highest_gain"]) + "\n" + \
	#"Overall DEBT: " + str(stats["total_debt"]) + "\n" + \
	#"Highest DEBT: " + str(stats["highest_debt"]) + "\n" + \
	"Enemies Defeated: " + str(stats["enemies_defeated"]) + "\n" + \
	"Sun Coins Flipped: " + str(stats["heads"]) + "\n" + \
	"Moon Coins Flipped: " + str(stats["tails"]) + "\n" + \
	"Total Flips: " + str(stats["flips"]) + "\n" + \
	"Re-Flips: " + str(stats["reflips"]) + "\n" 
	#"Passives: " + str(stats["passives"]
	
