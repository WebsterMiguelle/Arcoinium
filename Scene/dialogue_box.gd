
class_name DialogueBox 
extends Node2D

enum TailSide { LEFT, RIGHT }


signal dialogue_finished

const LINES = {
	"welcome": [
		"Welcome Coin Caster. Welcome to Keeper's Rest.",
		"Knowledge gain advantage.",
		"Chose which you want to Learn."
		 ],
	"basic_first": [
			"Ah, Battle Basics. Learn how to Flip, Re-Flip, and Reserve Coins."],
	"basic_return": [
		"Ah, Battle Basics. Learn how to Flip, Re-Flip, and Reserve Coins."],
	"advance_first": [
		"Advanced Tutorial. Learn about Passives, Coin, and Entity Status Effects!"],
	"advance_return": [
"Advanced Tutorial. Learn about Passives, Coin, and Entity Status Effects!"],
	"archive": [
"Behind lies the shelves of knowledge. Learn about Profiles, Passives, and Coin Effects."],
"credits": [
"A manuscript that fell from the sky. The Creators wrote a letter of gratitude."],
	"back_return": [
		"Hmm..., Leaving now Coin Master?"],
	"back_first": [
		"Good luck to Your Journey!" ],
	"sk_battle_start": [
		"So, you wish to learn, Coin Caster?",
		"I won't go easy on you.",
		"Let the lesson begin!" ],
	"sk_first_flip": [
		"Ah, your first flip!",
		"Each coin holds a fate.",
		"Flip 4 Coins..." ],
	"sk_flip_progress": [
		"Keep flipping, Caster.",
		"The Arcane Circle hungers for more coins." ],
	"sk_coin_spell": [
		"Each coin carries its own magic.",
		"Inspect your portrait, know your power." ],
	"sk_first_reflip": [
		"Fate not in your favor?",
		"Re-Flip, bend the odds to your will.",
		"You may only Re-Flip a certain times per turn..." ],
	"sk_endturn": [
		"Cast your Coin Spell. Now you end your turn."],
	"sk_reserve": [
		"Ah, the Reserve.\n A cunning move.",
		"Reserved coins returns directly to the Circle\nnext turn.",
		"A true Caster plans their coins ahead." ],
	"sk_overflow": [
		"Flip 16 or more Coins Caster. Overflow your Cirle." ],
	"sk_player_winning": [
		"Impressive... you fight well.",
		"Do not grow arrogant, Caster." ],
	"sk_player_losing": [
		"Struggling, are we?",
		"Remember, coins won't\nsave a careless hand." ],
	"sk_player_mustdefeat": [
		"Prove your worth. Defeat me.",
		"With coins, cleanse\nthe greed of this world." ],
	"sk_victory": [
		"The lesson is complete, Coin Caster." ],
	"sk_to_advance": [
		"One more round, and then you may go."],
	"sk_defeat": [
		"Hmph. You still have much to learn.",
		"Return when you are ready, Caster." ],
	"adv_welcome": [
		"Back so soon? Before starting, I gave you a gift.\nCheck your portrait." ],
	"adv_debt_intro": [
		"Watch your numbers\nevery flip could cost you." ],
	"adv_coin_tiers_transition": [
		"Now, not all coins are equal.\nLet me show you Silver and Gold." ],
	"adv_coin_status_transition": [
		"Good eye. Now, coins can carry\ntheir own effects too." ],
	"adv_coin_status_intro": [
		"Hover those STAMPED Coins.\nYou may end the turn after checking." ],
	"adv_all_done": [
		"That's the advanced mode.\nThe rest you learn in the field." ],
	"adv_enemy_turn": [
		"My turn. Watch what Debt does to your Gain." ],
	"sk_enemy_info": [
		"If you seek to study your opponent, click their portrait." ],
	"adv_player_passive": [
		"Collect Passive Scrolls throughout your journey. "],
	"adv_flip_4": [
		"Try flipping 4 Coins..."],
	"adv_gain_debt": [
		"DEBT can be removed by GAIN."]
}
const LINE_DURATION = 2.0
const CHARS_PER_SECOND = 30.0

var _queue: Array = []
var _playing = false

func set_tail(side: TailSide) -> void:
	var panel: PanelContainer = $"Dialogue Panel"

	var r = 32
	
	
	
func play(key: String) -> void:
	if not LINES.has(key):
		push_warning("Dialogue: unknown key '%s'" % key)
		return
	_queue = LINES[key].duplicate()
	_playing = true
	_next()
	
func _next() -> void:
	var label: Label = $"Dialogue Panel/MarginContainer/VFlowContainer/Dialogue Info"
	if _queue.is_empty():
		_playing = false
		#close()
		dialogue_finished.emit()
		return
		
	label.text = ""
	if modulate.a < 0.9:
		modulate.a = 0
		var tween = create_tween()
		tween.parallel().tween_property(self, "modulate:a", 1, 0.2)
		tween.parallel().tween_property(self, "position:y", position.y + 80, 0.2)
		await tween.finished
	
	var txt = _queue.pop_front()
	await _set_text(txt)
	await get_tree().create_timer(LINE_DURATION).timeout
	_next()
	
func _set_text(txt: String) -> void:
	var label: Label = $"Dialogue Panel/MarginContainer/VFlowContainer/Dialogue Info"
	label.text = ""
	label.visible_characters = 0
	
	var char_count = txt.length()
	var duration = char_count / CHARS_PER_SECOND
	
	label.text = txt
	label.visible_characters = 0
	
	var tween = create_tween()
	tween.tween_property(label, "visible_characters", char_count, duration) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0

	
func setup(pos: Vector2, offset: float = 0.0) -> void:
	global_position = pos
	global_position.y += offset
	print("Dialogue position set to: ", global_position)

func close():
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate:a",0,0.2)
	tween.parallel().tween_property(self,"position:y",global_position.y + 10, 0.2)
	await get_tree().create_timer(0.8).timeout
	queue_free()
