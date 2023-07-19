extends Control

@export var game_scene: LevelBase

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	game_scene.connect("toggle_game_paused", _on_toggle_game_paused)
	
func _on_toggle_game_paused(is_paused):
	if is_paused:
		show()
	else:
		hide()



func _on_exit_button_pressed():
	get_tree().quit()


func _on_title_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_option_button_pressed():
	get_node("OptionScene").show()


func _on_resume_button_pressed():
	get_tree().paused = false
	hide()
