extends Node2D

var _active:bool

@onready var play_pause_button = $PlayPauseButton
@onready var sequenser:sequenzer = GameComposer.sequenser_node

signal play_button_pressed()

func _ready() -> void:
	if sequenser == null : sequenser = GameComposer.sequenser_node



func _on_play_pause_button_button_up() -> void:
	pass

func _on_play_pause_button_pressed() -> void:
	_active = !_active
	if sequenser != null:sequenser.change_play_state.emit(_active)
	match _active:
		true:
			GameComposer.play_synth.emit(sequenser._total_time,audio_track_resource.synths.GREEN)
			play_pause_button.text = "⏸️"
		false: 
			GameComposer.stop_synth.emit()
			play_pause_button.text = "▶️"
	play_button_pressed.emit()

func _print_midi_info(midi_event):
	#if delay: return
	if(midi_event.message == 250):
		_on_play_pause_button_pressed()
		print("started")
	if(midi_event.message == 252):
		_on_play_pause_button_pressed()
	if(midi_event.message == 248):
		pass
			#print("this is the clock")
		#else:
			#var bps =0.0
			#var bpm = 0
			#bps =clock / 24
			#bpm = bps * 6
			#print("Your bpm is ", bpm)

func _input(input_event):
	if input_event is InputEventMIDI:
		_print_midi_info(input_event)
