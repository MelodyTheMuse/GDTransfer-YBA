extends Node
@export var play_button:Node2D
var effect:AudioEffectRecord
var recording
var rec_time = 4
var rec_button

func _ready() -> void:
	var idx = AudioServer.get_bus_index("Microphone")
	effect = AudioServer.get_bus_effect(idx, 1)

func _on_button_pressed() -> void:
	$Button2.disabled = true
	effect.set_recording_active(true)
	$Button.text = "Stop"
	_set_timer()

func _on_timeout():
	if effect.is_recording_active():
		recording = effect.get_recording()
		$Button2.disabled = false
		effect.set_recording_active(false)
		$Button.text = "Record"
		GameComposer.set_rec_synths.emit(recording)

func _on_set_rec_button(button):
	rec_button = button

func _on_button_2_pressed() -> void:
	print(recording)
	print(recording.format)
	print(recording.mix_rate)
	print(recording.stereo)
	var data = recording.get_data()
	print(data.size())
	$AudioStreamPlayer.stream = recording
	$AudioStreamPlayer.play(0)

func _set_timer():
	if(GameComposer.sequenser_node != null):
		rec_time = GameComposer.sequenser_node.note_length * GameComposer.sequenser_node.notes_per_beat
	get_tree().create_timer(rec_time).timeout.connect(_on_timeout)
