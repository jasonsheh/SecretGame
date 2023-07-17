extends Character

class_name NPC

@onready var player: CharacterBody2D = get_node("../Player") # ./Level1/Player
@onready var is_chased: bool = false
@onready var last_move_direction: Vector2 = Vector2.ZERO

func _ready():
	JUMP_VELOCITY = -200


func face_to_player() -> void:
	var face_direction = (player.position - self.position).normalized()
	if face_direction.x > 0 and character_sprite.flip_h:
		character_sprite.flip_h = false
	elif face_direction.x < 0 and not character_sprite.flip_h:
		character_sprite.flip_h = true


func _on_player_detection_body_entered(body) -> void:
	face_to_player()
	if body.name == "Player":
		print("enter e")

