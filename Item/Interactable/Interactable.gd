extends Node2D

class_name Interactable


func _on_player_detector_body_entered(_body) -> void:
	if _body.name == "Player":
		get_node("Interactive").show()
		
		_body.is_in_chest = true
		_body.chest = self


func _on_player_detector_body_exited(_body) -> void:
	if _body.name == "Player":
		_body.is_in_chest = false
		_body.chest = null
		get_node("Interactive").hide()

