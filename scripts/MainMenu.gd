extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	$PlayButton.pressed.connect(_on_play)
	$QuitButton.pressed.connect(_on_quit)


func _on_play():
	get_tree().change_scene_to_file("res://scene/Level 1.tscn")


func _on_quit():
	get_tree().quit()
