extends CanvasLayer

@onready var kills_label = $KillsLabel
@onready var wave_label = $WaveLabel
@onready var high_kills_label = $HighKillsLabel
@onready var high_waves_label = $HighWavesLabel

func _ready():
	show_scores()

func show_scores():
	var final_wave = max(1, Global.wave)
	kills_label.text = "Kills: " + str(Global.kills)
	wave_label.text = "Wave: " + str(final_wave)
	high_kills_label.text = "Best Kills: " + str(Global.highscore_kills)
	high_waves_label.text = "Best Wave: " + str(Global.highscore_wave)

func _on_Retrybutton_pressed():
	get_tree().paused = false
	Global.reset_run()
	get_tree().change_scene_to_file("res://scene/Level 1.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
