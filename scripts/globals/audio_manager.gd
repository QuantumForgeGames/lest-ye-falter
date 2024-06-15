extends Node2D


@export var _AudioSpawner :Node
@export var _BackgroundMusic :AudioStreamPlayer
@export var BackgroundChanting :AudioStreamPlayer

@export var audio_dissenter_active :Array[AudioStreamWAV] = []
@export var audio_doubter_active :Array [AudioStreamWAV] = []


func _ready () -> void:
    _BackgroundMusic.play()
    # connect cultist state change signals to audio cues
    EventManager.cultist_state_changed.connect(_spawn_cultist_state_change)


func _spawn_cultist_state_change (cultist :Cultist) -> void:
    match cultist.get_current_state():
        "Doubt": play_stream_oneshot(audio_doubter_active.pick_random())
        "Dissent": play_stream_oneshot(audio_dissenter_active.pick_random())
        _: return


func play_stream_oneshot (stream :AudioStream) -> void:
    var audio_player = AudioStreamPlayer.new()
    _AudioSpawner.add_child(audio_player)
    audio_player.stream = stream
    audio_player.finished.connect(func(): audio_player.queue_free())
    audio_player.play()