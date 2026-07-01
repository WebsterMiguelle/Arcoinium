extends HFlowContainer


var STATUS_DATA
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func set_status(id,stack):
	print("I AM HERE STATUS SETTING")
	var status_name: Label = $"VBoxContainer/Status Name"
	var description: Label = $VBoxContainer/Description
	update_desc(stack)
	var status = STATUS_DATA[id]		
	status_name.add_theme_color_override("font_color",Color(status["color"]))
	if stack > 1:
		status_name.text = status["name"] + " x" + str(stack)
	else:
		status_name.text = status["name"]
	description.text = status["desc"]
	
func update_desc(stack):
	STATUS_DATA = {
	#PLAYER AND ENEMY STATUS
	1: {"name": "SHINED",
	"desc": "SHINED Sun: +" + str(3 * stack) + " DMG\nSHINED Moon: +" + str(3 * stack) + " GAIN.",
	"color":"#eb8e00"},
	2: {"name": "VOIDED",
	"desc": "0 Base Value. Can be cleansed via Re-Flips, or Upgrade.",
	"color":"#000000"},
	3: {"name": "DAZZLED",
	"desc": "Will flip to its other side at the end of the turn.",
	"color":"#e800c5"},
	4: {"name": "STAMPED",
	"desc": "Cannot be Re-Flipped.",
	"color":"#a90006"}
	
	
}
