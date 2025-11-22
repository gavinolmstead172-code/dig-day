extends Area2D

@export var fire_rate := 3.5
@export var projectile_scene = preload("res://scene/RatProjectile.tscn")

var health := 1
var player

@onready var sprite = $sprite
@onready var shoot_timer: Timer = $ShootTimer


func _ready():
	player = get_tree().current_scene.get_node("player1")

	add_to_group("RangedRat")  # unique group
	add_to_group("Enemy")      # all enemies group

	shoot_timer.wait_time = fire_rate
	shoot_timer.timeout.connect(_on_ShootTimer_timeout)
	shoot_timer.start()


func _process(delta):
	if player and sprite:
		sprite.flip_h = player.global_position.x < global_position.x


func _on_ShootTimer_timeout():
	if not player:
		return

	var proj = projectile_scene.instantiate()
	proj.global_position = global_position
	proj.direction = (player.global_position - global_position).normalized()
	get_tree().current_scene.add_child(proj)


func take_damage():
	# Shovel will call this
	Global.kills += 1
	queue_free()
