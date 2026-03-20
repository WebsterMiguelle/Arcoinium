extends Button

@onready var player_node: Node2D = $"../../Player"
@onready var coin_bar: HBoxContainer = $HBoxContainer

var lifted_slot: Control = null
var lift_amount: float = -8.0 
var active_tween: Tween

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_hovered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	if player_node:
		# Connect the signal
		player_node.hp_changed.connect(_update_visuals)
		# Set initial state
		_update_visuals(player_node.coin)

func _pressed() -> void:
	if lifted_slot:
		var slot = lifted_slot
		lifted_slot = null 
		
		var sprite = slot.get_child(0) as AnimatedSprite2D
		
		if active_tween: active_tween.kill()
		active_tween = create_tween()

		active_tween.tween_property(slot, "position:y", -20.0, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		active_tween.parallel().tween_property(slot, "modulate:a", 0.0, 0.25).set_ease(Tween.EASE_IN)
		sprite.play("Flipped Sun to Sun") 
		
		
		await sprite.animation_finished
		
		slot.visible = false
		slot.position.y = 0 
		sprite.play("Sun_Static") 
		
		if is_hovered(): 
			_on_mouse_hovered()
	
func _update_visuals(current_hp: int) -> void:
	var slots = coin_bar.get_children()
	for i in range(slots.size()):
		if i < current_hp:
			slots[i].visible = true
			slots[i].modulate.a = 1.0 
			slots[i].position.y = 0  
		else:
			var sprite = slots[i].get_child(0) as AnimatedSprite2D
			if sprite.animation != "Flipped Sun to Sun":
				slots[i].visible = false

func _on_mouse_hovered() -> void:
	var v_slots = coin_bar.get_children().filter(func(c): return c.visible)
	if v_slots.size() > 0 and lifted_slot == null:
		lifted_slot = v_slots[-1]
		var t = create_tween()
		t.tween_property(lifted_slot, "position:y", lift_amount, 0.1)

func _on_mouse_exited() -> void:
	if lifted_slot:
		var t = create_tween()
		t.tween_property(lifted_slot, "position:y", 0, 0.1)
		lifted_slot = null
