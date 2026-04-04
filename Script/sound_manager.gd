extends Node2D

@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
var playback: AudioStreamPlaybackPolyphonic

@onready var bgm_player: AudioStreamPlayer2D = $"BGMPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	playback = sfx_player.get_stream_playback()


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
