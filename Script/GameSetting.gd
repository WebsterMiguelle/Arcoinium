extends Node

signal bgm_volume_changed(value: float)
signal sfx_volume_changed(value: float)
signal bgm_mute_changed(muted: bool)
signal sfx_mute_changed(muted: bool)
signal particles_toggled(enabled: bool)
signal lights_toggled(enabled: bool)

var bgm_volume := 100.0
var sfx_volume := 100.0
var bgm_muted := false
var sfx_muted := false
var particles_enabled := true
var lights_enabled := true

var _previous_bgm_volume := 100.0
var _previous_sfx_volume := 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_apply_audio_settings()

func _apply_audio_settings() -> void:
	var bgm_index := AudioServer.get_bus_index("BGM")
	var sfx_index := AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bgm_index, linear_to_db(bgm_volume / 100.0))
	AudioServer.set_bus_mute(bgm_index, bgm_muted)
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(sfx_volume / 100.0))
	AudioServer.set_bus_mute(sfx_index, sfx_muted)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_bgm_volume(value: float) -> void:
	bgm_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear_to_db(value / 100.0))
	if bgm_muted and value > 0:
		bgm_muted = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), false)
		bgm_mute_changed.emit(false)
	bgm_volume_changed.emit(value)
	
func toggle_bgm_mute() -> bool:
	bgm_muted = !bgm_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), bgm_muted)
	if bgm_muted:
		_previous_bgm_volume = bgm_volume
		set_bgm_volume(0.0)
	else:
		set_bgm_volume(_previous_bgm_volume)
	bgm_mute_changed.emit(bgm_muted)
	return bgm_muted
	
func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value / 100.0))
	if sfx_muted and value > 0:
		sfx_muted = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
		sfx_mute_changed.emit(false)
	sfx_volume_changed.emit(value)
	
func toggle_sfx_mute() -> bool:
	sfx_muted = !sfx_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), sfx_muted)
	if sfx_muted:
		_previous_sfx_volume = sfx_volume
		set_sfx_volume(0.0)
	else:
		set_sfx_volume(_previous_sfx_volume)
	sfx_mute_changed.emit(sfx_muted)
	return sfx_muted
	
func toggle_particles() -> bool:
	particles_enabled = !particles_enabled
	apply_particles_to_group()
	particles_toggled.emit(particles_enabled)
	return particles_enabled
	
func apply_particles_to_group() -> void:
	for partman in get_tree().get_nodes_in_group("particle_manager"):
		if "particles_enabled" in partman:
			partman.particles_enabled = particles_enabled
	
func register_particle_node(node: Node) -> void:
	if "particles_enabled" in node:
		node.particles_enabled = particles_enabled
		
func toggle_lights() -> bool:
	lights_enabled = !lights_enabled
	apply_lights_to_group()
	lights_toggled.emit(lights_enabled)
	return lights_enabled
	
func apply_lights_to_group() -> void:
	for light in get_tree().get_nodes_in_group("point_light"):
		if "enabled" in light:
			light.enabled = lights_enabled
			
func register_light_node(node: Node) -> void:
	if "enabled" in node:
		node.enabled = lights_enabled
