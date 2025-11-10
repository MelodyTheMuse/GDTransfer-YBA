extends Node

@export var stomp_ring_players :Array[AudioStreamPlayer]
@export var klap_ring_players :Array [AudioStreamPlayer]
@export var trompet_ring_players :Array [AudioStreamPlayer]
@export var hihat_ring_players :Array [AudioStreamPlayer]
@export var theme:String
@export var effect:String
@export var audiostream:AudioStreamPlayer

var stomp_ring:Node2D
var klap_ring:Node2D
var hihat_ring:Node2D
var trompet_ring:Node2D

var soundbank_name
var soundbank_themes:Array[String]
var soundbank_emotions:Array[String]

func _ready() -> void:
	pass
	
