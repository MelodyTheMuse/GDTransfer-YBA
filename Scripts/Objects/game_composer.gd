extends Node
class_name game_composer
var started_game:bool = false

signal start_game()
#signal set_sequenser(sequence)
signal use_back_up
#Audio signals
signal set_rec_synth(recording,resource:audio_track_resource.synths)
signal play_synth(_time,resource:audio_track_resource.synths)
signal stop_synth()
signal play_ring_type(resource:beat_ring_button_resource)
signal stop_all_players()
#Sequencer
signal retrieve_seconds()
signal retrieve_note_length()
signal retrieve_notes_per_beat()
signal set_seconds(sec)
signal set_note_length(note_length)
signal set_notes_per_beat(notes)
signal change_note_active_status(beat_ring_enum:beat_ring_button_resource.ring_types, note:int)
signal prepare_for_recording
signal loop_completed
signal change_play_state(active)

func _ready() -> void:
	start_game.connect(_on_start_game)
	#set_sequenser.connect(_on_set_sequenser)

func _on_start_game():
	started_game = true

#func _on_set_sequenser(seq):
	#if sequenser_node == null: 
		#sequenser_node = seq
#
#func on_fetch_sequenser():
	#if sequenser_node == null: 
		#use_back_up.emit()
		#push_error("Sequenser was not found please check scene")
	#return sequenser_node
