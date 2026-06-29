extends ColorRect

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
		"Name: Coin Caster\n" +
		"Coin: \n" +
		"Age: \n" +
		"Species: Human\n" +
		"Ability: Coin Mastery"
	)
	Player_Storyline.text = (
		" This is the part where the story begins"
	)
	ShopKeeper_Inforamtion.text = (
		"Name: Shop Keeper\n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species:  \n" +
		"Ability: ? "
	)
	ShopKeeper_Storyline.text = (
		" This is the part where the story begins"
	)
	mage_Inforamtion.text = (
		"Name: Mage \n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species:  \n" +
		"Ability: ? "
	)
	mage_Storyline.text = (
		" This is the part where the story begins"
	)
	dwarf_Inforamtion.text = (
		"Name: Dwarf \n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species:  \n" +
		"Ability: ? "
	)
	dwarf_Storyline.text = (
		" This is the part where the story begins"
	)
	collector_Inforamtion.text = (
		"Name: Collector \n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species:  \n" +
		"Ability: Bargain Sense"
	)
	collector_Storyline.text = (
		" This is the part where the story begins"
	)
	trader_Inforamtion.text = (
		"Name: Trader \n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species:  \n" +
		"Ability: ? "
	)
	trader_Storyline.text = (
		" This is the part where the story begins"
	)
	thrifter_Inforamtion.text = (
		"Name: Thrifter \n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species:  \n" +
		"Ability: ? "
	)
	thrifter_Storyline.text = (
		" This is the part where the story begins"
	)
	aristocrat_Inforamtion.text = (
		"Name: Aristocrat \n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species:  \n" +
		"Ability: ? "
	)
	aristocrat_Storyline.text = (
		" This is the part where the story begins"
	)
	sun_caster_Inforamtion.text = (
		"Name: Sun Caster \n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species: ? \n" +
		"Ability: ? "
	)
	sun_caster_Storyline.text = (
		" This is the part where the story begins"
	)
	moon_caster_Inforamtion.text = (
		"Name: Moon Caster \n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species: ? \n" +
		"Ability: ? "
	)
	moon_caster_Storyline.text = (
		" This is the part where the story begins"
	)
	twilight_sage_Inforamtion.text = (
		"Name: Twilight Sage \n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species: ? \n" +
		"Ability: ? "
	)
	twilight_sage_Storyline.text = (
		" This is the part where the story begins"
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
