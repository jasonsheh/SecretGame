extends Interactable

const item_name_list: Array = [
	"CystalHeart",
	"Cigar",
	"HoneyEgg",
	"TreasureMap"
]

@onready var item_list: Array = [
	preload("res://Item/Relic/RelicCystalHeart.tscn"),
	preload("res://Item/Relic/RelicCigar.tscn"),
	preload("res://Item/Relic/RelicHoneyEgg.tscn"),
	preload("res://Item/Relic/RelicTreasureMap.tscn"),
	
]
@onready var item = item_list[randi() % item_list.size()]

func open_chest() -> void:
	item = item.instantiate()
	item.position = get_node("ItemSpawnPos").position + position
	get_parent().add_child(item)
	
	get_node("PlayerDetector").set_collision_mask_value(1, false)
	get_node("PlayerDetector").set_collision_mask_value(2, false)
