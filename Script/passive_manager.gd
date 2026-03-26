extends Node

var main
#GENERAL PASSIVES
#B-Rank
@export var has_wishbone: bool = false
@export var has_golden_clover: bool = false
@export var has_solar_coin: bool = false
@export var has_lunar_coin: bool = false
@export var has_merchant_scroll: bool = false
@export var has_impromptu_flip: bool = false
@export var has_advanced_planning: bool = false
@export var has_magic_trick: bool = false
@export var has_sleight_of_hand: bool = false




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func setup(main_ref):
	main = main_ref
	
func trigger_passive(passive_name: String):
	match passive_name:
		"solar_coin":
			has_solar_coin = true
			main.show_floating_label(main.player, 0, main.LabelType.SOLAR_COIN)
			main.show_passive_notification("Solar Coin Applied")
			
		"lunar_coin":
			has_lunar_coin = true
			main.show_floating_label(main.player, 0, main.LabelType.LUNAR_COIN)
			main.show_passive_notification("Lunar Coin Applied")
			
		"impromptu_flip":
			has_impromptu_flip = true
			main.show_floating_label(main.player, 0, main.LabelType.IMPROMPTU_FLIP)
			main.show_passive_notification("Impromptu Flip Activated")
			if main.has_impromptu_flip and main.latest_coin != null:
				main.coin_calculation()
			await get_tree().create_timer(1.0).timeout
		"magic_trick":
			has_magic_trick = true
			main.show_floating_label(main.player, 0, main.LabelType.MAGIC_TRICK)
			main.show_passive_notification("Magic Trick Activated")
			if main.coin_count >= 6:
				var coins = get_tree().get_nodes_in_group("coins")
				var index = 0
				var first_coin = null
				var second_coin = null
				for coin in coins:
					index += 1
					print("Checking Coin: " + str(index))
					if index == 1: first_coin = coin
					elif index == 2: second_coin = coin
					elif index == 3 or index == 5:
						coin.copy_coin(first_coin)
						main.coin_calculation()
						await main.get_tree().create_timer(0.1).timeout
					elif index == 4 or index == 6:
						coin.copy_coin(second_coin)
						main.coin_calculation()
						await main.get_tree().create_timer(0.1).timeout
				main.coin_calculation()
				await get_tree().create_timer(1.0).timeout


func handle_coin_flip(flip_clicks: int, state: int) -> int:
	if flip_clicks == 1 and has_solar_coin:
		trigger_passive("solar_coin")
		state = 0;
		main.show_floating_label(main.player,0,main.LabelType.SOLAR_COIN)
		print("Solar Coin TRIGGERED")
		
	if flip_clicks == 2 and has_lunar_coin:
		print("Lunar Coin TRIGGERED")
		state = 1;
		main.show_floating_label(main.player,0,main.LabelType.LUNAR_COIN)
	main.player.current_flip += 1
	main.player.take_damage(1)
	main.show_floating_label(main.player,1,main.LabelType.DAMAGE)
	
	
	return state
	
