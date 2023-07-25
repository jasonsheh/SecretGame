extends LevelBase

const Level_Component: Array = [
	preload("res://Levels/Level1/LevelComponentBase1_1.tscn"),
	preload("res://Levels/Level1/LevelComponentBase1_2.tscn"),
	preload("res://Levels/Level1/LevelComponentBase1_3.tscn"),
]

const Chest_list: Array = [
	preload("res://Item/Chest/ChestBase.tscn"),
]
#const Middle_Component: Array = []
#const Edge_Component: Array = []
const TILE_SIZE: int = 16
@export var component_num: int = 5

@onready var player: Node2D = get_node("Player")
@onready var level: Node2D = get_node("Level")
@onready var items: Node2D = get_node("Items")

func _ready() -> void:
	_create_level()


func _create_level() -> void:
	var position_x_offset: int = 0
	for i in component_num:
		# 选择一个随机的地图组件
		var current_component: Node2D = Level_Component[randi() % Level_Component.size()].instantiate()
		var current_tilemap: TileMap = current_component.get_node("TileMap")
		if i == 0:
			player.position = current_component.get_node("PlayerSpawnPos").position
		else:
			current_component.position.x += (current_tilemap.get_used_rect().size.x + position_x_offset) * TILE_SIZE
			position_x_offset += current_tilemap.get_used_rect().size.x

			if randi() % Level_Component.size() > 1:
				var chest = Chest_list[0].instantiate()
				chest.position = current_component.get_node("PlayerSpawnPos").position
				items.add_child(chest)

		level.add_child(current_component)

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
