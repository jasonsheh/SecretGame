extends Node2D


var speed: int = 30
var friction: int = 10
var shift_direction: Vector2 = Vector2.ZERO

@onready var label: Label = get_node("Label")

func _ready():
	shift_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	

func _process(delta):
	position += speed * shift_direction * delta
	speed = max(speed - friction*delta, 0)
