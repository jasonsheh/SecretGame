extends Node2D

class_name Weapon

@export var is_on_ground: bool = true
@export var is_ranged: bool = false
@export var rotation_offset: int = 0


var tween: Tween = null 
@onready var weapon_anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var weapon_hitbox: Hitbox = get_node("Sprite2D/Hitbox")
@onready var player_detector: Area2D = get_node("PlayerDetector")


func _ready() -> void:
	if not is_on_ground:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
	

func get_input() -> void:
	if Input.is_action_just_pressed("ui_attack") and not weapon_anim.is_playing():
		weapon_anim.play("attack")
		

func move(mouse_direction: Vector2) -> void:
	if is_ranged:
		rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	else:
		rotation = mouse_direction.angle()
		weapon_hitbox.knockback_direction = mouse_direction
	if scale.y == 1 and mouse_direction.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouse_direction.x > 0:
		scale.y = 1


func is_busy() -> bool:
	return weapon_anim.is_playing()


func _on_player_detector_body_entered(body) -> void:
	if body.name == "Player":
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		is_on_ground = false
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		if tween:
			tween.kill()
		player_detector.set_collision_mask_value(2, true)


func interpolate_pos(initial_pos: Vector2, final_pos: Vector2) -> void:
	position = initial_pos
	tween = create_tween()
	tween.tween_property(self, "position", final_pos, 0.8).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.connect("finished", _on_Tween_tween_completed)
	player_detector.set_collision_mask_value(1, true)


func _on_Tween_tween_completed() -> void:
	player_detector.set_collision_mask_value(2, true)


func get_texture() -> Texture2D:
	return get_node("Sprite2D").texture
