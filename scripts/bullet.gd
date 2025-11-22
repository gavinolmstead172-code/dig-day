extends Area2D

@export var speed := 900.0
var direction : Vector2 = Vector2.ZERO

func _physics_process(delta):
	global_position += direction * speed * delta


func _on_area_entered(area):

	# ✔ Kill NORMAL rats only
	if area.is_in_group("Rat"):
		area.take_damage()
		queue_free()
		return

	# ❌ Ignore ranged rats (fungrats)
	if area.is_in_group("RangedRat"):
		return

	# ❌ Ignore player + shovel
	if area.is_in_group("Player") or area.is_in_group("Shovel"):
		return

	# ✔ Hit walls / other stuff
	queue_free()
