extends Node2D

const ATTACK_RUNES_PARTICLES = preload("uid://c5o0wyqkpyhg2")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func spawn_particle(p,pos):
	if is_instance_valid(p):
		var particle = p.instantiate()
		particle.global_position = pos
		add_child(particle)

func spawn_emitting_particle(p,pos):
	if is_instance_valid(p):
		var particle = p.instantiate()
		particle.global_position = pos
		particle.add_to_group("particles")
		add_child(particle)

func despawn_emitting_particles():
	var particles = get_tree().get_nodes_in_group("particles")
	for p in particles:
		p.get_child(0).emitting = false
	await get_tree().create_timer(2.0).timeout
	for p in particles:
		p.queue_free()

func play_attack_animation(start_node: Node, target_node: Node, damage: int) -> void:
	var start_pos = start_node.global_position
	var end_pos = target_node.global_position 
	
	if start_node is Control:
		start_pos += start_node.size / 2.0
	if target_node is Control:
		end_pos += target_node.size / 2.0
	
	var mid_point = (start_pos + end_pos) / 2.0
	var direction = (end_pos - start_pos).normalized()
	var perpendicular = Vector2(-direction.y, direction.x)
	
	var spread = 300 
	
	var number_of_trails = ceil(damage / 10.0)
	
	for i in range(number_of_trails):
		var offset_weight = 0.0
		if number_of_trails > 1:
			offset_weight = (float(i) / float(number_of_trails - 1)) * 2.0 - 1.0
			
		var control_point = mid_point + (perpendicular * offset_weight * spread)
		
		var runes_in_this_trail = min(damage - (i * 10), 10)
		
		spawn_single_trail(start_pos, end_pos, control_point, runes_in_this_trail)
	
func spawn_single_trail(start_pos: Vector2, end_pos: Vector2, control_point: Vector2, runes_count: int) -> void:
	for i in range(runes_count):
		var projectile = ATTACK_RUNES_PARTICLES.instantiate()
		projectile.play("default")
		add_child(projectile)
		projectile.global_position = start_pos
		
		var tween = create_tween()
		var travel_time = randf_range(0.4, 0.8)
		
		tween.tween_method(
			func(t: float): 
				if is_instance_valid(projectile):
					projectile.global_position = start_pos.bezier_interpolate(control_point, control_point, end_pos, t),
			0.0, 1.0, travel_time
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
					
		var random_spin = randf_range(-PI, PI) * 4
		tween.parallel().tween_property(projectile, "rotation", random_spin, travel_time)
		tween.parallel().tween_property(projectile, "self_modulate:a", 0.0, travel_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		tween.tween_callback(projectile.queue_free)
		
		await get_tree().create_timer(0.05).timeout
