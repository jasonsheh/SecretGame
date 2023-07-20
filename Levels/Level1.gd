extends LevelBase

const Level_Component: Array = [
	preload("res://Levels/Level1/LevelComponentBase1_1.tscn"),
	preload("res://Levels/Level1/LevelComponentBase1_2.tscn"),
	preload("res://Levels/Level1/LevelComponentBase1_3.tscn"),
]
#const Middle_Component: Array = []
#const Edge_Component: Array = []
@export var component_num: int = 5


func _ready() -> void:
	_create_level()


func _create_level() -> void:
	var previous_component: Node2D
	var is_place_left: bool = false
	for i in component_num:
		var current_component: Node2D = Level_Component[randi() % Level_Component.size()].instantiate()
		
		add_child(current_component)
		previous_component = current_component
		
		var previous_tilemap: TileMap = previous_component.get_node("TileMap")
		var previous_position: Vector2 
		previous_tilemap.local_to_map()
		if i != 0:
			if 
			current_component.position = previous_component.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
