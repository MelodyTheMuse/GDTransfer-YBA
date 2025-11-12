extends Node
class_name game_composer
var beat_sequenser_script:Resource =preload("res://Scripts/sequenzer.gd")
var sequenser_node:sequenzer

var audio_composer_script:Resource = preload("res://Scripts/audio_composer.gd")
var audio_composer_node:audio_composer

var started_game:bool = false

signal start_game()

func _ready() -> void:
	start_game.connect(_on_start_game)

func _on_start_game():
	started_game = true
	if(audio_composer_node == null): 
		audio_composer_node = audio_composer.new()
		audio_composer_node.set_script(audio_composer_script)
	if(sequenser_node == null) : 
		sequenser_node = sequenzer.new()
		sequenser_node.set_script(beat_sequenser_script)
	get_tree().current_scene.add_child(audio_composer_node)
	add_child(sequenser_node)
