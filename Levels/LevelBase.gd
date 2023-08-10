extends Node2D

class_name LevelBase

signal toggle_game_paused(is_paused : bool)

var is_paused = false

func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel") and not is_paused:
		is_paused = !is_paused
		get_tree().paused = is_paused
		emit_signal("toggle_game_paused", get_tree().paused)
	elif event.is_action_pressed("ui_cancel"):
		is_paused = false

#func _ready():
#	DisplayServer.window_set_size(Vector2(1920, 1080))
