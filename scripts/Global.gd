extends Node

var kills = 0
var wave = 1

var highscore_kills = 0
var highscore_wave = 0

const SAVE_PATH = "user://save.dat"

func reset_run():
	kills = 0
	wave = 1

func save_highscores():
	var f = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	f.store_var(highscore_kills)
	f.store_var(highscore_wave)
	f.close()

func load_highscores():
	if FileAccess.file_exists(SAVE_PATH):
		var f = FileAccess.open(SAVE_PATH, FileAccess.READ)
		highscore_kills = f.get_var()
		highscore_wave = f.get_var()
		f.close()
