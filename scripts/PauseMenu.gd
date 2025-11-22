extends Control

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED   # UI still works when paused


func open_pause():
	var tree := get_tree()
	if tree == null:
		return
	tree.paused = true
	visible = true


func close_pause():
	var tree := get_tree()
	if tree == null:
		return
	visible = false
	tree.paused = false


# ---- BUTTON HANDLERS (proper names) ---------------------------

func _on_ResumeButton_pressed():
	close_pause()


func _on_MainMenuButton_pressed():
	var tree := get_tree()
	if tree == null:
		return
	tree.paused = false
	tree.change_scene_to_file("res://scene/MainMenu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


# ---- WRAPPERS for lowercase names (in case signals use these) -

func _on_resume_button_pressed() -> void:
	_on_ResumeButton_pressed()

func _on_main_menu_button_pressed() -> void:
	_on_MainMenuButton_pressed()

func _on_quit_button_pressed() -> void:
	_on_QuitButton_pressed()
