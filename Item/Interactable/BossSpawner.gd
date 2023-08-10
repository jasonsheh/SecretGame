extends Interactable


var boss_list: Array = [
	preload("res://Character/Boss/BossLevel1/BossLevel1.tscn"),
]

var boss = boss_list[randi() % boss_list.size()]

func open_chest() -> void:
	boss = boss.instantiate()
	boss.position = get_node("ItemSpawnPos").position + position
	get_parent().add_child(boss)
	
	$PlayerDetector.set_collision_mask_value(1, false)
	$PlayerDetector.set_collision_mask_value(2, false)
