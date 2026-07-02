extends TextureRect

@onready var player_frame = $"Frame/Player"
@onready var Player_Inforamtion = $"Frame/Player/Information"
@onready var Player_Storyline = $"Frame/Player/StoryLine"

@onready var shop_keeper_frame = $"Frame/ShopKeeper"
@onready var ShopKeeper_Inforamtion = $"Frame/ShopKeeper/Information"
@onready var ShopKeeper_Storyline = $"Frame/ShopKeeper/StoryLine"

@onready var mage_frame = $"Frame/Mage"
@onready var mage_Inforamtion = $"Frame/Mage/Information"
@onready var mage_Storyline = $"Frame/Mage/StoryLine"

@onready var dwarf_frame = $"Frame/Dwarf"
@onready var dwarf_Inforamtion = $"Frame/Dwarf/Information"
@onready var dwarf_Storyline = $"Frame/Dwarf/StoryLine"

@onready var collector_frame = $"Frame/Collector"
@onready var collector_Inforamtion = $"Frame/Collector/Information"
@onready var collector_Storyline = $"Frame/Collector/StoryLine"

@onready var trader_frame = $"Frame/Trader"
@onready var trader_Inforamtion = $"Frame/Trader/Information"
@onready var trader_Storyline = $"Frame/Trader/StoryLine"

@onready var thrifter_frame = $"Frame/Thrifter"
@onready var thrifter_Inforamtion = $"Frame/Thrifter/Information"
@onready var thrifter_Storyline = $"Frame/Thrifter/StoryLine"

@onready var aristocrat_frame = $"Frame/Aristocrat"
@onready var aristocrat_Inforamtion = $"Frame/Aristocrat/Information"
@onready var aristocrat_Storyline = $"Frame/Aristocrat/StoryLine"

@onready var sun_caster_frame = $"Frame/Sun_Caster"
@onready var sun_caster_Inforamtion = $"Frame/Sun_Caster/Information"
@onready var sun_caster_Storyline = $"Frame/Sun_Caster/StoryLine"

@onready var moon_caster_frame = $"Frame/Moon_Caster"
@onready var moon_caster_Inforamtion = $"Frame/Moon_Caster/Information"
@onready var moon_caster_Storyline = $"Frame/Moon_Caster/StoryLine"

@onready var twilight_sage_frame = $"Frame/Twilight_Sage"
@onready var twilight_sage_Inforamtion = $"Frame/Twilight_Sage/Information"
@onready var twilight_sage_Storyline = $"Frame/Twilight_Sage/StoryLine"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_show_frame(player_frame)
	
	Player_Inforamtion.text = (
		"Ability: Coin Magic\n" +
		"Likes: Justice, Cats and Coins\n" +
		"Dislikes: Greed, The Council\n" +
		"Strengths: To keep moving forward\n" +
		"Weaknesses: Confidence depends on Coins"
	)
	Player_Storyline.text = (
		"	Everything changed from the moment a deal was struck with The Council and The Corruption. And with tyranny and greed running rampant, disrupting the once peaceful balance of the world, you can’t just let it continue. The life you once knew, gone with just a snap of someone’s hands.
	No, you will not stand for something so frivolous. And although you are powerless now, your courage will lead your heart where it needs to go. 
"
	)
	ShopKeeper_Inforamtion.text = (
		"Ability: Flip Momentum\n" +
		"Likes: Valuable Customers, Profitable Trades\n" +
		"Dislikes: Greed, The Council, Stealing, Bartering\n" +
		"Strengths: Cannot be fooled\n" +
		"Weaknesses: Carries a painful past"
	)
	ShopKeeper_Storyline.text = (
		"	A mysterious, yet comforting, figure that offers a helping hand when you need them. The Shopkeeper knows which road to take, and knows the stakes like the back of her hand. She’s almost too insightful, and you’re tempted to pry. But it isn’t worth risking the help you need.
	Perhaps, when all of this is through, maybe then. For now, feeling her presence behind your back is enough assurance to get things done.
"
	)
	mage_Inforamtion.text = (
		"Ability: Beginner Coin Magic\n" +
		"Likes: Their Master, To be promoted\n" +
		"Dislikes: Ill intent to their Master\n" +
		"Strengths: Potential to surpass their Master\n" +
		"Weaknesses: Easily manipulated"
	)
	mage_Storyline.text = (
		"	Apprentice mages are mages in training, taken in by a more powerful mage as their own. Be it out of pity or the goodness of the mages’ heart, no one ever knows. They say there is a chance for an apprentice mage to take over their masters’ repertoire. But being taken in is already a telling sign that it’s all they will ever be. It is not surprising if an apprentice mage suddenly disappears, stricken with the grief of not being something more.
	They’re not much of a threat, but they will try to take down whoever threatens their masters’ seats in power.
"
	)
	dwarf_Inforamtion.text = (
		"Ability: Treasure Sensing\n" +
		"Likes: Leftover Coins and Goodies\n" +
		"Dislikes: The Wealthy\n" +
		"Strengths: Strong Coin Sensing Skills\n" +
		"Weaknesses: Easily swayed by coins"
	)
	dwarf_Storyline.text = (
		"	Coin dwarves are generally pleasant, unless provoked. They spend most of their days searching for coins that have been tossed out in hopes to add it to their stash.
	However, when they get desperate, they may target whoever they think exudes an abundance of coins. Some say they are what becomes of the missing apprentice mages after losing their minds – destined to search for a value that isn’t there anymore.
"
	)
	collector_Inforamtion.text = (
		"Ability: Tax Collection\n" +
		"Likes: Illegal Tax Declarations\n" +
		"Dislikes: Being negotiated\n" +
		"Strengths: Oppresses anyone with DEBT\n" +
		"Weaknesses: Superiority Complex"
	)
	collector_Storyline.text = (
		"	As an extension of The Council’s reign upon the lands, Tax Collectors help with upholding their control. Balance, however they might twist it, keeps the flow of coins and therefore keeps those in power in their place.
	Due to their connection with The Council, questionable forms of tax collections are so often overlooked – leading to a wider gap in lifestyle and in power. Best not to set them off.
"
	)
	trader_Inforamtion.text = (
		"Ability: 'Fair' Trade\n" +
		"Likes: Bartering Illegal Supplies\n" +
		"Dislikes: Being fooled\n" +
		"Strengths: What you trade is what you get\n" +
		"Weaknesses: Shop Inspections"
	)
	trader_Storyline.text = (
		"	Traders are known for their strikingly absurd deals and are often seen coming in and out of towns. Although with the current state of affairs, their deals don’t cause too much disruption. For some, traders are their bridge to get access to things they can’t get otherwise.
	It still goes without saying to tread and choose carefully who you’re dealing with. Not all of their deals are from the kindness of their hearts.
"
	)
	thrifter_Inforamtion.text = (
		"Ability: Thrift Tactics\n" +
		"Likes: Saving Coins, Budgetting\n" +
		"Dislikes: Overspending\n" +
		"Strengths: Influences Thrifty lifestyle\n" +
		"Weaknesses: Jobless"
	)
	thrifter_Storyline.text = (
		"	Known to come out of their homes when they really, really need to. Is it to save themselves knowing the current state of the world, or is it just the way that they are? No one will ever know. Either way, they are doing themselves a great favor. 
	Consciousness and limitation becomes a solid tactic to survive, and while this might be an inherent trait for them, they are sure to go far. Just not relative from their house, that is.
"
	)
	aristocrat_Inforamtion.text = (
		"Ability: Ultimate Refund\n" +
		"Likes: Attention, Glamour, Money\n" +
		"Dislikes: Poor People\n" +
		"Strengths: Can pay for anything\n" +
		"Weaknesses: Too Much Pride"
	)
	aristocrat_Storyline.text = (
		"	Aristocrats hold no significant powers except for being rich. The Council holds them close and that gives them reassurance. Whether they know they’re being used as a ploy is between them and their over-inflated ego.
	Their attitude and way of life leaves much to be desired, however there is certainly something to be felt in seeing them squirm as The Council continuously lowers the hook for the fishes.
"
	)
	sun_caster_Inforamtion.text = (
		"Ability: Sun Affinity\n" +
		"Likes: SUN Coins, Daylight\n" +
		"Dislikes: MOON Coins, Moon Caster\n" +
		"Strengths: Powers up from SUN Coins\n" +
		"Weaknesses: No Spells on MOON Coins"
	)
	sun_caster_Storyline.text = (
		"	A powerful mage favored by the corruption of the sun. Power is a double-edged sword, and greed only deepens the cut. They think power is what they want, but once the corruption casts its eyes on you, you will no longer be who you once were.
	Such a tragic fate for Sun Caster – a vessel where corruption feeds upon their greed, slowly but surely taking their autonomy away, too.
"
	)
	moon_caster_Inforamtion.text = (
		"Ability: Moon Affinity\n" +
		"Likes: MOON Coins, Moonlight\n" +
		"Dislikes: SUN Coins, Sun Caster\n" +
		"Strengths: Powers up from MOON Coins\n" +
		"Weaknesses: No Spells on SUN Coins"
	)
	moon_caster_Storyline.text = (
		"	Much like their counterparts, Moon Caster often picks fights with Sun Caster. Even though they carry the corruption within them, some of their quirks still manage to show.
Perhaps it is why the corruption took notice of the now Moon Caster – second best, and always in the shadow. Greed not only applies to money after all. However, greed does not care if this is a futile attempt to satiate one’s worth. It only really cares that it is being fed.
"
	)
	twilight_sage_Inforamtion.text = (
		"Ability: Dawn and Dusk Stance\n" +
		"Likes: Greed, Absolute Power\n" +
		"Dislikes: Those who opposes Greed\n" +
		"Strengths: Can change the time of day\n" +
		"Weaknesses: Blinded by Greed, no conscience left."
	)
	twilight_sage_Storyline.text = (
		"	Having gotten the attention of both the sun and the moon’s corruption, the most powerful mage in the Twilight Zone succumbs to greed. The town watched as their most beloved mage turned into a tyrant, nothing more than a host for an ill-rooted cause.
But such is the thing about greed. It burrows its roots into one’s head, until one day it begs for water – anything at all to quench its thirst, even if it is throwing away everything you knew. When you look into the Twilight Sage’s eyes, would you be able to find that trace of regret?

"
	)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _show_frame(frame_to_show: Control) -> void:
	player_frame.visible = false
	shop_keeper_frame.visible = false
	mage_frame.visible = false
	dwarf_frame.visible = false
	collector_frame.visible = false
	trader_frame.visible = false
	thrifter_frame.visible = false
	aristocrat_frame.visible = false
	sun_caster_frame.visible = false
	moon_caster_frame.visible = false
	twilight_sage_frame.visible = false

	frame_to_show.visible = true


func _on_back_pressed() -> void:
	SceneTransition.load_scene("res://Scene/archive.tscn")


func _on_player_pressed() -> void:
	_show_frame(player_frame)
func _on_shop_keeper_pressed() -> void:
	_show_frame(shop_keeper_frame)
func _on_mage_pressed() -> void:
	_show_frame(mage_frame)
func _on_dwarf_pressed() -> void:
	_show_frame(dwarf_frame)
func _on_collector_pressed() -> void:
	_show_frame(collector_frame)
func _on_trader_pressed() -> void:
	_show_frame(trader_frame)
func _on_thrifter_pressed() -> void:
	_show_frame(thrifter_frame)
func _on_aristocrat_pressed() -> void:
	_show_frame(aristocrat_frame)
func _on_sun_caster_pressed() -> void:
	_show_frame(sun_caster_frame)
func _on_moon_caster_pressed() -> void:
	_show_frame(moon_caster_frame)
func _on_twilight_sage_pressed() -> void:
	_show_frame(twilight_sage_frame)
