extends Resource
class_name beat_ring_button_resource

@export var default_audio: AudioStream

@export var type_ring: ring_types
enum ring_types{
	KLAP,
	STOMP,
	HIHAT,
	TROMPET
}

func get_color():
	var color:Color
	match type_ring:
		ring_types.KLAP:
			color = Color(0.837, 0.42, 0.1, 1.0)
		ring_types.STOMP:
			color = Color(.86,0,0)
		ring_types.HIHAT:
			color=Color(0,0,.86)
		ring_types.TROMPET:
			color=Color(0.759, 0.7, 0.0, 1.0)
	return color

func get_bus_name():
	var bus_name:String
	match type_ring:
		ring_types.KLAP:
			bus_name="Ring1"
		ring_types.STOMP:
			bus_name="Ring0"
		ring_types.HIHAT:
			bus_name="Ring3"
		ring_types.TROMPET:
			bus_name="Ring2"
	return bus_name
