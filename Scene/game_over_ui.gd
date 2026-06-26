extends CanvasLayer


func show_stats(stats: Dictionary):
	var label = $ColorRect/StatsLabel
	
	var total_seconds = int(stats["run_time"])
	@warning_ignore("integer_division")
	var minutes: int = total_seconds / 60
	var seconds = total_seconds % 60
	var formatted_time = "%02d:%02d" % [minutes, seconds]
	
	label.text = \
	"Remaining Coins: " + str(stats["remaining_coins"]) + "\n" + \
	"Overall Total DMG: " + str(stats["overall_total_damage"]) + "\n" + \
	"Highest DMG: " + str(stats["highest_damage_dealt"]) + "\n" + \
	"Overall Total GAIN: " + str(stats["overall_total_gain"]) + "\n" + \
	"Highest GAIN: " + str(stats["highest_gain"]) + "\n" + \
	"Total Debt Applied: " + str(stats["total_debt_applied"]) + "\n" + \
	"Highest Debt Applied: " + str(stats["highest_debt_applied"]) + "\n" + \
	"Enemies Defeated: " + str(stats["enemies_defeated"]) + "\n" + \
	"Sun Coins Flipped: " + str(stats["heads"]) + "\n" + \
	"Moon Coins Flipped: " + str(stats["tails"]) + "\n" + \
	"Total Flips: " + str(stats["flips"]) + "\n" + \
	"Re-Flips: " + str(stats["reflips"]) + "\n" + \
	"Run Time: " + formatted_time
