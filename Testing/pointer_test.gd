extends Sprite2D
@onready var bpm :sequenzer = GameComposer._on_fetch_sequenser()
var active:bool = false

func _ready() -> void:
	bpm.change_play_state.connect(_on_change_play_state)
func _process(_delta: float) -> void:
	if bpm == null : bpm = GameComposer._on_fetch_sequenser()
	if active:
		var rotation_factor:float = (bpm.current_note-1 as float  + (bpm._total_time  / bpm.note_length )) / bpm.notes_per_beat as float 
		var calc_rotation_degree:float  = rotation_factor * 360  - 7
		rotation_degrees = calc_rotation_degree
		#print("rotation_factor : ",rotation_factor) 
		#print("float Facotr : ",calc_rotation_degree) 
		#print("bpm current beat : ",bpm.current_beat)
		#print("beat timer : ",bpm.beat_timer)
		#print("bpm.time_per_beat : ",bpm.time_per_beat)
		#print(" bpm.amount_of_beats : ", bpm.amount_of_beats)

func _on_change_play_state(state):
	active = state
