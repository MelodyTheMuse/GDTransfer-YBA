extends Node
var bps
@export var bpm:float
@export var notes_per_beat:int
@export var _beat:int
@export var beat_lenght:float
@export var note_lenght:float
const fixed_seconds:int = 60
var seconds:float
@export var beats_per_section = 16
var beat_timer:Timer
var _total_time :=0.0
@export var metronome_sound :AudioStream
@export var alt_sound:AudioStream
var player:AudioStreamPlayer = AudioStreamPlayer.new()
var player2:AudioStreamPlayer = AudioStreamPlayer.new()
var playing = true
var even_timer:Timer = Timer.new()
var on_even_timer:Timer = Timer.new()


func _calc_beat_time():
	beat_lenght=fixed_seconds/bpm
	print("beat_length ", beat_lenght)
	note_lenght = beat_lenght / beats_per_section
	print("note_lenght ",note_lenght)

func _ready() -> void:
	_calc_beat_time()
	player.stream = metronome_sound
	player2.stream = alt_sound
	add_child(player)
	add_child(player2)
	_setup_timers()
	add_child(even_timer)
	add_child(on_even_timer)

func _process(delta: float) -> void:
	if !playing: 
		_total_time = 0
		return
	_total_time += delta
	seconds = fmod(_total_time,fixed_seconds)
	if(_beat == notes_per_beat):
		_reset_state()

func _play_sound_per_beat():
	player.play(0)
	print("played")
	_beat += 1

func _play_oneven():
	player2.play(0)
	print("played2")
	_beat += 1

func _reset_state():
	_total_time = 0
	_beat = 0

func _change_timer():
	on_even_timer.disconnect("timeout", _change_timer)
	on_even_timer.wait_time = note_lenght
	on_even_timer.autostart = true
	on_even_timer.timeout.connect(_play_oneven)
	

func _setup_timers():
	#TODO Add swing
	even_timer.wait_time = beat_lenght 
	even_timer.autostart= true
	even_timer.timeout.connect(_play_sound_per_beat)
	#on_even_timer.wait_time = note_lenght*2
	#on_even_timer.autostart = true
	#on_even_timer.timeout.connect(_change_timer)
