extends FiniteStateMachine


func _init() -> void:
	for _state in ["idle", "chase", "hurt", "death", "attack"]:
		_add_state(_state)

func _ready() -> void:
	set_state(states.idle)


func _state_logic(_delta: float) -> void:
	parent.shot()
	parent.move(_delta)

func _get_transition() -> int:
	match state:
		states.idle:
			if parent.move_direction.x != 0:
				return states.chase
				
		states.chase:
			if parent.distance_to_player < parent.MAX_DISTANCE_TO_PLAYER:
				return states.attack
			if parent.move_direction.x == 0:
				return states.idle
		
		states.attack:
			if parent.distance_to_player > parent.MAX_DISTANCE_TO_PLAYER:
				return states.chase
		
		states.hurt:
			if parent.move_direction.x != 0 and not character_anim.is_playing():
				return states.chase
			if parent.move_direction.x == 0 and not character_anim.is_playing():
				return states.idle
			
		states.death:
			if not character_anim.is_playing():
				parent.queue_free()
	return -1


func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.idle:
			character_anim.play("idle")
		states.chase:
			character_anim.play("run")
		states.attack:
			character_anim.play("attack")
		states.hurt:
			character_anim.play("hurt")
		states.death:
			character_anim.play("death")
