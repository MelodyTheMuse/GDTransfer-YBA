extends Node
var minute_reached = false
var time = 0.0
var clock =0.0
var delay = true
var midin = MidiIn.new()
var midiout = MidiOut.new()
func _ready():
	midin.open_port(0)
	midin.midi_message.connect(_on_midi_message)
	midiout.open_port(1)
	midin.ignore_types(false, false, false)
	#print(OS.get_connected_midi_inputs())

func _input(input_event):
	if input_event is InputEventMIDI:
		pass
		#_print_midi_info(input_event)

func _process(delta: float) -> void:
	#midiout.send_message([0x90, 60, 127])
	if delay:
		time += delta
		if time > 1:
			delay = false
			time = 0
			midiout.send_message([250])
			#midiout.send_message([0x90, 60, 127])
	time += delta
	if time > 10:
		minute_reached = true

func _print_midi_info(midi_event):
	if delay: return
	if(midi_event.message == 250):
		print("started")
	if(midi_event.message == 252):
		print("stopped")
	if(midi_event.message == 248):
		if !minute_reached:
			clock+=1
			print("this is the clock")
		else:
			var bps =0.0
			var bpm = 0
			bps =clock / 24
			bpm = bps * 6
			print("Your bpm is ", bpm)

func _on_midi_message(delta, message):
	print("MIDI message: ", message)
	#midiout.send_message(message)
