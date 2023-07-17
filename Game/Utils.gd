extends Node


const SAVE_PATH = "res://save.bin"

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data : Dictionary = {
		# "playHP": Game.playerHP,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	
func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			var line = JSON.parse_string(file.get_line())
			if line:
				pass
				# Game.PlayerHP = line["playerHP"]
				# Game.gold = line["gold"]
