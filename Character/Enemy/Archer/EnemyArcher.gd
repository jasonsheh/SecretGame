extends Enemy

const PROJECTILE_ARROW_SCENE: PackedScene = preload("res://Item/Projectile/ProjectileArrowSimple.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 300
const MIN_DISTANCE_TO_PLAYER: int = 100

@onready var attack_timer: Timer = get_node("AttackTimer")


var is_attackable: bool = true

var distance_to_player: float

func shot() -> void:
	if is_chased:
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_move_to_player()
		else:
			if is_attackable:
				is_attackable = false
				face_to_player()
				create_bullet()
				attack_timer.start()
	else:
		pass


func create_bullet() -> void:
	var projectile: Area2D = PROJECTILE_ARROW_SCENE.instantiate()
	projectile.is_enemy_shoot = true
	projectile.launch(global_position, (player.position-global_position).normalized())
	get_tree().current_scene.add_child(projectile)
	
func _on_attack_timer_timeout() -> void:
	is_attackable = true
