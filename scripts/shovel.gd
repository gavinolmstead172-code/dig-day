extends Area2D

@export var speed := 900.0
@export var spin_speed := 20.0
@export var max_distance := 1000.0

var player
var direction: Vector2 = Vector2.ZERO
var returning := false
var distance_traveled := 0.0

@onready var throw_sound = $ThrowSound
@onready var return_sound = $ReturnSound
@onready var hit_sound = $HitSound


func _ready():
	add_to_group("Shovel")
	player = get_tree().current_scene.get_node("player1")
	if throw_sound:
		throw_sound.play()


func start_throw(dir: Vector2, start_pos: Vector2) -> void:
	global_position = start_pos
	direction = dir.normalized()
	returning = false
	distance_traveled = 0.0


func _physics_process(delta):
	rotation += spin_speed * delta

	if not returning:
		var move_vec: Vector2 = direction * speed * delta
		global_position += move_vec
		distance_traveled += move_vec.length()

		if distance_traveled >= max_distance:
			returning = true
			if return_sound:
				return_sound.play()
	else:
		if not player:
			queue_free()
			return

		var to_player: Vector2 = player.global_position - global_position
		global_position += to_player.normalized() * speed * delta

		if to_player.length() < 30.0:
			queue_free()


func _on_area_entered(area):
	# Kill any enemy (melee or ranged)
	if area.is_in_group("Enemy"):
		if area.has_method("take_damage"):
			area.take_damage()
		if hit_sound:
			hit_sound.play()
		return

	# Destroy enemy bullets
	if area.is_in_group("EnemyProjectile"):
		area.queue_free()
		if hit_sound:
			hit_sound.play()
