extends Node2D

func _ready() -> void:
	GameComposer.start_game.emit()
