extends FiniteStateMachine


func _init() -> void:
	for _state in ["idle", "run", "jump", "fall", "hurt", "death", "climb"]:
		_add_state(_state)
	
func _ready() -> void:
	set_state(states.idle)


func _state_logic(_delta: float) -> void:
	if state != states.hurt and state != states.death:
		parent.get_input()
		parent.move(_delta)

func _get_transition() -> int:
	match state:
		states.idle:
			if parent.velocity.x != 0:
				return states.run
				
			if parent.velocity.y > 0 and not parent.is_on_ladder:
				return states.fall
			
			if parent.velocity.y < 0 and not parent.is_on_ladder:
				return states.jump
				
			if parent.velocity.y != 0 and parent.is_on_ladder:
				return states.climb
				
		states.run:
			if parent.velocity.x == 0:
				return states.idle
			
			if parent.velocity.y != 0 and parent.is_on_ladder:
				return states.climb

			if parent.velocity.y > 0 and not parent.is_on_ladder:
				return states.fall
			
			if parent.velocity.y < 0 and not parent.is_on_ladder:
				return states.jump
		
		states.fall:
			if parent.velocity.y != 0 and parent.is_on_ladder:
				return states.climb
			if parent.velocity.y == 0:
				return states.idle
		
		states.jump:
			if parent.velocity.y != 0 and parent.is_on_ladder:
				return states.climb
			if parent.velocity.y == 0:
				return states.idle
		
		states.climb:
			if parent.velocity.y == 0:
				return states.idle
		
		states.hurt:
			if not character_anim.is_playing():
				return states.idle
		
		states.death:
			if not character_anim.is_playing():
				parent.queue_free()
				get_tree().change_scene_to_file("res://main.tscn")
	return -1

func _enter_state(_previous_state: int, _new_state: int) -> void:
	match _new_state:
		states.idle:
			character_anim.play("idle")
		states.run:
			character_anim.play("run")
		states.jump:
			character_anim.play("jump")
		states.fall:
			character_anim.play("fall")
		states.climb:
			character_anim.play("climb")
		states.hurt:
			character_anim.play("hurt")
		states.death:
			character_anim.play("death")
