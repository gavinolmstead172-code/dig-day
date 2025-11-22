extends CanvasLayer

@onready var ammo_label: Label = $AmmoLabel
@onready var player: Node = null

func _ready():
	# Adjust path if player is nested in another node
	player = get_tree().current_scene.get_node("player1")
	if player == null:
		print("Player not found! Check node path.")
	update_ammo_ui()

func _process(delta: float) -> void:
	if player != null:
		update_ammo_ui()

func update_ammo_ui():
	if player != null:
		if player.reloading:
			ammo_label.text = "Reloading..."
		else:
			ammo_label.text = str(player.ammo) + " / " + str(player.max_ammo)
