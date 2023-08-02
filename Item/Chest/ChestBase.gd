extends Node2D

@onready var item_list: Array = [
	preload("res://Item/Relic/RelicCystalHeart.tscn"),
	preload("res://Item/Relic/RelicCigar.tscn"),
	preload("res://Item/Relic/RelicHoneyEgg.tscn"),
	preload("res://Item/Relic/RelicTreasureMap.tscn"),
	
]
@onready var item = item_list[randi() % item_list.size()]

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

func open_chest() -> void:
	item = item.instantiate()
	item.position = get_node("ItemSpawnPos").position + position
	get_parent().add_child(item)
	
	get_node("PlayerDetector").set_collision_mask_value(1, false)
	get_node("PlayerDetector").set_collision_mask_value(2, false)
