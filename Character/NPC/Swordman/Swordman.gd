extends NPC

const NPC_BASIC_WEAPON_LIST:Array = [
	preload("res://Item/Weapon/Sword.tscn"),
	preload("res://Item/Weapon/Warhammer.tscn")
]

@onready var weapon_pos: Marker2D = get_node("WeaponPos")


func get_input() -> void:
	if Input.is_action_just_pressed("ui_interact"):
		var weapon: Node2D = NPC_BASIC_WEAPON_LIST[randi() % NPC_BASIC_WEAPON_LIST.size()].instantiate()
		weapon.position = weapon_pos.position
#		weapon.is_on_ground = true
		add_child(weapon)
		set_dialog("you are welcome.")
	

