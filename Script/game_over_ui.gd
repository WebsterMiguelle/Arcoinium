extends CanvasLayer


func show_stats(stats: Dictionary):
	var label = $ColorRect/StatsLabel
	
	label.text = \
	"Remaining Coins: " + str(stats["remaining_coins"]) + "\n" + \
	"Highest DMG: " + str(stats["highest_damage_dealt"]) + "\n" + \
	"Overall Total DMG: " + str(stats["overall_total_damage"]) + "\n" + \
	"Highest GAIN: " + str(stats["highest_gain"]) + "\n" + \
	"Overall Total GAIN: " + str(stats["overall_total_gain"]) + "\n" + \
	"Enemies Defeated: " + str(stats["enemies_defeated"]) + "\n" + \
	"Sun Coins Flipped: " + str(stats["heads"]) + "\n" + \
	"Moon Coins Flipped: " + str(stats["tails"]) + "\n" + \
	"Total Flips: " + str(stats["flips"]) + "\n" + \
	"Re-Flips: " + str(stats["reflips"]) + "\n" + \
	"Total Reserve Coins: " + str(stats["total_reserved_coins"]) 
	
