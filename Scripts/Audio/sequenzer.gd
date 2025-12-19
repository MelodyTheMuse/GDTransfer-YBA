extends Node

class_name sequenzer

@export_category("Timing")
@export var bpm:float = 90
@export var notes_per_beat:int = 16
@export var beat_length:float
@export var note_length:float
@export var beats_per_section = 4
@export var notes:Dictionary[String,int]
@export var current_note = 0
var first_note = true

const fixed_seconds:int = 60
var seconds:float
@export var _total_time :=0.0

var ring_timer:Timer = Timer.new()
var kick_ring_string:String = "kick_ring"
var klap_ring_string:String = "klap_ring"
var trompet_ring_string:String = "trompet_ring"
var hihat_ring_string:String = "hihat_ring"

var _beat:int = 0
@export var playing = false

var kick_ring:Array[bool]
var klap_ring:Array[bool]
var trompet_ring:Array[bool]
var hihat_ring:Array[bool]

var record:bool = false

signal change_note_active_status(beat_ring_enum:beat_ring_button_resource.ring_types, note:int)
signal change_play_state(active)
signal set_song_settings(bank:audio_bank)
signal loop_completed()

func _ready() -> void:
	name = "sequenser"
	change_note_active_status.connect(_on_change_note_active_status)
	change_play_state.connect(_on_change_play_state)
	_calculate_beat_and_note_length()
	_set_array_sizes()
	_set_value_notes_dictionary_for_ring_strings()
	_setup_timer(ring_timer)
	GameComposer.set_sequenser.emit(self)
	loop_completed.connect(on_loop_completed)

#This fucntion set's the array sizes based on notes_per_beat
func _set_array_sizes():
	klap_ring.resize(notes_per_beat)
	kick_ring.resize(notes_per_beat)
	trompet_ring.resize(notes_per_beat)
	hihat_ring.resize(notes_per_beat)

#This func set's up the dictionary so that it can hold the current note per ring
func _set_value_notes_dictionary_for_ring_strings():
	notes[klap_ring_string] = 0 
	notes[kick_ring_string] = 0
	notes[trompet_ring_string] = 0
	notes[hihat_ring_string] = 0

#This function calculates the beat and note lentgh so the sequencer can use it
func _calculate_beat_and_note_length():
	match notes_per_beat:
		8: beats_per_section = 2
		16: beats_per_section = 4
		32: beats_per_section = 8
	beat_length=fixed_seconds/bpm
	print("beat_length ", beat_length)
	note_length = beat_length / beats_per_section
	print("note_length ",note_length)

func _process(delta: float) -> void:
	if !playing: 
		return
	_total_time += delta
	seconds = fmod(_total_time,fixed_seconds)
	if(current_note >= notes_per_beat):
		_reset_counters()
		loop_completed.emit()
	if(_beat == beats_per_section):
		pass

#Based on the bool active start on true or stop on false
func _on_change_play_state(active):
	playing = active
	ring_timer.autostart = active
	ring_timer.paused = !active
	if ring_timer.is_stopped():
		ring_timer.start(0)

#This func gets called when signal gets emitted, so that we can set the status of the note based on the buttons of the beat ring
func _on_change_note_active_status(beat_ring_enum:beat_ring_button_resource.ring_types, note:int):
	match beat_ring_enum:
		beat_ring_button_resource.ring_types.KLAP:
			klap_ring[note] = !klap_ring[note]
		beat_ring_button_resource.ring_types.STOMP:
			kick_ring[note] = !kick_ring[note]
		beat_ring_button_resource.ring_types.TROMPET:
			trompet_ring[note] = !trompet_ring[note]
		beat_ring_button_resource.ring_types.HIHAT:
			hihat_ring[note] = !hihat_ring[note]

#Resest the dictionaries back to 0
func _reset_dictionary():
	for c in notes:
		notes.set(c,0) 

#This happens only on backup, play on local audioStreamPlayer based on  given array string and player
func _on_play(ring_array:Array, ring_string:String, ring_player:AudioStreamPlayer):
	var i:int
	if _check_allowed_play_on_dictionary_value(ring_array,ring_string):
		ring_player.play(0)
	i = notes[ring_string]
	i+=1
	notes.set(ring_string,i)
	if current_note < i:
		current_note = i

#Happens normaly emit signal when allowed to play with the given information
func _emit_on_play(ring_array:Array, ring_string:String,ring_type:beat_ring_button_resource.ring_types):
	var i:int
	if _check_allowed_play_on_dictionary_value(ring_array,ring_string):
		GameComposer.play_ring_type.emit(ring_type)
	i = notes[ring_string]
	i+=1
	notes.set(ring_string,i)
	current_note = i

#Reset the counters back to 0
func _reset_counters():
	_total_time = 0
	_beat = 0
	current_note = 1
	GameComposer.play_synth.emit(_total_time,audio_track_resource.synths.GREEN)
	_reset_dictionary()

#Check if it is allowed to play based on the index value of the dictionary 
func _check_allowed_play_on_dictionary_value(array:Array[bool],string:String) -> bool:
	var i = notes[string]
	var array_amount = array.size()-1
	var ring_bool
	if(i > array_amount):
		ring_bool = array.get(array_amount)
	else: ring_bool = array.get(i)
	if ring_bool == true:
		return true
	return false

#Setup the timer of the sequencer with the length of the note and connect to _on_timeout
func _setup_timer(timer:Timer):
	timer.wait_time = note_length
	timer.autostart= false
	timer.timeout.connect(_on_timeout)
	timer.paused = true
	add_child(timer)

#Happens when timer goes to time out. for every item in notes we call emit on play
func _on_timeout():
	for key in notes.keys():
		match key:
			klap_ring_string: 
				_emit_on_play(klap_ring,key,beat_ring_button_resource.ring_types.KLAP)
			kick_ring_string:
				_emit_on_play(kick_ring,key,beat_ring_button_resource.ring_types.STOMP)
			trompet_ring_string:
				_emit_on_play(trompet_ring,key,beat_ring_button_resource.ring_types.TROMPET)
			hihat_ring_string:	
				_emit_on_play(hihat_ring,key,beat_ring_button_resource.ring_types.HIHAT)

#TODO set the audio banks information that is relevent, bpm beats and notes.
func _on_set_song_setting(bank:audio_bank):
	pass

func prepare_for_recording():
	record = true
	_on_change_play_state(false)
	_reset_counters()

func on_loop_completed():
	record = false
