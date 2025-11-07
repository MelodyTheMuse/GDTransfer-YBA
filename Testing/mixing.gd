extends Node

enum ChaosPadMode {
	SAMPLE_MIXING,
	SYNTH_MIXING,
	SONG_MIXING
}

# Chaos pad
@export var corners: Array[Node2D] = []  # left, top, right (size 3)
@export var knob: Node2D
@export var chaos_pad_triangle_sprite: Sprite2D
@export var icon_main: Label
@export var icon_alt: Label
var weights: Vector3
var outer_triangle_size: float = 60.0
var chaos_pad_mode: ChaosPadMode = ChaosPadMode.SAMPLE_MIXING
@export var mic_button_location: Node2D
@export var mic_buttons: Array[Node2D] = []

# Sample mixing specifics
var samples_mixing_knob_positions: Array = []
var samples_mixing_knob_positions_clipboard: Array = []
var samples_mixing_active_ring: int = 0

func samples_mixing_copy_knobs_for_layer() -> void:
	pass#samples_mixing_knob_positions_clipboard = clone_from(samples_mixing_knob_positions[current_layer_index])

func samples_mixing_paste_knobs_for_layer() -> void:
	pass#samples_mixing_knob_positions[current_layer_index] = clone_from(samples_mixing_knob_positions_clipboard)
	knob.global_position = samples_mixing_knob_positions_clipboard[samples_mixing_active_ring]

func samples_mixing_store_active_knob() -> void:
	pass#samples_mixing_knob_positions[current_layer_index][samples_mixing_active_ring] = knob.global_position

func samples_mixing_retrieve_active_knob() -> void:
	pass#knob.global_position = samples_mixing_knob_positions[current_layer_index][samples_mixing_active_ring]

func samples_mixing_re_apply_remembered_mixing_volumes_for_all_rings() -> void:
	pass#var result0 = get_weights_for_position(samples_mixing_knob_positions[current_layer_index][0])
	#samples_mixing_update_mixing_volumes_for_ring(0, result0.mastervolume, result0.weights)
	#var result1 = get_weights_for_position(samples_mixing_knob_positions[current_layer_index][1])
	#samples_mixing_update_mixing_volumes_for_ring(1, result1.mastervolume, result1.weights)
	#var result2 = get_weights_for_position(samples_mixing_knob_positions[current_layer_index][2])
	#samples_mixing_update_mixing_volumes_for_ring(2, result2.mastervolume, result2.weights)
	#var result3 = get_weights_for_position(samples_mixing_knob_positions[current_layer_index][3])
	#samples_mixing_update_mixing_volumes_for_ring(3, result3.mastervolume, result3.weights)

func samples_mixing_change_ring(newring: int) -> void:
	# Save knob position
	if chaos_pad_mode == ChaosPadMode.SAMPLE_MIXING:
		samples_mixing_store_active_knob()
	elif chaos_pad_mode == ChaosPadMode.SYNTH_MIXING:
		synth_mixing_store_active_knob()
	elif chaos_pad_mode == ChaosPadMode.SONG_MIXING:
		song_mixing_store_active_knob()
	
	# Switch ring
	samples_mixing_active_ring = newring
	
	# Remember knob position
	samples_mixing_retrieve_active_knob()
	
	# Set chaos pad color to active ring
	samples_mixing_start_triangle_color_change(0.2)
	
	# Update icons
	if samples_mixing_active_ring == 0:
		icon_main.text = "👟"
		icon_alt.text = "👞"
	if samples_mixing_active_ring == 1:
		icon_main.text = "👏"
		icon_alt.text = "🥊"
	if samples_mixing_active_ring == 2:
		icon_main.text = "📣"
		icon_alt.text = "📢"
	if samples_mixing_active_ring == 3:
		icon_main.text = "⌚"
		icon_alt.text = "⏰"
	
	# Set mic button location
	for i in range(mic_buttons.size()):
		mic_buttons[i].global_position = Vector2(-500, 500)
	mic_buttons[samples_mixing_active_ring].global_position = mic_button_location.global_position
	
	# Set chaospad mode
	chaos_pad_mode = ChaosPadMode.SAMPLE_MIXING

func samples_mixing_start_triangle_color_change(duration: float) -> void:
	var old_color = chaos_pad_triangle_sprite.self_modulate
	var old_color_v3 = Vector3(old_color.r, old_color.g, old_color.b)
	var new_color #= colors[samples_mixing_active_ring]
	var new_color_v3 = Vector3(new_color.r, new_color.g, new_color.b)
	
	var elapsed: float = 0.0
	
	while elapsed < duration:
		var t = elapsed / duration
		var lerped = old_color_v3.lerp(new_color_v3, t)
		chaos_pad_triangle_sprite.self_modulate = Color(lerped.x, lerped.y, lerped.z, 1)
		
		# Yield one frame
		await get_tree().process_frame
		
		elapsed += get_process_delta_time()
	
	# Ensure final color is set
	chaos_pad_triangle_sprite.self_modulate = new_color

func samples_mixing_update_mixing_volumes_for_ring(ring: int, mastervolume: float, given_weights: Variant = null) -> void:
	var mainvolume: float
	var recvolume: float
	var altvolume: float
	
	if given_weights == null:
		mainvolume = weights.x * mastervolume
		recvolume = weights.y * mastervolume
		altvolume = weights.z * mastervolume
	else:
		mainvolume = given_weights.x * mastervolume
		recvolume = given_weights.y * mastervolume
		altvolume = given_weights.z * mastervolume
	
	#if ring == 0:
		#first_audio_player.volume_db = linear_to_db(mainvolume)
		#first_audio_player_alt.volume_db = linear_to_db(altvolume)
		#first_audio_player_rec.volume_db = linear_to_db(recvolume)
	#elif ring == 1:
		#second_audio_player.volume_db = linear_to_db(mainvolume)
		#second_audio_player_alt.volume_db = linear_to_db(altvolume)
		#second_audio_player_rec.volume_db = linear_to_db(recvolume)
	#elif ring == 2:
		#third_audio_player.volume_db = linear_to_db(mainvolume)
		#third_audio_player_alt.volume_db = linear_to_db(altvolume)
		#third_audio_player_rec.volume_db = linear_to_db(recvolume)
	#elif ring == 3:
		#fourth_audio_player.volume_db = linear_to_db(mainvolume)
		#fourth_audio_player_alt.volume_db = linear_to_db(altvolume)
		#fourth_audio_player_rec.volume_db = linear_to_db(recvolume)


var synth_mixing_knob_positions: Array = []
var synth_mixing_knob_positions_clipboard: Array = []
var synth_mixing_active_synth: int = 0

@export var synth_mixing_line_scale_curve: Curve
@export var synth_mixing_line_color_curve: Curve

func synth_mixing_copy_knobs_for_layer() -> void:
	synth_mixing_knob_positions_clipboard #= clone_from(synth_mixing_knob_positions[current_layer_index])

func synth_mixing_paste_knobs_for_layer() -> void:
	#synth_mixing_knob_positions[current_layer_index] #= clone_from(synth_mixing_knob_positions_clipboard)
	knob.global_position = synth_mixing_knob_positions_clipboard[synth_mixing_active_synth]

func synth_mixing_store_active_knob() -> void:
	pass#synth_mixing_knob_positions[current_layer_index][synth_mixing_active_synth] = knob.global_position

func synth_mixing_retrieve_active_knob() -> void:
	knob.global_position #= synth_mixing_knob_positions[current_layer_index][synth_mixing_active_synth]

func synth_mixing_re_apply_remembered_mixing_volumes_for_both_synths() -> void:
	var result0 #= get_weights_for_position(synth_mixing_knob_positions[current_layer_index][0])
	synth_mixing_update_mixing_volumes_for_synth(0, result0.mastervolume, result0.weights)
	var result1 #= get_weights_for_position(synth_mixing_knob_positions[current_layer_index][1])
	synth_mixing_update_mixing_volumes_for_synth(1, result1.mastervolume, result1.weights)

func synth_mixing_change_synth(synth: int) -> void:
	# Save knob position
	if chaos_pad_mode == ChaosPadMode.SAMPLE_MIXING:
		samples_mixing_store_active_knob()
	elif chaos_pad_mode == ChaosPadMode.SYNTH_MIXING:
		synth_mixing_store_active_knob()
	elif chaos_pad_mode == ChaosPadMode.SONG_MIXING:
		song_mixing_store_active_knob()
	
	# Switch synth
	synth_mixing_active_synth = synth
	
	# Remember knob position
	synth_mixing_retrieve_active_knob()
	
	# Set chaos pad color to active ring
	synth_mixing_start_triangle_color_change(0.2)
	
	# Update icons
	if synth_mixing_active_synth == 0:
		icon_main.text = "🤖"
		icon_alt.text = "🎹"
	if synth_mixing_active_synth == 1:
		icon_main.text = "🤖"
		icon_alt.text = "🎹"
	
	# Set mic button location
	for i in range(mic_buttons.size()):
		mic_buttons[i].global_position = Vector2(-500, 500)
	mic_buttons[4 + synth_mixing_active_synth].global_position = mic_button_location.global_position
	
	# Set chaospad mode
	chaos_pad_mode = ChaosPadMode.SYNTH_MIXING
	
	# Ring color brightness change
	synth_mixing_start_line_color_change(0.3)
	synth_mixing_start_line_size_change(0.3)

func synth_mixing_start_line_size_change(duration: float) -> void:
	var layer_voice_over #= layer_voice_over_0 if synth_mixing_active_synth == 0 else layer_voice_over_1
	
	var old_scale = layer_voice_over.big_line.scale.x
	var new_scale = old_scale * 1.05
	
	# Brighten
	var elapsed: float = 0.0
	while elapsed < duration:
		var t = elapsed / duration
		var ct = synth_mixing_line_scale_curve.sample(t) if synth_mixing_line_scale_curve else t
		var lerped = lerpf(old_scale, new_scale, ct)
		layer_voice_over.big_line.scale = Vector2.ONE * lerped
		
		# Yield one frame
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	# Ensure final scale is set
	layer_voice_over.big_line.scale = Vector2.ONE * new_scale
	
	# Darken
	elapsed = 0.0
	while elapsed < duration:
		var t = elapsed / duration
		var ct = synth_mixing_line_scale_curve.sample(t) if synth_mixing_line_scale_curve else t
		var lerped = lerpf(new_scale, old_scale, ct)
		layer_voice_over.big_line.scale = Vector2.ONE * lerped
		
		# Yield one frame
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	# Ensure final scale is set
	layer_voice_over.big_line.scale = Vector2.ONE * old_scale

func synth_mixing_start_line_color_change(duration: float) -> void:
	var layer_voice_over #= layer_voice_over_0 if synth_mixing_active_synth == 0 else layer_voice_over_1
	
	var old_color = Color()
	if synth_mixing_active_synth == 0:
		old_color = Color.html("#25cc00")
	if synth_mixing_active_synth == 1:
		old_color = Color.html("#aa00ff")
	var old_color_v3 = Vector3(old_color.r, old_color.g, old_color.b)
	
	var new_color = old_color.lightened(1.0)
	var new_color_v3 = Vector3(new_color.r, new_color.g, new_color.b)
	
	# Brighten
	var elapsed: float = 0.0
	while elapsed < duration:
		var t = elapsed / duration
		var ct = synth_mixing_line_color_curve.sample(t) if synth_mixing_line_color_curve else t
		var lerped = old_color_v3.lerp(new_color_v3, ct)
		layer_voice_over.big_line.default_color = Color(lerped.x, lerped.y, lerped.z, 1)
		
		# Yield one frame
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	# Ensure final color is set
	layer_voice_over.big_line.default_color = new_color
	
	# Darken
	elapsed = 0.0
	while elapsed < duration:
		var t = elapsed / duration
		var ct = synth_mixing_line_color_curve.sample(t) if synth_mixing_line_color_curve else t
		var lerped = new_color_v3.lerp(old_color_v3, ct)
		layer_voice_over.big_line.default_color = Color(lerped.x, lerped.y, lerped.z, 1)
		
		# Yield one frame
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	
	# Ensure final color is set
	layer_voice_over.big_line.default_color = old_color

func synth_mixing_start_triangle_color_change(duration: float) -> void:
	var old_color = chaos_pad_triangle_sprite.self_modulate
	var old_color_v3 = Vector3(old_color.r, old_color.g, old_color.b)
	
	var new_color = Color()
	if synth_mixing_active_synth == 0:
		new_color = Color.html("#25cc00")
	if synth_mixing_active_synth == 1:
		new_color = Color.html("#aa00ff")
	
	var new_color_v3 = Vector3(new_color.r, new_color.g, new_color.b)
	
	var elapsed: float = 0.0
	
	while elapsed < duration:
		var t = elapsed / duration
		var lerped = old_color_v3.lerp(new_color_v3, t)
		chaos_pad_triangle_sprite.self_modulate = Color(lerped.x, lerped.y, lerped.z, 1)
		
		# Yield one frame
		await get_tree().process_frame
		
		elapsed += get_process_delta_time()
	
	# Ensure final color is set
	chaos_pad_triangle_sprite.self_modulate = new_color

func synth_mixing_update_mixing_volumes_for_synth(synth: int, mastervolume: float, given_weights: Variant = null) -> void:
	var weights_to_use_this_time: Vector3
	
	if given_weights != null:
		weights_to_use_this_time = given_weights
	else:
		weights_to_use_this_time = weights
	
	if synth == 0:
		#layer_voice_over_0.audio_player.volume_linear = weights_to_use_this_time.y * mastervolume * 6.0
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Green"), linear_to_db(weights_to_use_this_time.z * mastervolume))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Green_alt"), linear_to_db(weights_to_use_this_time.x * mastervolume))
	if synth == 1:
		#layer_voice_over_1.audio_player.volume_linear = weights_to_use_this_time.y * mastervolume * 6.0
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Purple"), linear_to_db(weights_to_use_this_time.z * mastervolume))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Purple_alt"), linear_to_db(weights_to_use_this_time.x * mastervolume))


var song_mixing_knob_position: Vector2

func song_mixing_store_active_knob() -> void:
	song_mixing_knob_position = knob.global_position

func song_mixing_retrieve_active_knob() -> void:
	knob.global_position = song_mixing_knob_position

func song_mixing_change_to_song_mixer() -> void:
	# Save knob position
	if chaos_pad_mode == ChaosPadMode.SAMPLE_MIXING:
		samples_mixing_store_active_knob()
	elif chaos_pad_mode == ChaosPadMode.SYNTH_MIXING:
		synth_mixing_store_active_knob()
	elif chaos_pad_mode == ChaosPadMode.SONG_MIXING:
		song_mixing_store_active_knob()
	
	# Remember knob position
	song_mixing_retrieve_active_knob()
	
	# Set chaos pad color to active ring
	song_mixing_start_triangle_color_change(0.2)
	
	# Update icons
	icon_main.text = "🤖"
	icon_alt.text = "🪗"
	
	# Set mic button location
	for i in range(mic_buttons.size()):
		mic_buttons[i].global_position = Vector2(-500, 500)
	mic_buttons[6].global_position = mic_button_location.global_position
	
	# Set chaospad mode
	chaos_pad_mode = ChaosPadMode.SONG_MIXING

func song_mixing_start_triangle_color_change(duration: float) -> void:
	var old_color = chaos_pad_triangle_sprite.self_modulate
	var old_color_v3 = Vector3(old_color.r, old_color.g, old_color.b)
	
	var new_color = Color.html("#cf12ccff")
	var new_color_v3 = Vector3(new_color.r, new_color.g, new_color.b)
	
	var elapsed: float = 0.0
	
	while elapsed < duration:
		var t = elapsed / duration
		var lerped = old_color_v3.lerp(new_color_v3, t)
		chaos_pad_triangle_sprite.self_modulate = Color(lerped.x, lerped.y, lerped.z, 1)
		
		# Yield one frame
		await get_tree().process_frame
		
		elapsed += get_process_delta_time()
	
	# Ensure final color is set
	chaos_pad_triangle_sprite.self_modulate = new_color

func song_mixing_update_mixing_volumes_for_song(mastervolume: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SongVoice"), linear_to_db((weights.y + weights.x) * mastervolume))
	
	var busindex = AudioServer.get_bus_index("SongVoice")
	var reverb_effect# = get_bus_effect_by_name(busindex, "Reverb") as AudioEffectReverb
	reverb_effect.wet = weights.x * mastervolume / 4.0


func get_standard_knob_positions_samples() -> Array:
	var centered: Array = [
		chaos_pad_triangle_sprite.global_position,
		chaos_pad_triangle_sprite.global_position,
		chaos_pad_triangle_sprite.global_position,
		chaos_pad_triangle_sprite.global_position
	]
	return centered

func get_standard_knob_positions_synth() -> Array:
	var centered: Array = [
		chaos_pad_triangle_sprite.global_position,
		chaos_pad_triangle_sprite.global_position
	]
	return centered

func on_update_mixing(delta: float) -> void:
	# Inner triangle blending
	weights = get_barycentric_weights(
		knob.global_position,
		corners[0].global_position,
		corners[1].global_position,
		corners[2].global_position
	)
	
	# Outer triangle effects master volume
	var mastervolume: float = 1.0 if is_inside_triangle(weights) else master_volume_from_distance(
		knob.global_position,
		corners[0].global_position,
		corners[1].global_position,
		corners[2].global_position
	)
	
	# Clamp weights
	weights = Vector3(
		clampf(weights.x, 0.0, 1.0),
		clampf(weights.y, 0.0, 1.0),
		clampf(weights.z, 0.0, 1.0)
	)
	
	# Debug
	if Input.is_key_pressed(KEY_P):
		print("weights: %.2f, %.2f, %.2f" % [weights.x, weights.y, weights.z])
	if Input.is_key_pressed(KEY_O):
		print(mastervolume)
	
	# Update volumes of active ring
	var anyrec #(
		#SongVoiceOver.instance.recording or
		#layer_voice_over_0.recording or
		#layer_voice_over_0.should_record or
		#layer_voice_over_1.recording or
		#layer_voice_over_1.should_record
	#)
	
	if not anyrec:
		if chaos_pad_mode == ChaosPadMode.SAMPLE_MIXING:
			samples_mixing_update_mixing_volumes_for_ring(samples_mixing_active_ring, mastervolume)
		if chaos_pad_mode == ChaosPadMode.SYNTH_MIXING:
			synth_mixing_update_mixing_volumes_for_synth(synth_mixing_active_synth, mastervolume)
		if chaos_pad_mode == ChaosPadMode.SONG_MIXING:
			song_mixing_update_mixing_volumes_for_song(mastervolume)

func master_volume_from_distance(knob_pos: Vector2, a: Vector2, b: Vector2, c: Vector2) -> float:
	var closest_point_on_segment = func(p: Vector2, seg_a: Vector2, seg_b: Vector2) -> Vector2:
		var ab = seg_b - seg_a
		var t = (p - seg_a).dot(ab) / ab.length_squared()
		t = clampf(t, 0.0, 1.0)
		return seg_a + ab * t
	
	var closest_point_on_triangle = func(p: Vector2, tri_a: Vector2, tri_b: Vector2, tri_c: Vector2) -> Vector2:
		var p0 = closest_point_on_segment.call(p, tri_a, tri_b)
		var p1 = closest_point_on_segment.call(p, tri_b, tri_c)
		var p2 = closest_point_on_segment.call(p, tri_c, tri_a)
		
		var d0 = p.distance_squared_to(p0)
		var d1 = p.distance_squared_to(p1)
		var d2 = p.distance_squared_to(p2)
		
		var min_dist = minf(d0, minf(d1, d2))
		if min_dist == d0:
			return p0
		if min_dist == d1:
			return p1
		return p2
	
	var closest = closest_point_on_triangle.call(knob_pos, a, b, c)
	var distance = knob_pos.distance_to(closest)
	var master = clampf(1.0 - (distance / outer_triangle_size), 0.0, 1.0)
	return master

func get_barycentric_weights(p: Vector2, a: Vector2, b: Vector2, c: Vector2) -> Vector3:
	# Compute vectors
	var v0 = b - a
	var v1 = c - a
	var v2 = p - a
	
	# Compute dot products
	var d00 = v0.dot(v0)
	var d01 = v0.dot(v1)
	var d11 = v1.dot(v1)
	var d20 = v2.dot(v0)
	var d21 = v2.dot(v1)
	
	# Compute denominator
	var denom = d00 * d11 - d01 * d01
	
	# Compute barycentric coordinates
	var v = (d11 * d20 - d01 * d21) / denom
	var w = (d00 * d21 - d01 * d20) / denom
	var u = 1.0 - v - w
	
	var nonclamped = Vector3(u, v, w)
	
	return nonclamped

func get_weights_for_position(position: Vector2) -> Dictionary:
	# Inner triangle blending
	var temp_weights = get_barycentric_weights(
		position,
		corners[0].global_position,
		corners[1].global_position,
		corners[2].global_position
	)
	
	# Outer triangle effects master volume
	var temp_master_volume: float = 1.0 if is_inside_triangle(temp_weights) else master_volume_from_distance(
		position,
		corners[0].global_position,
		corners[1].global_position,
		corners[2].global_position
	)
	
	# Clamp weights
	temp_weights = Vector3(
		clampf(temp_weights.x, 0.0, 1.0),
		clampf(temp_weights.y, 0.0, 1.0),
		clampf(temp_weights.z, 0.0, 1.0)
	)
	
	return {"weights": temp_weights, "mastervolume": temp_master_volume}

func is_inside_triangle(check_weights: Vector3) -> bool:
	return check_weights.x >= 0.0 and check_weights.y >= 0.0 and check_weights.z >= 0.0

func clone_from(original: Array) -> Array:
	var clone: Array = []
	for item in original:
		clone.append(Vector2(item.x, item.y))
	return clone

# Note: You'll need to define these variables/references that are used in the script:
# - current_layer_index
# - colors array
# - first_audio_player, second_audio_player, etc. (audio players)
# - layer_voice_over_0, layer_voice_over_1
# - SongVoiceOver
# - get_bus_effect_by_name() function
