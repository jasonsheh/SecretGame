extends Area2D
class_name Hitbox

@export var damage: int = 10
var knockback_direction: Vector2 = Vector2.ZERO
@export var knockback_force: int = 100

@onready var collision_shape: CollisionShape2D = get_child(0)
@onready var timer: Timer = Timer.new()

var is_inside_body:bool = false

func _init() -> void:
	var __ = connect("body_entered", Callable(self, "_on_body_entered"))
	__ = connect("body_exited", Callable(self, "_on_body_exited"))


func _ready() -> void:
	assert(collision_shape != null)
	timer.wait_time = 1 # 受伤后的无敌时间
	add_child(timer)
	

func _on_body_entered(body: Node2D) -> void:
	timer.start()
	is_inside_body = true
	while is_inside_body:
		_collide(body)
		await timer.timeout

func _on_body_exited(_body: Node2D) -> void:
	is_inside_body = false
	timer.stop()


func _collide(body: Node2D) -> void:
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		body.take_damage(damage, knockback_direction, knockback_force)
