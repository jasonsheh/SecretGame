extends FiniteStateMachine


func _init() -> void:
	for _state in ["idle", "listen", "talk",]:
		_add_state(_state)

func _ready() -> void:
	set_state(states.idle)


func _state_logic(_delta: float) -> void:
	if state == states.listen:
		parent.get_input()


func _get_transition() -> int:
	match state:
		states.idle:
			if parent.is_player_nearby:
				return states.listen
				
		states.listen:
			if not parent.is_player_nearby:
				return states.idle
	return -1


func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.idle:
			character_anim.play("idle")
		states.listen:
			character_anim.play("idle")
