extends Node2D
@onready var play_pause_button = $PlayPauseButton
var _active:bool
var sequenser:sequenzer
signal play_button_pressed()

func _ready() -> void:
	sequenser = GameComposer._on_fetch_sequenser()

func _on_play_pause_button_button_up() -> void:
	pass

func _on_play_pause_button_pressed() -> void:
	_active = !_active
	if sequenser != null:sequenser.change_play_state.emit(_active)
	match _active:
		true:
			GameComposer.play_synth.emit(sequenser._total_time)
			play_pause_button.text = "⏸️"
		false: 
			GameComposer.stop_synth.emit()
			play_pause_button.text = "▶️"
	play_button_pressed.emit()
