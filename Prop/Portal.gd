extends Area2D


@export var next_level: String

@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")
@onready var animation: AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	animation.play("idle")

func _on_body_entered(_body: CharacterBody2D) -> void:
	collision_shape.set_deferred("disabled", true)
	SceneTransistor.start_transition_to(next_level)
