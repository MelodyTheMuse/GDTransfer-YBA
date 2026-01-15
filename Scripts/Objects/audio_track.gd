extends Node

class_name audio_track

@export_category("Ring Player")
@export var players :Array[AudioStreamPlayer]
@export_category("Audio Sources")
@export var bank:audio_bank
@export var beat_ring_resource: beat_ring_button_resource
@export var track_resource:audio_track_resource

var primary_player = 0
var alternative_player = 1
var recording_player = 2



func _ready() -> void:
	if(track_resource != null):
		GameComposer.play_synth.connect(_on_play_synth)
		GameComposer.set_rec_synth.connect(_on_set_rec_synth)
		GameComposer.stop_synth.connect(_on_stop_synth)
		if bank != null:
			_fill_players(bank)
		else:
			_fill_players(track_resource.back_up_bank)
	else:
		GameComposer.play_ring_type.connect(_on_play)
		GameComposer.stop_all_players.connect(_on_stop_all_player)
		if bank != null:
			_fill_players(bank)
		else:
			_fill_players(beat_ring_resource.back_up_bank)
	_setup_players()

#Play audio based on the ring type given
func _on_play(resource:beat_ring_button_resource.ring_types):
	if resource != beat_ring_resource.type_ring:return
	_get_players_volumes()
	for player in players :
		player.play(0)

#TODO This func sets the volumes of the places based on the values of the mixer
func _set_player_volumes():
	pass

#TODO this func needs to get the values from the mixer
func _get_players_volumes():
	_set_player_volumes()
	pass

#Only to be used during backup, this does the setup for the playes should they not exist already
func _setup_players():
	if beat_ring_resource != null:
		match beat_ring_resource.type_ring:
			beat_ring_button_resource.ring_types.STOMP:
				for player in players:
					player.set_bus("Ring0")
			beat_ring_button_resource.ring_types.KLAP:
				for player in players:
					player.set_bus("Ring1")
			beat_ring_button_resource.ring_types.TROMPET:
				for player in players:
					player.set_bus("Ring2")
			beat_ring_button_resource.ring_types.HIHAT:
				for player in players:
					player.set_bus("Ring3")
	else:
		match track_resource.synth:
			audio_track_resource.synths.GREEN:
				players.get(primary_player).set_bus("Green")
				players.get(alternative_player).set_bus("Green_alt")
				players.get(recording_player).set_bus("GreenVoice")
			audio_track_resource.synths.PURPLE:
				players.get(primary_player).set_bus("Pruple")
				players.get(alternative_player).set_bus("Purple_alt")
				players.get(recording_player).set_bus("PurpleVoice")

#This func gives the players the information they need to play the correct file based on the bank
func _fill_players(_bank:audio_bank):
	if beat_ring_resource != null:
		match beat_ring_resource.type_ring:
			beat_ring_button_resource.ring_types.STOMP:
				players.get(primary_player).stream = _bank.kick
				players.get(alternative_player).stream =_bank.kick
			beat_ring_button_resource.ring_types.KLAP:
				players.get(primary_player).stream =_bank.klap
				players.get(alternative_player).stream = _bank.klap_alt
			beat_ring_button_resource.ring_types.TROMPET:
				players.get(primary_player).stream =_bank.snare
				players.get(alternative_player).stream =_bank.snare_alt
			beat_ring_button_resource.ring_types.HIHAT:
				players.get(primary_player).stream =_bank.hihat
				players.get(alternative_player).stream = _bank.hihat_alt
	else:
		return
		#TODO Add the fill for the synth players

#This sets the stream and creates the synth if it doesn't exist already
func _on_set_rec_synth(recording,resource:audio_track_resource.synths):
	if resource != track_resource.synth:return
	players[recording_player].stream = recording

#This func starts the synth stream based on the time given
func _on_play_synth(_time,resource:audio_track_resource.synths):
	if resource != track_resource.synth:return
	for c in players:
		if c != null:
			c.play(_time)

#This func stops the synth from playing
func _on_stop_synth():
	for c in players:
		if c != null:
			c.stop()

#This fucn stops all players
func _on_stop_all_player():
	print("stopped players")
	for player in players:
		player.stop()
