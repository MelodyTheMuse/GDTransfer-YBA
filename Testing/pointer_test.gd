extends Sprite2D
@onready var bpm :BpmManagerGD = BpmManager

func _ready() -> void:
	bpm.on_starting_game.emit()
func _process(_delta: float) -> void:
	if bpm._playing:
		var intergerFactor:float = (bpm.current_beat as float  + (bpm.beat_timer  / bpm.time_per_beat )) / bpm.amount_of_beats as float 
		var floatFactor:float  = intergerFactor * 360  - 7
		rotation_degrees = floatFactor
		
		#print("IntergerFactor : ",intergerFactor) 
		#print("float Facotr : ",floatFactor) 
		#print("bpm current beat : ",bpm.current_beat)
		#print("beat timer : ",bpm.beat_timer)
		#print("bpm.time_per_beat : ",bpm.time_per_beat)
		#print(" bpm.amount_of_beats : ", bpm.amount_of_beats)
