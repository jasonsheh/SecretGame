extends Character

enum {UP, DOWN}


signal weapon_switched(prev_index, new_index)
signal weapon_picked_up(weapon_texture)
signal weapon_droped(index)

var current_weapon: Node2D
@onready var weapons: Node2D = get_node("Weapons")

func _ready() -> void:
	_restore_previous_state()
	
func _restore_previous_state() -> void:
	self.hp = SaveData.hp
	if SaveData.weapons.size() > 0:
		for _weapon in SaveData.weapons:
			_weapon = _weapon.duplicate()
			_weapon.position = Vector2.ZERO
			weapons.add_child(_weapon)
			_weapon.hide()
			
			emit_signal("weapon_picked_up", _weapon.get_texture())
			if weapons.get_child_count() > 1:
				emit_signal("weapon_switched", weapons.get_child_count() - 2, weapons.get_child_count() - 1)
			else:
				emit_signal("weapon_switched", weapons.get_child_count() - 1, weapons.get_child_count() - 1)
		current_weapon = weapons.get_child(SaveData.equipped_weapon_index)
		current_weapon.show()

	
func get_input() -> void:
	move_direction.x = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		jump()
	
	if current_weapon and not current_weapon.is_busy():
		if Input.is_action_just_released("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("ui_next_weapon"):
			_switch_weapon(DOWN)
		elif Input.is_action_just_pressed("ui_drop") and weapons.get_child_count() > 0:
			# 不能丢掉唯一的武器，但实际上这里是不能丢掉编号位0的武器
			_drop_weapon()
		current_weapon.get_input()


func _process(_delta) -> void:
	# Add the gravity.
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	if mouse_direction.x > 0 and character_sprite.flip_h:
		character_sprite.flip_h = false
	elif mouse_direction.x < 0 and not character_sprite.flip_h:
		character_sprite.flip_h = true
	
	if current_weapon:
		current_weapon.move(mouse_direction)
	

func _switch_weapon(button: int) -> void:
	var prev_index: int = current_weapon.get_index()
	var index: int = prev_index
	if button == UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0
	
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	SaveData.equipped_weapon_index = index
	
	emit_signal("weapon_switched", prev_index, index)



func pick_up_weapon(weapon: Node2D) -> void:
	SaveData.weapons.append(weapon.duplicate())
	
	var prev_index: int = SaveData.equipped_weapon_index
	var new_index: int = weapons.get_child_count()
	
	SaveData.equipped_weapon_index = new_index
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	if current_weapon:
		current_weapon.hide()
	current_weapon = weapon
	
	emit_signal("weapon_picked_up", weapon.get_texture())
	emit_signal("weapon_switched", prev_index, new_index)
	
func _drop_weapon() -> void:
	SaveData.weapons.remove_at(current_weapon.get_index())
	var weapon_to_drop: Node2D = current_weapon
	_switch_weapon(UP)
	
	emit_signal("weapon_droped", weapon_to_drop.get_index())
	
	weapons.call_deferred("remove_child", weapon_to_drop)
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	
	await weapon_to_drop.tree_entered
	weapon_to_drop.show()

	var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)

