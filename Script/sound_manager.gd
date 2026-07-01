extends Node2D

@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
var playback: AudioStreamPlaybackPolyphonic
@onready var bgm_player: AudioStreamPlayer2D = $"BGMPlayer"
var is_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	sfx_player.bus = "SFX"
	sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	sfx_player.play()
	playback = sfx_player.get_stream_playback()
	
	if bgm_player:
		bgm_player.bus = "BGM"
		bgm_player.process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sound(stream: AudioStream):
	if !sfx_player.playing:
		sfx_player.play()
		playback = sfx_player.get_stream_playback()
	playback.play_stream(stream)

func play_music(stream):
	if !bgm_player.playing:
		bgm_player.stream = stream
		bgm_player.play()
		
func stop_music():
	bgm_player.stop()
	
	
func pause_sfx():
	is_paused = true
	
func resume_sfx():
	is_paused = false
	if !sfx_player.playing:
		sfx_player.play()
		playback = sfx_player.get_stream_playback()
