extends Node2D
@onready var label: Label = $Label
var temp_label
var entity
var gain_color = "#fabb00"
var damage_color = "#ffffff"
var debt_color = "#d44eff"
var thrift_color = "#4badff"
var spend_color = "#ff563a"
var value
var type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	modulate.a = 1
	label = temp_label
	print("FLOATING LABEL CREATED")
	print(label.text)
	var tween = create_tween()
	var target_y
	if entity == "PLAYER":
		global_position.y -= randi_range(120,150)
		target_y = global_position.y - randi_range(100,200)
	else:
		global_position.y += randi_range(120,150)
		target_y = global_position.y + randi_range(100,200)
	
	tween.parallel().tween_property(self,"position:y",target_y,2.0)
	tween.parallel().tween_property(self,"modulate:a",0,2.0)
	tween.finished.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(val, typ, ent, pos):
	temp_label = $Label
	entity = ent
	global_position = pos
	value = val
	type = typ
	temp_label.text = str(value) + " "  + str(type)
	match(type):
		"DAMAGE":
			temp_label.add_theme_color_override("font_color", Color(damage_color))
		"GAIN":
			temp_label.add_theme_color_override("font_color", Color(gain_color))
		"DEBT":
			temp_label.add_theme_color_override("font_color", Color(debt_color))
		"THRIFT":
			temp_label.add_theme_color_override("font_color", Color(thrift_color))
		"SPEND":
			temp_label.add_theme_color_override("font_color", Color(spend_color))
		"LOCK":
			temp_label.add_theme_color_override("font_color", Color(Color.WEB_GRAY))
		"SLOW":
			temp_label.add_theme_color_override("font_color", Color.SEA_GREEN)
		"IMMUNE":
			temp_label.add_theme_color_override("font_color", Color(Color.SLATE_GRAY))
