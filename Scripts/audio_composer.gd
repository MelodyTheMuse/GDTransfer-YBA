extends Node

class_name audio_composer

@export_category("Ring Players")
@export var stomp_ring_players :Array[AudioStreamPlayer]
@export var klap_ring_players :Array [AudioStreamPlayer]
@export var trompet_ring_players :Array [AudioStreamPlayer]
@export var hihat_ring_players :Array [AudioStreamPlayer]
@export_category("Audio Sources")
@export var bank:audio_bank

var green_rec
var audiostreamplayer = AudioStreamPlayer.new()
var backup_bank:audio_bank = preload("res://Assets/Audio/back_up/default.tres")
var stomp_ring:Node2D
var klap_ring:Node2D
var hihat_ring:Node2D
var trompet_ring:Node2D

var right_player = 0
var left_player = 1
var mic_player = 2

signal play_ring_type(ring_type:beat_ring_button_resource.ring_types)
signal set_rec_synths(recording)

func _ready() -> void:
	GameComposer.set_audio_composer.emit(self)
	name = "audio_composer"
	_setup_players(stomp_ring_players, "Ring0")
	_setup_players(klap_ring_players, "Ring1")
	_setup_players(trompet_ring_players, "Ring2")
	_setup_players(hihat_ring_players, "Ring3")
	play_ring_type.connect(_on_play)
	if bank != null:
		_fill_players(bank)
	else:
		pass
		_fill_players(backup_bank)

func _on_play(ring_type:beat_ring_button_resource.ring_types):
	match ring_type:
		beat_ring_button_resource.ring_types.KLAP:
			_set_player_volumes()
			klap_ring_players[right_player].play(0)
			#for player in klap_ring_players:
				#player.play(0)
		beat_ring_button_resource.ring_types.STOMP:
			_set_player_volumes()
			stomp_ring_players[right_player].play(0)
			#for player in stomp_ring_players:
				#player.play(0)
		beat_ring_button_resource.ring_types.TROMPET:
			_set_player_volumes()
			trompet_ring_players[right_player].play(0)
			#for player in trompet_ring_players:
				#player.play(0)
		beat_ring_button_resource.ring_types.HIHAT:
			_set_player_volumes()
			hihat_ring_players[right_player].play(0)
			#for player in hihat_ring_players:
				#player.play(0)

func _set_player_volumes():
	pass

func _get_players_volumes():
	pass

func _setup_players(ring_player, bus):
	ring_player.resize(4)
	var i = 0
	for c in ring_player:
		c = AudioStreamPlayer.new()
		c.set_bus(bus)
		ring_player.set(i,c)
		i+=1
		add_child(c)

func _fill_players(_bank):
	stomp_ring_players.get(right_player).stream =_bank.kick
	stomp_ring_players.get(left_player).stream = _bank.kick_alt
	klap_ring_players.get(right_player).stream =_bank.klap
	klap_ring_players.get(left_player).stream = _bank.klap_alt
	trompet_ring_players.get(right_player).stream =_bank.snare
	trompet_ring_players.get(left_player).stream = _bank.snare_alt
	hihat_ring_players.get(right_player).stream =_bank.hihat
	hihat_ring_players.get(left_player).stream = _bank.hihat_alt

func _on_set_rec_synth(recording):
	green_rec = recording
	pass
