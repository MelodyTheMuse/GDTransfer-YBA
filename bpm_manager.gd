extends Node
class_name BpmManagerGD
# BPM property with signal
@export var _bpm: int = 90:
	set(value):
		_bpm = value
		on_bpm_changed.emit(_bpm)
	get:
		return _bpm

# Timing
@export var amount_of_beats: int:
	get:
		return amount_of_beats

# Playing state
@export var _playing: bool = false:
	set(value):
		if _playing != value:
			on_playing_changed.emit(value)
		_playing = value
	get:
		return _playing

@export var current_beat: int = amount_of_beats - 1
var beat_timer: float = 0.0
@export var swing: float = 0.5

var base_time_per_beat: float
var time_per_beat: float

var started_game:bool = false

# Signals
signal on_beat_event()
signal on_bpm_changed(new_bpm: float)
signal on_playing_changed(is_playing: bool)
signal on_starting_game(amount:int, current_beat:int)


func _on_starting_game():
	amount_of_beats = read_beats_amount()
	current_beat = amount_of_beats - 1
	started_game = true

func _ready():
	on_starting_game.connect(_on_starting_game)


func _process(delta: float):
	if!started_game: return
	if !_playing: return
	
	beat_timer += delta
	var beats_per_bar: float = 4.0
	base_time_per_beat = 60.0 / _bpm / beats_per_bar
	time_per_beat = base_time_per_beat
	#if current_beat % 2 == 1:
		#time_per_beat = base_time_per_beat + (base_time_per_beat * swing)
	#else:
		#time_per_beat = base_time_per_beat - (base_time_per_beat * swing)
		
	if beat_timer > time_per_beat:
		beat_timer -= time_per_beat
		current_beat = (current_beat + 1) % amount_of_beats
		on_beat_event.emit()


func read_beats_amount() -> int:
	var amount: int
	
	# Check for resource file first
	var resource_path: String = "user://beats_amount.tres"
	if ResourceLoader.exists(resource_path):
		var resource = ResourceLoader.load(resource_path)
		if resource and "beats_amount" in resource:
			amount = resource.beats_amount
			print("beats_amount.tres found: ", amount, " beats")
			return amount
	
	# Fallback to txt file (legacy support)
	var txt_path: String = ProjectSettings.globalize_path("user://") + "/beats_amount.txt"
	if FileAccess.file_exists(txt_path):
		var file = FileAccess.open(txt_path, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			amount = int(content)
			
			# Delete the txt file after reading
			DirAccess.remove_absolute(txt_path)
			print("beats_amount.txt found: ", amount, " beats")
			return amount
	
	# Default value
	amount = 16
	push_error("beats_amount resource/file not found in user folder")
	return amount
