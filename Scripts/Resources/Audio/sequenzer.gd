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

signal change_note_active_status(beat_ring_enum:beat_ring_button_resource.ring_types, note:int)
signal change_play_state(active)
signal set_song_settings(bank:audio_bank)

func _ready() -> void:
	name = "sequenser"
	change_note_active_status.connect(_on_change_note_active_status)
	change_play_state.connect(_on_change_play_state)
	_calc_beat_and_note_length()
	_setup_array_sizes()
	_setup_dict()
	_setup_timer(ring_timer)
	GameComposer.set_sequenser.emit(self)

func _setup_array_sizes():
	klap_ring.resize(notes_per_beat)
	kick_ring.resize(notes_per_beat)
	trompet_ring.resize(notes_per_beat)
	hihat_ring.resize(notes_per_beat)

func _setup_dict():
	notes[klap_ring_string] = 0 
	notes[kick_ring_string] = 0
	notes[trompet_ring_string] = 0
	notes[hihat_ring_string] = 0

func _calc_beat_and_note_length():
	beat_length=fixed_seconds/bpm
	print("beat_length ", beat_length)
	note_length = beat_length / beats_per_section
	print("note_length ",note_length)
	match notes_per_beat:
		8: beats_per_section = 2
		16: beats_per_section = 4
		32: beats_per_section = 8

func _process(delta: float) -> void:
	if !playing: 
		return
	_total_time += delta
	seconds = fmod(_total_time,fixed_seconds)
	if(current_note == notes_per_beat):
		_beat +=1
	if(_beat == beats_per_section):
		_reset_counters()

func _on_change_play_state(active):
	playing = active
	ring_timer.autostart = active
	ring_timer.paused = !active
	if ring_timer.is_stopped():
		ring_timer.start(0)


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

func _reset_dict():
	for c in notes:
		notes.set(c,0) 

#func _players_setup():
	#kick_player.stream = metronome_sound
	#kick_player.set_bus("Ring0") 
	#klap_player.stream = alt_sound
	#klap_player.set_bus("Ring1")
	#trompet_player.stream = trompet_sound
	#trompet_player.set_bus("Ring2")
	#hihat_player.stream = hihat_sound
	#hihat_player.set_bus("Ring3")
	#add_child(kick_player)
	#add_child(klap_player)
	#add_child(trompet_player)
	#add_child(hihat_player)

func _on_play(ring_array:Array, ring_string:String, ring_player:AudioStreamPlayer):
	var i:int
	if _check_allowed_play_on_dict_value(ring_array,ring_string):
		ring_player.play(0)
	i = notes[ring_string]
	i+=1
	notes.set(ring_string,i)
	if current_note < i:
		current_note = i

func _emit_on_play(ring_array:Array, ring_string:String,ring_type:beat_ring_button_resource.ring_types):
	var i:int
	if _check_allowed_play_on_dict_value(ring_array,ring_string):
		GameComposer.play_ring_type.emit(ring_type)
	i = notes[ring_string]
	i+=1
	notes.set(ring_string,i)
	current_note = i

func _reset_counters():
	_total_time = 0
	_beat = 0
	current_note = 0
	GameComposer.play_synth.emit(_total_time)
	_reset_dict()
	print("one loop complete")

func _check_allowed_play_on_dict_value(array:Array[bool],string:String) -> bool:
	var i = notes[string]
	var ring_bool = array.get(i)
	if ring_bool == true:
		return true
	return false

func _setup_timer(timer:Timer):
	#TODO Add swing
	timer.wait_time = note_length 
	timer.autostart= false
	timer.timeout.connect(_on_timeout)
	timer.paused = true
	add_child(timer)

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

func _on_set_song_setting(bank:audio_bank):
	pass
