extends Node

const save_path: String = "user://saves.tres"

var init_data: Dictionary = {
	"dead": false,
	"hp": 100,
	"weapon": {
		0: null,
		1: null,
	},
	"equipped_weapon_type": 0,
	"relics": []
}

var player_data: Dictionary = {
	"dead": true,
	"hp": 100,
	"weapon": {
		0: null,
		1: null,
	},
	"equipped_weapon_type": 0,
	"relics": []
}


func save_data() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(player_data)


func load_data():
	if FileAccess.file_exists(save_path):
		player_data = FileAccess.open(save_path, FileAccess.READ).get_var()


func reset_data():
	player_data = init_data.duplicate(true)

