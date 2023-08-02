extends Node2D

class_name Relic


var relic_name: String
var relic_rarity: int

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		get_node("ItemInfo").show()
		get_node("Interactive").show()
		body.is_in_relic = true
		body.pick_up_item = self


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		body.is_in_relic = false
		body.pick_up_item = null
		get_node("ItemInfo").hide()
		get_node("Interactive").hide()

func get_texture() -> Texture2D:
	return get_node("Sprite2D").texture
