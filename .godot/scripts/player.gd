extends CharacterBody2D

@export var speed := 400.0
@export var map_width := 1919.0
@export var map_height := 1079.0

var health := 3

# ❤️ HEART UI
@onready var heart1 = get_tree().current_scene.get_node("UI/Heart1")
@onready var heart2 = get_tree().current_scene.get_node("UI/Heart2")
@onready var heart3 = get_tree().current_scene.get_node("UI/Heart3")

# ------------------------------------------------------
# GUN + SHOOTING
# ------------------------------------------------------
var ammo := 10
var max_ammo := 10
var reloading := false
var reload_time := 3.5
var bullet_scene = preload("res://scene/Bullet.tscn")

@onready var gun = $gun1
@onready var muzzle = $gun1/muzzle  # ✔ correct muzzle reference
@onready var ammo_label = get_tree().current_scene.get_node("UI/AmmoLabel")

@onready var shoot_sound = $ShootSound
@onready var empty_sound = $EmptySound

# ------------------------------------------------------
# SHOVEL
# ------------------------------------------------------
var shovel_scene = preload("res://scene/Shovel.tscn")
var can_throw_shovel := true


func _ready():
	add_to_group("Player")
	update_ammo_ui()
	update_hearts()


func _physics_process(delta):
	_move()
	_rotate_gun()
	_flip_body()
	_clamp()


func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("reload"):
		reload()
	if event.is_action_pressed("throw_shovel") and can_throw_shovel:
		throw_shovel()


# ------------------------------------------------------
# MOVEMENT
# ------------------------------------------------------
func _move():
	var v = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	velocity = v.normalized() * speed
	move_and_slide()


func _clamp():
	global_position.x = clamp(global_position.x, 0.0, map_width)
	global_position.y = clamp(global_position.y, 0.0, map_height)


# ------------------------------------------------------
# GUN
# ------------------------------------------------------
func _rotate_gun():
	gun.look_at(get_global_mouse_position())


func _flip_body():
	var m = get_global_mouse_position()
	if m.x < global_position.x:
		$body1.flip_h = true
		gun.scale.y = -1
	else:
		$body1.flip_h = false
		gun.scale.y = 1


# ------------------------------------------------------
# SHOOTING — FIXED
# ------------------------------------------------------
func shoot():
	if reloading:
		return
	if ammo <= 0:
		empty_sound.play()
		return

	var b = bullet_scene.instantiate()

	# ✔ EXACT muzzle spawn
	b.global_position = muzzle.global_position

	# ✔ EXACT direction
	b.direction = (get_global_mouse_position() - muzzle.global_position).normalized()

	get_tree().current_scene.add_child(b)

	shoot_sound.play()
	ammo -= 1
	update_ammo_ui()


# ------------------------------------------------------
# RELOAD
# ------------------------------------------------------
func reload():
	if reloading or ammo == max_ammo:
		return

	reloading = true
	ammo_label.text = "RELOADING..."

	await get_tree().create_timer(reload_time).timeout

	ammo = max_ammo
	reloading = false
	update_ammo_ui()


func update_ammo_ui():
	ammo_label.text = str(ammo) + " / " + str(max_ammo)


# ------------------------------------------------------
# SHOVEL
# ------------------------------------------------------
func throw_shovel():
	var s = shovel_scene.instantiate()
	get_tree().current_scene.add_child(s)

	var dir = get_global_mouse_position() - global_position
	s.start_throw(dir, global_position)

	can_throw_shovel = false
	await s.tree_exited
	await get_tree().create_timer(7.5).timeout
	can_throw_shovel = true


# ------------------------------------------------------
# DAMAGE + HEART SYSTEM
# ------------------------------------------------------
func take_damage(amount := 1):
	health -= amount
	update_hearts()
	if health <= 0:
		die()


func update_hearts():
	heart1.visible = health >= 1
	heart2.visible = health >= 2
	heart3.visible = health >= 3


func die():
	Global.load_highscores()

	if Global.kills > Global.highscore_kills:
		Global.highscore_kills = Global.kills

	if Global.wave > Global.highscore_wave:
		Global.highscore_wave = Global.wave

	Global.save_highscores()

	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/GameOver.tscn")
