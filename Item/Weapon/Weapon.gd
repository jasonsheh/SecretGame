extends Node2D

class_name Weapon

var is_on_ground: bool = true
@export var type: int = 0
@export var rotation_offset: int = 0

@export var weapon_damage: int = 10
@export var weapon_critical_chance: float = 1.1
@export var weapon_attack_speed: float = 1.2

var tween: Tween = null 
@onready var weapon_anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var weapon_hitbox: Hitbox = get_node("Hitbox")
@onready var player_detector: Area2D = get_node("PlayerDetector")


func _ready() -> void:
	if not is_on_ground:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
	

func get_input() -> void:
	if Input.is_action_just_pressed("ui_attack") and not weapon_anim.is_playing():
		weapon_anim.play("attack")
		

func move(mouse_direction: Vector2) -> void:
	if type == 1:
		rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	else:
		rotation = mouse_direction.angle()
		weapon_hitbox.knockback_direction = mouse_direction
	if scale.y == 1 and mouse_direction.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouse_direction.x > 0:
		scale.y = 1
	

func _on_player_detector_body_entered(body) -> void:
	if body.name == "Player":
		get_node("ItemInfo").show()
		is_on_ground = false
		
		body.is_in_item = true
		body.pick_up_item = self
	else:
		if tween:
			tween.kill()

func _on_player_detector_body_exited(body):
	is_on_ground = true
	if body.name == "Player":
		body.is_in_item = false
		body.pick_up_item = null
	get_node("ItemInfo").hide()


func interpolate_pos(initial_pos: Vector2, final_pos: Vector2) -> void:
	position = initial_pos
	tween = create_tween()
	tween.tween_property(self, "position", final_pos, 0.8).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.connect("finished", _on_Tween_tween_completed)
	player_detector.set_collision_mask_value(1, true)


func _on_Tween_tween_completed() -> void:
	player_detector.set_collision_mask_value(2, true)
	rotation = 0
	scale.y = 1


func get_texture() -> Texture2D:
	return get_node("Hitbox/Sprite2D").texture


func is_busy() -> bool:
	return weapon_anim.is_playing()
