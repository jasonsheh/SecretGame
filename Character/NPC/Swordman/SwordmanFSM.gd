extends FiniteStateMachine


func _init() -> void:
	for _state in ["idle", "chase", "hurt", "death", "attack"]:
		_add_state(_state)

func _ready() -> void:
	set_state(states.idle)
	

func _state_logic(_delta: float) -> void:
	parent.move(_delta)

func _get_transition() -> int:
	match state:
		states.idle:
			pass
	return -1


func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.idle:
			character_anim.play("idle")

