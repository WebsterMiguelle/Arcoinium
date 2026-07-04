extends Panel

var pause_menu_ui: Node = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$MusicSlider.value = GameSettings.bgm_volume
	$SFXSlider.value = GameSettings.sfx_volume
	_update_particles_visual(GameSettings.particles_enabled)
	_update_lights_visual(GameSettings.lights_enabled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func _on_mute_0n_off_button_down() -> void:
	var muted := GameSettings.toggle_bgm_mute()
	$MusicSlider.value = GameSettings.bgm_volume
	print("BGM mute toggled: ", muted)
	

func _on_music_slider_value_changed(value: float) -> void:
	GameSettings.set_bgm_volume(value)
	
	
func _on_sfxon_off_button_down() -> void:
	var muted := GameSettings.toggle_sfx_mute()
	$SFXSlider.value = GameSettings.sfx_volume
	print("SFX mute toggled: ", muted)
	
func _on_sfx_slider_value_changed(value: float) -> void:
	GameSettings.set_sfx_volume(value)
	
	
func _on_back_pressed() -> void:
	self.visible = false
	if pause_menu_ui:
		pause_menu_ui.visible = true

func _on_particles_button_up() -> void:
	var enabled := GameSettings.toggle_particles()
	_update_particles_visual(enabled)
	print("Particles: ", enabled)

func _on_light_effect_button_up() -> void:
	var enabled := GameSettings.toggle_lights()
	_update_lights_visual(enabled)
	print("Light: ", enabled)
	
	
func _update_particles_visual(enabled: bool) -> void:
	$Particles.button_pressed = enabled
func _update_lights_visual(enabled: bool) -> void:
	$LightEffect.button_pressed = enabled
