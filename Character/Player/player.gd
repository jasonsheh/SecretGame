extends Character

enum {UP, DOWN}

var is_on_ladder: bool = false
var is_in_weapon: bool = false
var is_in_chest:  bool = false
var is_in_relic:   bool = false

var pick_up_item: Node2D = null
var chest: Node2D = null

signal weapon_switched(type)
signal weapon_picked_up(type, weapon_texture)
signal weapon_droped(type)
signal relic_picked_up(relic_texture)

const MELEE_TYPE: int = 0
const RANGE_TYPE: int = 1

var current_weapon: Node2D
var current_weapon_type: int = 0
var weapon_count: int = 0

var relic_list: Array = []

@onready var melee_weapon: Node2D = get_node("MeleeWeapon")
@onready var range_weapon: Node2D = get_node("RangeWeapon")

func _ready() -> void:
	_restore_previous_state()


func _restore_previous_state() -> void:
	self.hp = SaveData.player_data.hp
	var _weapon: Node2D
	current_weapon_type = SaveData.player_data.equipped_weapon_type
	
	for weapon_type in SaveData.player_data.weapon.keys():
		if SaveData.player_data.weapon[weapon_type]:
			weapon_count += 1
			_weapon = load("res://Item/Weapon/%s.tscn" % SaveData.player_data.weapon[weapon_type]).instantiate()
			_weapon.is_on_ground = false
			_weapon.hide()
			_weapon.position = Vector2.ZERO
		
			if weapon_type == MELEE_TYPE:
				melee_weapon.add_child(_weapon)
			if weapon_type == RANGE_TYPE:
				range_weapon.add_child(_weapon)
			emit_signal("weapon_picked_up", weapon_type, _weapon.get_texture())
		
	if current_weapon_type == MELEE_TYPE and melee_weapon.get_child_count() > 0:
		current_weapon = melee_weapon.get_child(0)
	if current_weapon_type == RANGE_TYPE and range_weapon.get_child_count() > 0:
		current_weapon = range_weapon.get_child(0)
	
	if current_weapon:
		current_weapon.show()
		current_weapon.get_node("ItemInfo").hide()
	
	for _relic in SaveData.player_data.relics:
		relic_list.append(_relic)
		_relic = load("res://Item/Relic/Relic%s.tscn" % _relic).instantiate()
		emit_signal("relic_picked_up", _relic.get_texture())

func _process(_delta) -> void:
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	if mouse_direction.x > 0 and character_sprite.flip_h:
		character_sprite.flip_h = false
	elif mouse_direction.x < 0 and not character_sprite.flip_h:
		character_sprite.flip_h = true
	
	if current_weapon:
		current_weapon.move(mouse_direction)


func get_input() -> void:
	move_direction.x = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		jump()
	
	if is_on_ladder:
		move_direction.y = Input.get_axis("ui_up", "ui_down")
		# move_direction.x = 0
		climb()
	
	if current_weapon and not current_weapon.is_busy():
		if Input.is_action_just_released("ui_previous_weapon") or Input.is_action_just_released("ui_next_weapon"):
			_switch_weapon()
		elif Input.is_action_just_pressed("ui_drop") and (melee_weapon.get_child_count() + range_weapon.get_child_count()) > 0:
			_drop_weapon()
			return
		if Input.is_action_pressed("ui_attack"):
			current_weapon.attack()
			MAX_SPEED = 100
		if MAX_SPEED != PLAYER_MAX_SPEED and not current_weapon.is_busy():
			MAX_SPEED = PLAYER_MAX_SPEED
	
	if is_in_weapon and Input.is_action_just_released("ui_interact"):
		pick_up_item.get_node("PlayerDetector").set_collision_mask_value(1, false)
		pick_up_item.get_node("PlayerDetector").set_collision_mask_value(2, false)
		pick_up_weapon(pick_up_item)
		pick_up_item.position = Vector2.ZERO
		pick_up_item.get_node("ItemInfo").hide()
		is_in_weapon = false
		pick_up_item = null
	if is_in_chest and Input.is_action_just_released("ui_interact"):
		chest.open_chest()
		is_in_relic = false
		chest = null
	if is_in_relic and Input.is_action_just_released("ui_interact"):
		pick_up_relic(pick_up_item)

	
func pick_up_relic(relic: Node2D) -> void:
	SaveData.player_data.relics.append(relic.relic_name)
	relic_list.append(relic)
	emit_signal("relic_picked_up", relic.get_texture())
	relic.get_parent().call_deferred("remove_child", relic)


func pick_up_weapon(weapon: Node2D) -> void:
	SaveData.player_data.equipped_weapon_type = weapon.type
	if current_weapon:
		current_weapon.hide()
	current_weapon = weapon
	current_weapon_type = weapon.type
	
	# 移除世界中的武器
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapon_count += 1
	if weapon.type == MELEE_TYPE:
		if melee_weapon.get_child_count() != 0:
			# 把当前持有的武器扔掉
			_drop_weapon()
			current_weapon.hide()
			
		melee_weapon.call_deferred("add_child", weapon)
		weapon.set_deferred("owner", melee_weapon)
		
	if weapon.type == RANGE_TYPE:
		if range_weapon.get_child_count() != 0:
			_drop_weapon()
			current_weapon.hide()
			
		range_weapon.call_deferred("add_child", weapon)
		weapon.set_deferred("owner", range_weapon)

	current_weapon = weapon
	current_weapon.show()
	current_weapon.get_node("ItemInfo").hide()
	current_weapon_type = weapon.type
	
	SaveData.player_data.weapon[weapon.type] = weapon.weapon_name
	SaveData.player_data.equipped_weapon_type = current_weapon_type
	
	emit_signal("weapon_picked_up", weapon.type, weapon.get_texture())
	emit_signal("weapon_switched", weapon.type)

func _switch_weapon() -> void:
	current_weapon.hide()
	if weapon_count == 0:
		current_weapon = null
		return
	if current_weapon_type == MELEE_TYPE and range_weapon.get_child_count() > 0:
		current_weapon = range_weapon.get_child(0)
		current_weapon_type = RANGE_TYPE
	elif current_weapon_type == RANGE_TYPE and melee_weapon.get_child_count() > 0:
		current_weapon = melee_weapon.get_child(0)
		current_weapon_type = MELEE_TYPE
	current_weapon.show()
	current_weapon.get_node("ItemInfo").hide()
		
	SaveData.player_data.equipped_weapon_type = current_weapon_type
	emit_signal("weapon_switched", current_weapon_type)

func _drop_weapon() -> void:
	var weapon_to_drop: Node2D
	emit_signal("weapon_droped", current_weapon_type)
	if current_weapon_type == MELEE_TYPE:
		weapon_to_drop = melee_weapon.get_child(0)
		melee_weapon.call_deferred("remove_child", weapon_to_drop)
	if current_weapon_type == RANGE_TYPE:
		weapon_to_drop = range_weapon.get_child(0)
		range_weapon.call_deferred("remove_child", weapon_to_drop)
		
	SaveData.player_data.weapon[current_weapon_type] = null
	weapon_count -= 1
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	
	_switch_weapon()
	
	await weapon_to_drop.tree_entered
	weapon_to_drop.show()
	weapon_to_drop.get_node("ItemInfo").hide()
	weapon_to_drop.is_on_ground = true
	
	var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)


func _on_ladder_detector_body_entered(_body):
	is_on_ladder = true

func _on_ladder_detector_body_exited(_body):
	is_on_ladder = false

