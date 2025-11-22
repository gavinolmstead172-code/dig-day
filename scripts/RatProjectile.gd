extends Area2D

@export var speed := 600.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("EnemyProjectile")  # for shovel to destroy


func _physics_process(delta):
	global_position += direction * speed * delta
	rotation += 15.0 * delta


func _on_area_entered(area):
	# Never hit other enemies
	if area.is_in_group("Enemy"):
		return

	# Shovel destroys the bullet
	if area.is_in_group("Shovel"):
		queue_free()
		return

	# Hit player
	if area.is_in_group("Player"):
		if area.has_method("take_damage"):
			area.take_damage(1)
		queue_free()
