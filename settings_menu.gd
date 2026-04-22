extends Panel

var is_muted: bool = false
var previous_volume: float = 100.0
var is_sfx_muted: bool = false
var previous_sfx_volume: float = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var current_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	$MusicSlider.value = db_to_linear(current_volume) * 100
	
	var current_sfx_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	$SFXSlider.value = db_to_linear(current_sfx_volume) * 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
	
func _on_mute_0n_off_button_down() -> void:
	is_muted = !is_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), is_muted)
	
	#if SoundManager:
		#SoundManager.bgm_player.stream_paused = is_muted
	
	if is_muted:
		previous_volume = $MusicSlider.value
		$MusicSlider.value = 0
	else:
		$MusicSlider.value = previous_volume
	


func _on_music_slider_value_changed(value: float) -> void:
	var volume_linear = value / 100.0
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(volume_linear)
	)
	
		
	if is_muted and value > 0:
		is_muted = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		
		
	
func _on_sfxon_off_button_down() -> void:
	is_sfx_muted = !is_sfx_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), is_sfx_muted)
	
	
	if is_sfx_muted:
		previous_sfx_volume = $SFXSlider.value
		$SFXSlider.value = 0
	else:
		$SFXSlider.value = previous_sfx_volume
	
	
func _on_sfx_slider_value_changed(value: float) -> void:
	var volume_linear = value / 100.0
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(volume_linear)
	)
		
	if is_sfx_muted and value > 0:
		is_sfx_muted = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false)
	


func _on_back_pressed() -> void:
	self.visible = false 
	get_parent().visible = true

func _on_particles_button_up() -> void:
	var partman = get_tree().get_first_node_in_group("particles_manager")
	if partman:
		partman.particles_enabled = !partman.particles_enabled
		print("Particles: ", partman.particles_enabled)


func _on_light_effect_button_up() -> void:
	var light = get_tree().get_first_node_in_group("point_light")
	if light:
		light.enabled = !light.enabled
		print("Light: ", light.enabled)
