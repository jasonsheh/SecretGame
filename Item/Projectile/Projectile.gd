extends Hitbox


var direction: Vector2 = Vector2.ZERO 

@export var projectile_damage: int = 10
@export var projectile_speed: int = 200
@export var projectile_size: int = 1
@export var projectile_range: int = 300
@export var projectile_init_pos: Vector2 = Vector2.ZERO

var is_enemy_shoot:bool = false


func launch(init_pos: Vector2, des_pos: Vector2) -> void:
	set_projectile_mask()
	projectile_init_pos = init_pos
	position = init_pos
	direction = des_pos
	knockback_direction = des_pos
	
	# 投射物旋转
	rotation += des_pos.angle()
	
func _physics_process(delta: float) -> void:
	position += direction * projectile_speed * delta
	
	#超出最大距离，释放投射物
	if projectile_init_pos.distance_to(position) > projectile_range:
		queue_free()


func set_projectile_mask() -> void:
	if is_enemy_shoot:
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		set_collision_mask_value(3, false)
		set_collision_mask_value(4, true)
	else:
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)
		set_collision_mask_value(3, true)
		set_collision_mask_value(4, true)

		
func _collide(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(projectile_damage, knockback_direction, knockback_force)
	queue_free()
