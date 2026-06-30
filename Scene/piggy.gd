extends Node2D
@onready var piggy: AnimatedSprite2D = $piggy
var spawn_position_x
var spawn_position_y
var main
var away_from_spawn = false
const GAIN_EFFECT_PARTICLE = preload("uid://c5py6ekby1mnm")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func roam(x,y,sec,cooldown):
	piggy.flip_h = false
	var current_x = position.x
	var current_y = position.y
	var roam_tween = create_tween()
	roam_tween.parallel().tween_property(self,"position:x",current_x + x,sec)
	roam_tween.parallel().tween_property(self,"position:y",current_y + y,sec)
	await roam_tween.finished
	await get_tree().create_timer(cooldown).timeout
	if main.enemy.coin > 0:
		go_home(randi_range(4,8),randi_range(2,6))
		
func setup(spawn_x,spawn_y,m):
	spawn_position_x = spawn_x
	spawn_position_y = spawn_y
	global_position = Vector2(spawn_x,spawn_y)
	main = m
	await get_tree().create_timer(randi_range(3,7)).timeout
	away_from_spawn = true
	roam(randi_range(-100,60),randi_range(-100,100),randi_range(2,5),randi_range(2,6))

func go_home(sec,cooldown):
	piggy.flip_h = true
	var roam_tween = create_tween()
	roam_tween.parallel().tween_property(self,"position:x",spawn_position_x,sec)
	roam_tween.parallel().tween_property(self,"position:y", spawn_position_y,sec)
	await roam_tween.finished
	await get_tree().create_timer(cooldown).timeout
	if main.enemy.coin > 0:
		roam(randi_range(-100,60),randi_range(-100,100),randi_range(2,5),randi_range(2,6))

func shine():
	main.particle_manager.spawn_particle(GAIN_EFFECT_PARTICLE,global_position)
	self.modulate = Color("#ffffff")
	var shine_tween = create_tween()
	shine_tween.tween_property(self,"modulate",Color("#f68e00df"),0.1)
	await shine_tween.finished
	var fade_tween = create_tween()
	fade_tween.tween_property(self,"modulate",Color("#ffffff"),1.0)
