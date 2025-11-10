extends Node2D
@onready var ring:Sprite2D= $Ring
@onready var filling:Sprite2D =$Filling
@export var resource:beat_ring_button_resource
var back_up_player:AudioStreamPlayer 

signal activate_back_up()

var active:bool = false
var audio_backup:bool = true

#Method meant to setup the button, get the color for items in the button and connect any signals that need to be connected.
#Should more items come to the button that need to be colored, for loop should be used instead.
func _ready() -> void:
	ring.modulate = resource.get_color()
	filling.modulate = resource.get_color()
	activate_back_up.connect(_on_audio_back_up)

#When pressing the button we set it active, true or false, and fill it in true or false
func _on_texture_button_pressed() -> void:
	active = !active
	filling.visible= active
	#TODO replace with sequencer signal to set position in beat

#This signal connection is going to tell the system to play when this beat button gets hit by the needle
func _on_area_2d_area_entered(_area: Area2D) -> void:
	if !active: return
	#TODO replace with sequencer signal to set position in beat
	_on_audio_back_up()
	if audio_backup:
		back_up_player.play(0)

#This method is meant to be called should anything go wrong with the audio system. This is an easy back up to play one sound from the resource
func _on_audio_back_up():
	if(back_up_player == null):
		back_up_player= AudioStreamPlayer.new()
		back_up_player.bus=resource.get_bus_name()
		add_child(back_up_player)
		back_up_player.stream = resource.default_audio
	audio_backup = true
