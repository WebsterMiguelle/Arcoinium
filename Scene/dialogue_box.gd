
class_name DialogueBox 
extends Node2D

enum TailSide { LEFT, RIGHT }


signal dialogue_finished

const LINES = {
	"welcome": [
		"Welcome Coin Caster. I the Shop Keeper \nwill Guide You!!.",
		"Knowledge gain advantage.",
		"Chose which you want to Learn."
		 ],
	"basic_first": [
		"Ah, Basic Mode! A wise choice.",
		" I will be teaching you the Battle Basics.",
		"Are You Ready?" ],
	"basic_return": [
		"Ah, Basic Mode! A wise choice.",
		" I will be teaching you the Battle Basics.",
		"Are You Ready?" ],
	"advance_first": [
		"Ooh, Advanced Mode! Bold choice!",
		"I will be teaching you the Advance play.",
		"Are You Ready?" ],
	"advance_return": [
		"Ooh, Advanced Mode! Bold choice!",
		"I will be teaching you the Advance play.",
		"Are You Ready?" ],
	"back_return": [
		"Hmm.., Leaving now Coin Master?",
		"Sigh..., Good luck to the RealWorld!" ],
	"back_first": [
		"Hmm.., Leaving now Coin Master?",
		"Sigh..., Good luck to Your Journey!" ],
	"sk_battle_start": [
		"So, you wish to learn, Coin Caster?",
		"I won't go easy on you.",
		"Let the lesson begin!" ],
	"sk_first_flip": [
		"Ah, your first flip!",
		"Each coin holds a fate.",
		"Flip wisely..." ],
	"sk_flip_progress": [
		"Keep flipping, Caster.",
		"The Arcane Circle hungers for more coins." ],
	"sk_coin_spell": [
		"Each coin carries its own magic.",
		"Inspect your portrait — know your power." ],
	"sk_first_reflip": [
		"Fate not in your favor?",
		"Re-Flip — bend the odds to your will.",
		"But it won't last forever..." ],
	"sk_endturn": [
		"Bold! You end your turn.",
		"Now your coins clash against mine.",
		"Pray they hold." ],
	"sk_reserve": [
		"Ah, the Reserve\n— a cunning move.",
		"Saved coins return as bonus\nat battle's end.",
		"A true Caster plans ahead." ],
	"sk_overflow": [
		"Overflow your Cirle." ],
	"sk_player_winning": [
		"Impressive... you fight well.",
		"Do not grow arrogant, Caster." ],
	"sk_player_losing": [
		"Struggling, are we?",
		"Remember — coins won't\nsave a careless hand." ],
	"sk_victory": [
		"...You have bested me.",
		"The lesson is complete, Coin Caster.",
		"Go. The real world awaits you." ],
	"sk_defeat": [
		"Hmph. You still have much to learn.",
		"Return when you are ready, Caster." ]
	
}
const LINE_DURATION = 3.0
const CHARS_PER_SECOND = 10.0

var _queue: Array = []
var _playing = false

func set_tail(side: TailSide) -> void:
	var panel: PanelContainer = $"Dialogue Panel"
	var style: StyleBoxFlat = panel.get_theme_stylebox("panel").duplicate()

	var r = 32
	
	match side:
		TailSide.LEFT:
			style.corner_radius_top_left = 0
			style.corner_radius_top_right = r
			style.corner_radius_bottom_left = r 
			style.corner_radius_bottom_right = r
		TailSide.RIGHT:
			style.corner_radius_top_left = r
			style.corner_radius_top_right = 0
			style.corner_radius_bottom_left = r
			style.corner_radius_bottom_right = r
			
	panel.add_theme_stylebox_override("panel", style)
	
	
func play(key: String) -> void:
	if not LINES.has(key):
		push_warning("Dialogue: unknown key '%s'" % key)
		return
	_queue = LINES[key].duplicate()
	_playing = true
	_next()
	
func _next() -> void:
	if _queue.is_empty():
		_playing = false
		#close()
		dialogue_finished.emit()
		return
		
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
	var label: Label = $"Dialogue Panel/MarginContainer/Dialogue Info"
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
