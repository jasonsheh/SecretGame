extends Node2D

class_name LevelBase

signal toggle_game_paused(is_paused : bool)

var game_paused = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		game_paused = !game_paused


#func _ready():
#	DisplayServer.window_set_size(Vector2(1920, 1080))
