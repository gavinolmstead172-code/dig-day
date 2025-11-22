extends Node2D

# ------------------------------------------------------
# UI REFERENCES
# ------------------------------------------------------
@onready var pause_menu := $PauseMenu
@onready var kill_label: Label = $UI/KillLabel
@onready var wave_label: Label = $UI/WaveLabel
@onready var flash_rect: ColorRect = $UI/FlashRect
@onready var wave_sound: AudioStreamPlayer = $WaveSound

func _ready():
	update_kill_counter()
	hide_wave_effects()

func _process(delta):
	update_kill_counter()

func update_kill_counter():
	kill_label.text = "Kills: " + str(Global.kills)

# ------------------------------------------------------
# WAVE ANNOUNCEMENT
# ------------------------------------------------------
func show_wave(wave_number: int):
	if wave_sound:
		wave_sound.play()

	wave_label.text = "WAVE " + str(wave_number)
	wave_label.visible = true
	wave_label.modulate = Color(1, 0, 0, 1)

	if flash_rect:
		flash_rect.visible = true
		flash_rect.modulate = Color(1, 0, 0, 0.7)

	var tween := create_tween()

	# Fade flash rect
	if flash_rect:
		tween.tween_property(flash_rect, "modulate", Color(1, 0, 0, 0), 0.5)

	# Hold wave label 2.5 sec
	tween.tween_interval(2.5)

	# Fade wave text out
	tween.tween_property(wave_label, "modulate", Color(1, 0, 0, 0), 0.6)

	await tween.finished
	hide_wave_effects()

func hide_wave_effects():
	wave_label.visible = false
	if flash_rect:
		flash_rect.visible = false

# ------------------------------------------------------
# CAMERA SHAKE
# ------------------------------------------------------
func camera_shake(intensity: float = 6.0, time: float = 0.3):
	var cam: Camera2D = $Camera2D

	if cam == null:
		return

	var start_offset: Vector2 = cam.offset
	var tween := create_tween()

	for i in range(8):
		var off := Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		tween.tween_property(cam, "offset", off, time / 8)

	tween.tween_property(cam, "offset", start_offset, 0.1)

# ------------------------------------------------------
# PAUSE MENU INPUT
# ------------------------------------------------------
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if get_tree().paused:
			pause_menu.close_pause()
		else:
			pause_menu.open_pause()
