extends Node
var percentage
var effect:AudioEffectBandPassFilter
var cutoff_min = 1
var cutoff_max = 20500
@onready var slider = $HSlider
@onready var value = $Value
@onready var label_reso = $HSlider2/Label2

func _ready() -> void:
	get_effect()

func _on_h_slider_value_changed(_value: float) -> void:
	effect.cutoff_hz = _value
	value.text = str(_value)

func get_effect():
	var idx = AudioServer.get_bus_index("GreenVoice")
	effect = AudioServer.get_bus_effect(idx, 1)


func _on_h_slider_2_value_changed(value: float) -> void:
	effect.resonance = value
	label_reso.text = str(value)
