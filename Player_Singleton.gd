extends Node

#PLAYER STATS
var max_coin = 1000 #Max Coin Capacity
var max_reserve = 6
var current_reserve = 0
var coin = 100:
	set(value):
		coin = clamp(value,0,max_coin)
var max_playable_coins: = 16 #Max Flips Per Turn
var current_played_coin: = 0: #Current Flip Count
	set(value):
		current_played_coin = clamp(value,0,max_playable_coins + 1)
var max_re_flip = 6 #Max Re-Flips Per Turn
var current_re_flip = 0: #Current Re-Flip Count
	set(value):
		current_re_flip = clamp(value,0,max_re_flip)
var silver_flip_rate = 0.1: #Chance to Flip a Silver Coin
	set(value): 
		silver_flip_rate = clamp(value,0.0,100.0) 
var gold_flip_rate = 0.05: #Chance to Flip a Gold Coin
	set(value): 
		gold_flip_rate = clamp(value,0.0,100.0) 

#STATUS EFFECTS

var gain = 0: #Coin to be gained next turn
	set(value):
		gain = clamp(value,0,1000) 
var debt = 0: #Gain Blocked
	set(value):
		debt = clamp(value,0,1000) 

#PASSIVES

#Passive Specific Variables
var flip_clicks = 0
var latest_coin = null
var latest_pair_left_coin = null
var latest_pair_right_coin = null
var payback_used = false
var payback_coins = 10
var passive_income_used = false
var pocket_money_coins = 6
var previous_player_gain = 0

var previous_player_flips = 0
var player_turn_count = 0
var sun_count = 0
var moon_count = 0
var has_extra_turn = false
var extra_turn_penalty = 1

#GENERAL PASSIVES

#B-Rank
@export var has_wishbone = false
@export var has_golden_clover = false
@export var has_solar_coin = false
@export var has_lunar_coin = false
@export var has_merchant_scroll = false
@export var has_impromptu_flip = false
@export var has_advanced_planning = false

#A-Rank
@export var has_magic_trick = false
@export var has_sleight_of_hand = false
@export var has_piggy = false

#INNOVATOR PASSIVES

@export var has_inflation = false
@export var has_payback = false
@export var has_lucky_pair = false
@export var has_value_increase = false

#SHOOTER PASSIVES

@export var has_spare_change = false
@export var has_triple_nickel = false
@export var has_refund = false
@export var has_coin_snipe = false

#INVESTOR PASSIVES

@export var has_active_income = false
@export var has_pocket_money = false
@export var has_passive_income = false
@export var has_simple_interest = false

#DEBTOR PASSIVES

@export var has_pay_down = false
@export var has_reimbursement = false
@export var has_loan_shark = false
@export var has_lending_charge = false

#BANKER PASSIVES

@export var has_cash_out = false
@export var has_dividend = false
@export var has_withdraw = false
@export var has_deposit = false

func save_stats(player):
	
	max_coin = player.max_coin
	max_reserve = player.max_reserve
	current_reserve = player.current_reserve
	coin = player.coin
	max_playable_coins = player.max_playable_coins
	current_played_coin = player.current_played_coin
	max_re_flip = player.max_re_flip
	current_re_flip = player.current_re_flip
	silver_flip_rate = player.silver_flip_rate
	gold_flip_rate = player.gold_flip_rate
	gain = player.gain
	debt = player.debt
	
	#B-Rank
	has_wishbone = player.has_wishbone
	has_golden_clover = player.has_golden_clover
	has_solar_coin = player.has_solar_coin
	has_lunar_coin = player.has_lunar_coin
	has_merchant_scroll = player.has_merchant_scroll
	has_impromptu_flip = player.has_impromptu_flip
	has_advanced_planning = player.has_advanced_planning

	#A-Rank
	has_magic_trick = player.has_magic_trick
	has_sleight_of_hand = player.has_sleight_of_hand
	has_piggy = player.has_piggy

	#INNOVATOR PASSIVES

	has_inflation = player.has_inflation
	has_payback = player.has_payback
	has_lucky_pair = player.has_lucky_pair
	has_value_increase = player.has_value_increase

	#SHOOTER PASSIVES

	has_spare_change = player.has_spare_change
	has_triple_nickel = player.has_triple_nickel
	has_refund = player.has_refund
	has_coin_snipe = player.has_coin_snipe

	#INVESTOR PASSIVES
	has_active_income = player.has_active_income
	has_pocket_money = player.has_pocket_money
	has_passive_income = player.has_passive_income
	has_simple_interest = player.has_simple_interest

	#DEBTOR PASSIVES
	has_pay_down = player.has_pay_down
	has_reimbursement = player.has_reimbursement
	has_loan_shark = player.has_loan_shark
	has_lending_charge = player.has_lending_charge
	
	#BANKER PASSIVES
	has_cash_out = player.has_cash_out
	has_dividend = player.has_dividend
	has_deposit = player.has_deposit
	has_withdraw = player.has_withdraw

func load_stats(player):
	
	player.max_coin = max_coin
	player.max_reserve = max_reserve
	player.current_reserve = current_reserve
	player.coin = coin
	player.max_playable_coins = max_playable_coins
	player.current_played_coin = current_played_coin
	player.max_re_flip = max_re_flip
	player.current_re_flip = current_re_flip
	player.silver_flip_rate = silver_flip_rate
	player.gold_flip_rate = gold_flip_rate
	player.gain = gain
	player.debt = debt
	
	#B-Rank
	player.has_wishbone = has_wishbone
	player.has_golden_clover = has_golden_clover
	player.has_solar_coin = has_solar_coin
	player.has_lunar_coin = has_lunar_coin
	player.has_merchant_scroll = has_merchant_scroll
	player.has_impromptu_flip = has_impromptu_flip
	player.has_advanced_planning = has_advanced_planning

	#A-Rank
	player.has_magic_trick = has_magic_trick
	player.has_sleight_of_hand = has_sleight_of_hand
	player.has_piggy = has_piggy

	#INNOVATOR PASSIVES

	player.has_inflation = has_inflation
	player.has_payback = has_payback
	player.has_lucky_pair = has_lucky_pair
	player.has_value_increase = has_value_increase

	#SHOOTER PASSIVES

	player.has_spare_change = has_spare_change
	player.has_triple_nickel = has_triple_nickel
	player.has_refund = has_refund
	player.has_coin_snipe = has_coin_snipe

	#INVESTOR PASSIVES
	player.has_active_income = has_active_income
	player.has_pocket_money = has_pocket_money
	player.has_passive_income = has_passive_income
	player.has_simple_interest = has_simple_interest

	#DEBTOR PASSIVES
	player.has_pay_down = has_pay_down
	player.has_reimbursement = has_reimbursement
	player.has_loan_shark = has_loan_shark
	player.has_lending_charge = has_lending_charge

	#BANKER PASSIVES
	player.has_cash_out = has_cash_out
	player.has_dividend = has_dividend
	player.has_deposit = has_deposit
	player.has_withdraw = has_withdraw
