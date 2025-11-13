extends Sprite2D
@onready var bpm :sequenzer = GameComposer.sequenser_node

func _ready() -> void:pass
func _process(_delta: float) -> void:
	if bpm == null : bpm = GameComposer.sequenser_node
	if bpm.playing:
		var intergerFactor:float = (bpm.current_note-1 as float  + (bpm._total_time  / bpm.note_length )) / bpm.notes_per_beat as float 
		var floatFactor:float  = intergerFactor * 360  - 7
		rotation_degrees = floatFactor
		#print("IntergerFactor : ",intergerFactor) 
		#print("float Facotr : ",floatFactor) 
		#print("bpm current beat : ",bpm.current_beat)
		#print("beat timer : ",bpm.beat_timer)
		#print("bpm.time_per_beat : ",bpm.time_per_beat)
		#print(" bpm.amount_of_beats : ", bpm.amount_of_beats)
