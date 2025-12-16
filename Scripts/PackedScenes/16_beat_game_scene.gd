extends Node
@onready var bpm :BpmManagerGD = BpmManager
var beats_amount = BeatsAmountResource.new()
var path = "user://beats_amount.tres"
var error = ResourceSaver.save(beats_amount, path)
func _ready() -> void:
	if error != OK:
		print("error saving file")
	else:
		print("file saved")
	if error == OK:
		GameComposer.start_game.emit()
func _process(_delta: float) -> void:
	pass
