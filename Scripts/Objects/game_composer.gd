extends Node
class_name game_composer
var sequenser_node:sequenzer

var audio_composer_node:audio_composer

var started_game:bool = false

signal start_game()
signal set_sequenser(sequence)
signal set_audio_composer(audiocomposer)
signal use_back_up
#Audio signals
signal set_rec_synth(recording,resource:audio_track_resource.synths)
signal play_synth(_time,resource:audio_track_resource.synths)
signal stop_synth()
signal play_ring_type(resource:beat_ring_button_resource)
signal stop_all_players()

func _ready() -> void:
	start_game.connect(_on_start_game)
	set_sequenser.connect(_on_set_sequenser)
	set_audio_composer.connect(_on_set_audio_composer)

func _on_start_game():
	started_game = true

func _on_set_sequenser(seq):
	if sequenser_node == null: 
		sequenser_node = seq

func _on_set_audio_composer(audiocomposer):
	if audio_composer_node == null:
		audio_composer_node = audiocomposer

func on_fetch_sequenser():
	if sequenser_node == null: 
		use_back_up.emit()
		push_error("Sequenser was not found please check scene")
	return sequenser_node
