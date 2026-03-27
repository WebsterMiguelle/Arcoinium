extends Node2D

@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
var playback: AudioStreamPlaybackPolyphonic

@onready var bgm_player: AudioStreamPlayer2D = $"BGMPlayer"
var synchronizer: AudioStreamSynchronized


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playback = sfx_player.get_stream_playback()
	synchronizer = bgm_player.stream
	bgm_to_combat()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sound(stream: AudioStream):
	if !sfx_player.playing:
		sfx_player.play()
		playback = sfx_player.get_stream_playback()

	playback.play_stream(stream)

func bgm_to_exploration():
	synchronizer.set_sync_stream_volume(1, 0)
	synchronizer.set_sync_stream_volume(2, -60)
	
func bgm_to_combat():
	synchronizer.set_sync_stream_volume(1, 0)
	synchronizer.set_sync_stream_volume(2, 0)

func bgm_to_mute():
	synchronizer.set_sync_stream_volume(1, -60)
	synchronizer.set_sync_stream_volume(2, -60)
