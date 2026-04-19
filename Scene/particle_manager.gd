extends Node2D

const ATTACK_RUNES_PARTICLES = preload("uid://c5o0wyqkpyhg2")
const THRIFT_ATTACK_PARTICLE = preload("uid://d2aewh2qfs501")
const SPEND_ATTACK_PARTICLE = preload("uid://dnrmyxh5i5e13")
# S-Curve Attack Settings
const S_CURVE_SPREAD_RATIO = 10
const S_CURVE_BASE_TIME = 0.8
const S_CURVE_ADD_TIME = 0.005

func _ready() -> void:
	pass

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
	if particles.size() > 0:
		for p in particles:
			p.get_child(0).emitting = false
		await get_tree().create_timer(2.0).timeout
		for p in particles:
			p.queue_free()

func play_standard_attack(start_node: Node, target_node: Node, damage: int) -> void:
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


func play_debt_attack(start_node: Node, target_node: Node, damage: int) -> void:
	var start_pos = start_node.global_position
	var end_pos = target_node.global_position 
	
	if start_node is Control:
		start_pos += start_node.size / 2.0
	if target_node is Control:
		end_pos += target_node.size / 2.0
	
	var mid_point = (start_pos + end_pos) / 2.0
	var direction = (end_pos - start_pos).normalized()
	var perpendicular = Vector2(-direction.y, direction.x)
	
	var current_spread = clamp(damage * S_CURVE_SPREAD_RATIO, 10.0, 500.0) 
	
	var pathA_c1 = ( (start_pos + mid_point) / 2.0 ) + (perpendicular * current_spread)
	var pathA_c2 = ( (mid_point + end_pos) / 2.0 ) + (perpendicular * -current_spread)
	
	var pathB_c1 = ( (start_pos + mid_point) / 2.0 ) + (perpendicular * -current_spread)
	var pathB_c2 = ( (mid_point + end_pos) / 2.0 ) + (perpendicular * current_spread)

	var total_travel_time = S_CURVE_BASE_TIME + (damage * S_CURVE_ADD_TIME)
	var runes_count = min(damage, 60)
	
	for i in range(runes_count):
		var projectile = ATTACK_RUNES_PARTICLES.instantiate()
		projectile.play("default")
		add_child(projectile)
		projectile.modulate = Color8(82,0,247) # Changed to Color8 so the purple renders correctly!
		projectile.global_position = start_pos
		
		# --- NEW: Alternate the paths ---
		var is_mirrored = (i % 2 == 0)
		var c1 = pathB_c1 if is_mirrored else pathA_c1
		var c2 = pathB_c2 if is_mirrored else pathA_c2
		
		var tween = create_tween()
		
		tween.tween_method(
			func(t: float): 
				if is_instance_valid(projectile):
					projectile.global_position = start_pos.bezier_interpolate(c1, c1, mid_point, t),
			0.0, 1.0, total_travel_time / 2.0
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT_IN)
					
		tween.tween_method(
			func(t: float): 
				if is_instance_valid(projectile):
					projectile.global_position = mid_point.bezier_interpolate(c2, c2, end_pos, t),
			0.0, 1.0, total_travel_time / 2.0
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT_IN)

		var visual_tween = create_tween().set_parallel(true)
		var random_spin = randf_range(-PI, PI) * 4
		visual_tween.tween_property(projectile, "rotation", random_spin, total_travel_time)
		visual_tween.tween_property(projectile, "self_modulate:a", 0.0, total_travel_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		
		tween.tween_callback(projectile.queue_free)
		
		await get_tree().create_timer(0.05).timeout

func play_thrift_attack(start_node: Node, target_node: Node, amount: int) -> void:
	var start_pos = start_node.global_position
	var end_pos = target_node.global_position 
	
	if start_node is Control:
		start_pos += start_node.size / 2.0
	if target_node is Control:
		end_pos += target_node.size / 2.0
		
	var runes_count = min(amount, 30) 
	
	for i in range(runes_count):
		var projectile = THRIFT_ATTACK_PARTICLE.instantiate()
		
		add_child(projectile)
		
		projectile.global_position = start_pos

		projectile.rotation = (end_pos - start_pos).angle() + deg_to_rad(90)
		var tween = create_tween()
		
		var travel_time = randf_range(0.3,0.5) 
		
		tween.tween_property(projectile, "global_position", end_pos, travel_time).set_trans(Tween.TRANS_LINEAR)
	
		var visual_tween = create_tween()
		visual_tween.tween_property(projectile, "self_modulate:a", 0.0, travel_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		
		tween.tween_callback(projectile.queue_free)

		await get_tree().create_timer(0.10).timeout

func play_spend_attack(start_node: Node, target_node: Node, amount: int) -> void:
	var start_pos = start_node.global_position
	var end_pos = target_node.global_position 
	
	if start_node is Control:
		start_pos += start_node.size / 2.0
	if target_node is Control:
		end_pos += target_node.size / 2.0
		
	var mid_point = (start_pos + end_pos) / 2.0
	var direction = (end_pos - start_pos).normalized()
	var perpendicular = Vector2(-direction.y, direction.x)
	
	# Make the arc slightly wider than standard damage so they don't visually overlap
	var base_spread = 350.0 
	var runes_count = min(amount, 30) 
	
	for i in range(runes_count):
		var projectile = SPEND_ATTACK_PARTICLE.instantiate()
		add_child(projectile)
		projectile.global_position = start_pos
		
		# Alternate the curves: Evens swing right, Odds swing left
		var side_modifier = 1.0 if i % 2 == 0 else -1.0
		# Add a little randomness so the curve isn't perfectly identical every time
		var current_spread = base_spread * side_modifier
		
		var control_point = mid_point + (perpendicular * current_spread)
		
		var tween = create_tween()
		var travel_time = 0.8
		
		# The Bezier Curve Movement
		tween.tween_method(
			func(t: float): 
				if is_instance_valid(projectile):
					projectile.global_position = start_pos.bezier_interpolate(control_point, control_point, end_pos, t),
			0.0, 1.0, travel_time
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
					
		# The Spin and Fade Visuals
		var visual_tween = create_tween().set_parallel(true)
		# A fast spin! (Multiplied by a random direction)
		var random_spin = (PI * 6) * (1 if randf() > 0.5 else -1) 
		visual_tween.tween_property(projectile, "rotation", random_spin, travel_time)
		visual_tween.tween_property(projectile, "self_modulate:a", 0.0, travel_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
		
		tween.tween_callback(projectile.queue_free)
		
		await get_tree().create_timer(0.05).timeout
		
		
func trigger_attack(start_node: Node, target_node: Node, amount: int, damage_type: String = "") -> void:
	if damage_type == "DEBT":
		play_debt_attack(start_node, target_node, amount)
	elif damage_type == "THRIFT":
		play_thrift_attack(start_node, target_node, amount)
	elif damage_type == "SPEND":
		play_spend_attack(start_node, target_node, amount / 2)
	elif amount > 0:
		play_standard_attack(start_node, target_node, amount)
