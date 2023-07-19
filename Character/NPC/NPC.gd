extends Character

class_name NPC

@onready var player: CharacterBody2D = get_node("../Player") # ./Level1/Player
@onready var is_chased: bool = false
@onready var last_move_direction: Vector2 = Vector2.ZERO
@onready var dialog: Label = get_node("Dialog")

var is_player_nearby: bool = false

func _ready():
	JUMP_VELOCITY = -200


func face_to_player() -> void:
	var face_direction = (player.position - self.position).normalized()
	if face_direction.x < 0 and character_sprite.flip_h:
		character_sprite.flip_h = false
	elif face_direction.x > 0 and not character_sprite.flip_h:
		character_sprite.flip_h = true


func set_dialog(_text: String) -> void:
	dialog.text = _text


func _on_player_detection_body_entered(body:CharacterBody2D) -> void:
	face_to_player()
	set_dialog("Welcoome traveller")
	if body.name == "Player":
		is_player_nearby = true
		get_node("Interactive").show()



func _on_player_detection_body_exited(body:CharacterBody2D) -> void:
	set_dialog("Goodbye traveller")
	if body.name == "Player":
		is_player_nearby = false
		get_node("Interactive").hide()
