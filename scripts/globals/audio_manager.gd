extends Node2D


@export var _AudioSpawner :Node
@export_group("background")
@export var _BackgroundMusic :AudioStreamPlayer
@export var BackgroundChanting :AudioStreamPlayer

@export_group("cultists")
@export var audio_dissenter_active :Array[AudioStreamWAV] = []
@export var audio_doubter_active :Array[AudioStreamWAV] = []

@export_group("minigame")
@export var audio_minigame_notes :Array[AudioStreamWAV] = []
@export var audio_minigame_win :AudioStreamWAV
@export var audio_minigame_lose :AudioStreamWAV

@export_group("punchbowl")
@export var audio_punchbowl_drink :Array[AudioStreamWAV]
@export var audio_punchbowl_fill :AudioStreamWAV

@export_group("level results")
@export var audio_game_win :AudioStreamWAV
@export var audio_game_lose :AudioStreamWAV


func _ready () -> void:
	_BackgroundMusic.play()
	BackgroundChanting.play()

	# connect cultist state change signals to audio cues
	EventManager.cultist_state_changed.connect(_spawn_cultist_state_change)
	EventManager.level_lost.connect(play_stream_oneshot.bind(audio_game_lose))
	EventManager.level_won.connect(play_stream_oneshot.bind(audio_game_win))


func _spawn_cultist_state_change (cultist :Cultist) -> void:
	match cultist.get_current_state():
		"Doubt": play_stream_oneshot(audio_doubter_active.pick_random())
		"Dissent": play_stream_oneshot(audio_dissenter_active.pick_random())
		_: return


func reset_chanting () -> void:
	self.create_tween().tween_property(BackgroundChanting, "volume_db", -40., 1.5)


func play_stream_oneshot (stream :AudioStream) -> void:
	var audio_player = AudioStreamPlayer.new()
	_AudioSpawner.add_child(audio_player)
	audio_player.stream = stream
	audio_player.finished.connect(func(): audio_player.queue_free())
	audio_player.play()