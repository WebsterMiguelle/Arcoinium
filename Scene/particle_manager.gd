extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_particle(p,pos):
	if is_instance_valid(p):
		var particle = p.instantiate()
		particle.global_position = pos
		add_child(particle)
