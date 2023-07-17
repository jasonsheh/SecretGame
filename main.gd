extends Node2D

const TILE_SIZE = 8
const LEVEL_SIZE = Vector2(30, 30)


# Called when the node enters the scene tree for the first time.
func _ready():
	#DisplayServer.window_set_size(Vector2(1280, 720))
	pass

func build_level():
	pass



func _on_quit_button_pressed():
	get_tree().quit()



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Level0.tscn")
