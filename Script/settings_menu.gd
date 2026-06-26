extends Panel

var is_bgm_muted: bool = false
var previous_volume: float = 100.0
var is_sfx_muted: bool = false
var previous_sfx_volume: float = 100.0
var pause_menu_ui: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var bgm_index = AudioServer.get_bus_index("BGM")
	var current_bgm_db = AudioServer.get_bus_volume_db(bgm_index)
	$MusicSlider.value = db_to_linear(current_bgm_db) * 100.0
	
	var sfx_index = AudioServer.get_bus_index("SFX")
	var current_sfx_db = AudioServer.get_bus_volume_db(sfx_index)
	$SFXSlider.value = db_to_linear(current_sfx_db) * 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


	
	
func _on_mute_0n_off_button_down() -> void:
	is_bgm_muted = !is_bgm_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), is_bgm_muted)
	
	if is_bgm_muted:
		previous_volume = $MusicSlider.value
		$MusicSlider.value = 0
	else:
		$MusicSlider.value = previous_volume
	


func _on_music_slider_value_changed(value: float) -> void:
	var volume_db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), volume_db)
	print("BGM slider: ", value, " → ", volume_db, "dB | bus index: ", AudioServer.get_bus_index("BGM"))
	
	if is_bgm_muted and value > 0:
		is_bgm_muted = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), false)
		
		
	
func _on_sfxon_off_button_down() -> void:
	is_sfx_muted = !is_sfx_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), is_sfx_muted)
	print("BGM mute toggled: ", is_bgm_muted, " | bus index: ", AudioServer.get_bus_index("BGM"))
	
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
	pause_menu_ui.visible = true

func _on_particles_button_up() -> void:
	var partman = get_tree().get_first_node_in_group("particle_manager")
	if partman:
		partman.particles_enabled = !partman.particles_enabled
		print("Particles: ", partman.particles_enabled)


func _on_light_effect_button_up() -> void:
	var light = get_tree().get_first_node_in_group("point_light")
	if light:
		light.enabled = !light.enabled
		print("Light: ", light.enabled)
