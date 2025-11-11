extends Node

@export_group("Timing")
@export var bpm:float
@export var notes_per_beat:int
@export var beat_length:float
@export var note_length:float
@export var beats_per_section = 4
@export var notes:Dictionary[String,int]

@export_group("Audiostreams")
@export var metronome_sound :AudioStream
@export var alt_sound:AudioStream
@export var trompet_sound:AudioStream
@export var hihat_sound:AudioStream

var kick_player:AudioStreamPlayer = AudioStreamPlayer.new()
var klap_player:AudioStreamPlayer = AudioStreamPlayer.new()
var trompet_player:AudioStreamPlayer = AudioStreamPlayer.new()
var hihat_player:AudioStreamPlayer = AudioStreamPlayer.new()

const fixed_seconds:int = 60
var seconds:float
var _total_time :=0.0


var kick_ring_timer:Timer = Timer.new()
var klap_ring_timer:Timer = Timer.new()
var trompet_ring_timer:Timer = Timer.new()
var hihat_ring_timer:Timer = Timer.new()
var kick_ring_string:String = "kick_ring"
var klap_ring_string:String = "klap_ring"
var trompet_ring_string:String = "trompet_ring"
var hihat_ring_string:String = "hihat_ring"

var _beat:int = 0
var playing = false

var kick_ring:Array[bool]
var klap_ring:Array[bool]
var trompet_ring:Array[bool]
var hihat_ring:Array[bool]

signal change_note_active_status(beat_ring_enum:beat_ring_button_resource.ring_types, note:int)

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

func _setup_dict():
	notes[klap_ring_string] = 0 
	notes[kick_ring_string] = 0
	notes[trompet_ring_string] = 0
	notes[hihat_ring_string] = 0

func _reset_dict():
	for c in notes:
		notes.set(c,0) 

func _calc_beat_time():
	beat_length=fixed_seconds/bpm
	print("beat_length ", beat_length)
	note_length = beat_length / beats_per_section
	print("note_length ",note_length)
	match notes_per_beat:
		8: beats_per_section = 2
		16: beats_per_section = 4
		32: beats_per_section = 8

func _players_setup():
	kick_player.stream = metronome_sound
	kick_player.set_bus("Ring0") 
	klap_player.stream = alt_sound
	klap_player.set_bus("Ring1")
	trompet_player.stream = trompet_sound
	trompet_player.set_bus("Ring2")
	hihat_player.stream = hihat_sound
	hihat_player.set_bus("Ring3")
	add_child(kick_player)
	add_child(klap_player)
	add_child(trompet_player)
	add_child(hihat_player)

func _ready() -> void:
	change_note_active_status.connect(_on_change_note_active_status)
	_setup_array_size()
	_calc_beat_time()
	_players_setup()
	_setup_dict()
	_setup_timer(klap_ring_timer)
	_setup_timer(kick_ring_timer)
	_setup_timer(trompet_ring_timer)
	_setup_timer(hihat_ring_timer)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("main_click"):
		#TODO change this to not be this big
		playing = true
		klap_ring_timer.autostart = true
		klap_ring_timer.start(0)
		kick_ring_timer.autostart = true
		kick_ring_timer.start(0)
		trompet_ring_timer.autostart = true
		trompet_ring_timer.start(0)
		hihat_ring_timer.autostart = true
		hihat_ring_timer.start(0)
	if !playing: 
		_total_time = 0
		return
	_total_time += delta
	seconds = fmod(_total_time,fixed_seconds)
	if(notes[klap_ring_string] == notes_per_beat):
		_beat +=1
	if(_beat == beats_per_section):
		_reset_state()

func _play_sound_per_beat(timer):
	var i:int
	match timer:
		klap_ring_timer: 
			if allowed_to_play(klap_ring,klap_ring_string):
				klap_player.play(0)
			i = notes[klap_ring_string]
			i+=1
			notes.set(klap_ring_string,i)
		kick_ring_timer:
			if allowed_to_play(kick_ring,kick_ring_string):
				kick_player.play(0)
			i = notes[kick_ring_string]
			i+=1
			notes.set(kick_ring_string,i)
		trompet_ring_timer:
			if allowed_to_play(trompet_ring,trompet_ring_string):
				trompet_player.play(0)
			i = notes[trompet_ring_string]
			i+=1
			notes.set(trompet_ring_string,i)
		hihat_ring_timer:	
			if allowed_to_play(hihat_ring,hihat_ring_string):
				hihat_player.play(0)
			i = notes[hihat_ring_string]
			i+=1
			notes.set(hihat_ring_string,i)


func _reset_state():
	_total_time = 0
	_beat = 0
	_reset_dict()
	print("one loop complete")

func allowed_to_play(array:Array[bool],string:String) -> bool:
	var i = notes[string]
	var ring_bool = array.get(i)
	return ring_bool

func _setup_array_size():
	klap_ring.resize(notes_per_beat)
	kick_ring.resize(notes_per_beat)
	trompet_ring.resize(notes_per_beat)
	hihat_ring.resize(notes_per_beat)

func _setup_timer(timer:Timer):
	#TODO Add swing
	timer.wait_time = note_length 
	timer.autostart= false
	timer.timeout.connect(_play_sound_per_beat.bind(timer))
	add_child(timer)
