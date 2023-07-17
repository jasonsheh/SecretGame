extends CharacterBody2D

class_name Character

const FRICTION: float = 0.15
@export var accerelation: int = 30
@export var speed: int = 150
@export var MAX_SPEED: int = 300

@export var max_hp:int = 100
@export var hp:int = 100: set = set_hp
signal hp_changed(new_hp)

var JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var move_direction: Vector2 = Vector2.ZERO


@onready var character_anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var character_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

@onready var state_machine: Node = get_node("FiniteStateMachine")

func _physics_process(_delta: float) -> void:
	move_and_slide()
	velocity.x = lerp(velocity.x, 0.0, FRICTION)
	if abs(velocity.x) < 1:
		velocity.x = 0


func move(delta) -> void:
	# velocity.x = move_direction * speed
	velocity.x += move_direction.x * accerelation

	if not is_on_floor():
		velocity.y += gravity * delta

func jump() -> void:
	velocity.y = JUMP_VELOCITY

	
func take_damage(damage: int, direction: Vector2, force: int) -> void:
	self.hp -= damage
	if state_machine.state != state_machine.states.hurt:
		if name == "Player":
			SaveData.hp = hp
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += direction * force
		else:
			state_machine.set_state(state_machine.states.death)
			velocity += direction * force * 1.5


func set_hp(new_hp: int) -> void:
	hp = clamp(new_hp, 0, max_hp)
	emit_signal("hp_changed", hp)


