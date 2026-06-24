extends ColorRect

@onready var player_frame = $"Frame/Player"
@onready var shop_keeper_frame = $"Frame/ShopKeeper"
@onready var Player_Inforamtion = $"Frame/Player/Information"
@onready var ShopKeeper_Inforamtion = $"Frame/ShopKeeper/Information"
@onready var Player_Storyline = $"Frame/Player/StoryLine"
@onready var ShopKeeper_Storyline = $"Frame/ShopKeeper/StoryLine"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_frame.visible = true
	
	Player_Inforamtion.text = (
		"Name: Coin Caster\n" +
		"Coin: \n" +
		"Age: \n" +
		"Species: Human\n" +
		"Ability: Coin Mastery"
	)
	ShopKeeper_Inforamtion.text = (
		"Name: Shop Keeper\n" +
		"Coin: \n" +
		"Age: ? \n" +
		"Species:  \n" +
		"Ability: Bargain Sense"
	)
	Player_Storyline.text = (
		" This is the part where the story begins"
	)
	ShopKeeper_Storyline.text = (
		" This is the part where the story begins"
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	SceneTransition.load_scene("res://Scene/archive.tscn")


func _on_player_pressed() -> void:
	player_frame.visible = true
	shop_keeper_frame.visible = false


func _on_shop_keeper_pressed() -> void:
	player_frame.visible = false
	shop_keeper_frame.visible = true
