extends Node2D


var is_player_inside:bool = false

func get_input() -> void:
	if Input.is_action_just_pressed("ui_interact"):
		# spawm item
		# set_dialog("you are welcome.")
		print("item")


func _on_player_detector_body_entered(_body):
	is_player_inside = true
	get_node("Interactive").show()


func _on_player_detector_body_exited(_body):
	is_player_inside = false
	get_node("Interactive").hide()
