extends Sprite2D
@onready var sequencer :sequenzer = GameComposer.sequenser_node
var active:bool = false

func _ready() -> void:
	sequencer.change_play_state.connect(_on_change_play_state)
func _process(_delta: float) -> void:
	if sequencer == null : sequencer = GameComposer._on_fetch_sequenser()
	if active:
		var rotation_factor:float = (-1+(sequencer.seconds  / sequencer.note_length )) / sequencer.notes_per_beat
		var calc_rotation_degree:float  = rotation_factor * 360  - 7
		rotation_degrees = calc_rotation_degree
		#print("rotation_factor : ",rotation_factor) 
		#print("float Facotr : ",calc_rotation_degree) 
		#print("sequencer current beat : ",sequencer.current_beat)
		#print("beat timer : ",sequencer.beat_timer)
		#print("sequencer.time_per_beat : ",sequencer.time_per_beat)
		#print(" sequencer.amount_of_beats : ", sequencer.amount_of_beats)

func _on_change_play_state(state):
	active = state
