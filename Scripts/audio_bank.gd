extends Resource
class_name audio_bank
@export_category("audio sources")
@export_group("kick")
@export var kick :AudioStream
@export var kick_alt:AudioStream
@export_group("klap")
@export var klap:AudioStream
@export var klap_alt:AudioStream
@export_group("snare")
@export var snare:AudioStream
@export var snare_alt:AudioStream
@export_group("Hihat")
@export var hihat:AudioStream
@export var hihat_alt:AudioStream
@export_category("Synth")
@export_group("green synth")
@export var green_soundfont:Resource
@export var green_instrument_id:int
@export_group("purple synth")
@export var purple_soundfont:Resource
@export var purple_instrument_id:int
@export_category("Effects")
@export var effect_profile_:effect_profile
