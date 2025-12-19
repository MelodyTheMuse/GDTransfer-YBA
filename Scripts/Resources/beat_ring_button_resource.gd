extends Resource
class_name beat_ring_button_resource

@export var default_audio: AudioStream
@export var back_up_bank:audio_bank 
@export var type_ring: ring_types
enum ring_types{
	KLAP,
	STOMP,
	HIHAT,
	TROMPET
}

@export_category("Assets")
@export_subgroup("Empty")
@export var StompRing_empty:Texture = preload("res://Assets/Sprites/New Assets/Art Assets/Shapes/Outlines/SHAPES_Pink_Empty.png")
@export var KlapRing_empty:Texture = preload("res://Assets/Sprites/New Assets/Art Assets/Shapes/Outlines/SHAPES_Orange_Empty.png")
@export var TrompetRing_empty:Texture = preload("res://Assets/Sprites/New Assets/Art Assets/Shapes/Outlines/SHAPES_Green_Empty.png")
@export var HihatRing_empty:Texture = preload("res://Assets/Sprites/New Assets/Art Assets/Shapes/Outlines/SHAPES_Blue_Empty.png")
@export_subgroup("filled")
@export var StompRing_filled:Texture = preload("res://Assets/Sprites/New Assets/Art Assets/Shapes/Filled/SHAPES_Pink_ROUND.png")
@export var KlapRing_filled:Texture = preload("res://Assets/Sprites/New Assets/Art Assets/Shapes/Filled/SHAPES_Orange-Star.png")
@export var TrompetRing_filled:Texture = preload("res://Assets/Sprites/New Assets/Art Assets/Shapes/Filled/SHAPES_Green-Clover.png")
@export var HihatRing_filled:Texture = preload("res://Assets/Sprites/New Assets/Art Assets/Shapes/Filled/SHAPES_Blue_Drop.png")
@export_category("")

func get_empty_texture():
	match type_ring:
		ring_types.KLAP:
			return KlapRing_empty
		ring_types.STOMP:
			return StompRing_empty
		ring_types.TROMPET:
			return TrompetRing_empty
		ring_types.HIHAT:
			return HihatRing_empty

func get_fill_texture():
	match type_ring:
		ring_types.KLAP:
			return KlapRing_filled
		ring_types.STOMP:
			return StompRing_filled
		ring_types.TROMPET:
			return TrompetRing_filled
		ring_types.HIHAT:
			return HihatRing_filled

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
