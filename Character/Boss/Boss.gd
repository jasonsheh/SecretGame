extends Character

class_name Boss


@onready var player: CharacterBody2D = get_node("../../Player") # ./Level1/Player
@onready var is_chased: bool = false
@onready var last_move_direction: Vector2 = Vector2.ZERO

func _ready():
	JUMP_VELOCITY = -200

func idle() -> void:
	pass

func stroll() -> void:
	pass

func chase() -> void:
	# 判断是否进入追踪范围
	if is_chased:
		_move_to_player()
		if move_direction.x > 0 and character_sprite.flip_h:
			character_sprite.flip_h = false
		elif move_direction.x < 0 and not character_sprite.flip_h:
			character_sprite.flip_h = true

func _face_to_player() -> void:
	var face_direction = (player.position - self.position).normalized()
	if face_direction.x > 0 and character_sprite.flip_h:
		character_sprite.flip_h = false
	elif face_direction.x < 0 and not character_sprite.flip_h:
		character_sprite.flip_h = true


func _move_to_player() -> void:
	move_direction = (player.position - self.position).normalized()
	if last_move_direction == move_direction:
		jump()
	last_move_direction = move_direction

