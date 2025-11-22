extends Node

@export var rat_scene = preload("res://scene/Rat.tscn")
@export var ranged_scene = preload("res://scene/RangedRat.tscn")

@export var map_width := 1919.0
@export var map_height := 1079.0

var melee_per_wave := 3
var ranged_per_wave := 0


func _ready():
	add_to_group("WaveManager")
	Global.reset_run()
	Global.wave = 1

	await get_tree().process_frame
	_start_wave()


func _start_wave():
	var level = get_tree().current_scene
	if level and level.has_method("show_wave"):
		level.show_wave(Global.wave)

	_spawn_and_wait()


func _spawn_and_wait() -> void:
	await _spawn_wave()
	await _wait_until_all_enemies_dead()

	Global.wave += 1
	melee_per_wave += 2
	if Global.wave % 2 == 0:
		ranged_per_wave += 1

	var tree := get_tree()
	if tree:
		await tree.create_timer(2.0).timeout

	_start_wave()


func _spawn_wave() -> void:
	var tree := get_tree()
	if not tree:
		return

	for i in range(melee_per_wave):
		var rat = rat_scene.instantiate()
		rat.global_position = _random_edge_position()
		tree.current_scene.add_child(rat)
		await tree.create_timer(0.3).timeout

	for j in range(ranged_per_wave):
		var rr = ranged_scene.instantiate()
		rr.global_position = _random_edge_position()
		tree.current_scene.add_child(rr)
		await tree.create_timer(0.3).timeout


func _wait_until_all_enemies_dead() -> void:
	var tree := get_tree()
	if not tree:
		return

	while tree.get_nodes_in_group("Enemy").size() > 0:
		await tree.process_frame


func _random_edge_position() -> Vector2:
	var pad := 100.0
	var side := randi() % 4
	match side:
		0:
			return Vector2(randf_range(pad, map_width - pad), pad)
		1:
			return Vector2(map_width - pad, randf_range(pad, map_height - pad))
		2:
			return Vector2(randf_range(pad, map_width - pad), map_height - pad)
		3:
			return Vector2(pad, randf_range(pad, map_height - pad))
	return Vector2.ZERO
