extends LevelBase

const Level_Component: Array = [
	preload("res://Levels/Level1/LevelComponentBase1_1.tscn"),
	preload("res://Levels/Level1/LevelComponentBase1_2.tscn"),
	preload("res://Levels/Level1/LevelComponentBase1_3.tscn"),
]

const Chest_list: Array = [
	preload("res://Item/Interactable/Chest.tscn"),
]

const Enemy_list: Array = [
	preload("res://Character/Enemy/Archer/EnemyArcher.tscn"),
	preload("res://Character/Enemy/Mushroom/Mushroom.tscn"),
	preload("res://Character/Enemy/SpitMinion/EnemySpitMinion.tscn"),
]

var boss_spawner = preload("res://Item/Interactable/BossSpawner.tscn")

const TILE_SIZE: int = 16
const SPAWNER_TILE_ID_LIST: Array = []

var component_num: int = 7
var enemy_spawn_num: int = 0
var enemy_spawn_max: int = 2
var boss_spawner_index = randi() % Level_Component.size()

@onready var player: Node2D = get_node("Player")
@onready var level: Node2D = get_node("Level")
@onready var enemy: Node2D = get_node("Enemy")
@onready var items: Node2D = get_node("Items")

func _ready() -> void:
	_create_level()


func _create_level() -> void:
	var position_x_offset: int = 0
	for i in component_num:
		# 选择一个随机的地图组件
		var current_component: Node2D = Level_Component[randi() % Level_Component.size()].instantiate()
		var current_tilemap: TileMap = current_component.get_node("TileMap")
		
		if i == int(component_num / 2):
			player.position = current_component.get_node("PlayerSpawnPos").position + Vector2(position_x_offset, 0) * TILE_SIZE
		if i == boss_spawner_index:
			var _boss_spawner = boss_spawner.instantiate()
			_boss_spawner.position = current_component.get_node("PlayerSpawnPos").position + Vector2(position_x_offset, 0) * TILE_SIZE
			items.add_child(_boss_spawner)

		current_component.position.x += (current_tilemap.get_used_rect().size.x + position_x_offset) * TILE_SIZE

		if randi() % component_num > 2:
			var chest = Chest_list[0].instantiate()
			chest.position = current_component.get_node("PlayerSpawnPos").position + Vector2(position_x_offset, 0) * TILE_SIZE
			items.add_child(chest)
		
		position_x_offset += current_tilemap.get_used_rect().size.x

		level.add_child(current_component)

func _create_level_by_pattern() -> void:
	var _pattern = load("res://new_tile_set.tres").get_pattern(0)
	get_node("TileMap").set_pattern(0, Vector2i(0,0), _pattern)


func _spawn_enemy() -> void:
	if enemy_spawn_num > enemy_spawn_max:
		get_node("EnemySpawnTimer").stop()
		
	var _spawn_range: int = randi_range(-20, 20)
	if -5 < _spawn_range and _spawn_range <= 0:
		_spawn_range = -5
	if 0 < _spawn_range and _spawn_range < 5:
		_spawn_range = 5
		
	var enemy_spawn_center = Vector2i(player.position) / TILE_SIZE + Vector2i(_spawn_range, -1)
	var _enemy = Enemy_list[randi() % Enemy_list.size()].instantiate()
	
	_enemy.position = enemy_spawn_center * TILE_SIZE
	enemy_spawn_num += 1
	
	enemy.add_child(_enemy)

func _on_enemy_spawn_timer_timeout():
	_spawn_enemy()

