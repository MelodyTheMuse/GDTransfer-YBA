extends Node2D
@onready var play_pause_button = $PlayPauseButton
var _active:bool

func _ready() -> void:
	pass



func _on_play_pause_button_button_up() -> void:
	pass


func _on_play_pause_button_pressed() -> void:
	_active = !_active
	GameComposer.sequenser_node.change_play_state.emit(_active)
	match _active:
		true:
			play_pause_button.text = "⏸️"
		false: 
			play_pause_button.text = "▶️"
