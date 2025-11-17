extends Node
@export var play_button:Node2D
var effect:AudioEffectRecord
var recording
var rec_time = 4
var rec_button
var back_up_effect:AudioEffectCapture
var is_recording
var data:Array
var back_up = false
var capture_mix_rate

func _ready() -> void:
	if OS.get_name() == "Web":
		setup_effect_backup()
	else:
		setup_effect()

func _process(_delta: float) -> void:
	if is_recording:
		var available_frames = back_up_effect.get_frames_available()
		if available_frames > 0:
			var buffer = back_up_effect.get_buffer(available_frames)  # Get only the required frames
			for frame in buffer:
				data.append(frame.x)  # Left channel

func setup_effect():
	var idx = AudioServer.get_bus_index("Microphone")
	effect = AudioServer.get_bus_effect(idx, 1)

func setup_effect_backup():
	print("web")
	var idx = AudioServer.get_bus_index("Microphone")
	back_up_effect = AudioServer.get_bus_effect(idx, 0)
	capture_mix_rate = 48000
	back_up = true

func _on_button_pressed() -> void:
	if back_up:
		if not is_recording:
			back_up_effect.clear_buffer()
			data.clear()
			is_recording = true
	else:
		effect.set_recording_active(true)
	$Button2.disabled = true
	$Button.text = "Stop"
	_set_timer()

func _on_timeout():
	if back_up:
		is_recording = false
		GameComposer.set_rec_synths.emit(convert_to_wav(data))
		return
	if effect == null: setup_effect()
	if effect.is_recording_active():
		recording = effect.get_recording()
		effect.set_recording_active(false)
		GameComposer.set_rec_synths.emit(recording)
	$Button2.disabled = false
	$Button.text = "Record"

func _on_set_rec_button(button):
	rec_button = button

func _on_button_2_pressed() -> void:
	print(recording)
	print(recording.format)
	print(recording.mix_rate)
	print(recording.stereo)
	var _data = recording.get_data()
	print(_data.size())
	$AudioStreamPlayer.stream = recording
	$AudioStreamPlayer.play(0)

func _set_timer():
	if(GameComposer.sequenser_node != null):
		rec_time = GameComposer.sequenser_node.note_length * GameComposer.sequenser_node.notes_per_beat
	get_tree().create_timer(rec_time).timeout.connect(_on_timeout)

func convert_to_wav(audio_data: PackedFloat32Array) -> AudioStreamWAV:
	var wav_stream = AudioStreamWAV.new()
	
	# Convert from float (-1.0 to 1.0) to 16-bit PCM (-32768 to 32767)
	var pcm_data = PackedByteArray()
	for i in range(0, audio_data.size()):  # Process stereo pairs
		var left_sample = int(clamp(audio_data[i] * 32767.0, -32768, 32767))

		# Append left sample (little-endian format)
		pcm_data.append(left_sample & 0xFF)
		pcm_data.append((left_sample >> 8) & 0xFF)

	wav_stream.format = AudioStreamWAV.FORMAT_16_BITS
	wav_stream.mix_rate = capture_mix_rate
	print("mix rate = %s" % capture_mix_rate)
	wav_stream.stereo = false  # Enable stereo playback
	wav_stream.data = pcm_data  # Convert to byte array

	return wav_stream
