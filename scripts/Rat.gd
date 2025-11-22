extends Area2D

@export var speed := 120.0
var health := 1
var can_bite := true

var player
@onready var sprite = $sprite
@onready var bite_sound = $BiteSound

func _ready():
	player = get_tree().current_scene.get_node("player1")
	add_to_group("Rat")      # melee rat group
	add_to_group("Enemy")    # all enemies group

func _physics_process(delta):
	if not player:
		return

	var dir: Vector2 = player.global_position - global_position
	global_position += dir.normalized() * speed * delta

	sprite.flip_h = player.global_position.x < global_position.x


func _on_body_entered(body):
	if body == player and can_bite:
		if player.has_method("take_damage"):
			player.take_damage(1)

		if bite_sound:
			bite_sound.play()

		can_bite = false

		var tree := get_tree()
		if tree:
			await tree.create_timer(0.4).timeout

		if is_inside_tree():
			can_bite = true


func take_damage():
	health -= 1
	if health <= 0:
		Global.kills += 1
		queue_free()
