extends Node
@export var button_prefabs :Array[PackedScene]  

func _ready() -> void:
	spawn_button_rings()

func spawn_button_rings():
	for ring in range(button_prefabs.size()): 
		for beat in range(bpm_manager_gd.amount_of_beats):
			var pos = get_button_position(beat, ring)
			
			# Spawn the button for this ring
			var button_instance = button_prefabs[ring].instantiate()
			button_instance.position = pos
			add_child(button_instance,true)


func get_button_position(beat: int, ring: int) -> Vector2:
	var angle = TAU * beat / bpm_manager_gd.amount_of_beats - PI / 2
	var distance = 0.0
	match bpm_manager_gd.amount_of_beats:
		8:distance = (4 - ring) * 45 + 56
		16:distance = (4 - ring) * 45 + 56
		32:distance = (4-ring) * 30 + 110 
	
	return Vector2(cos(angle), sin(angle)) * distance
