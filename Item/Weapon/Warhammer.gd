extends Weapon


# Called when the node enters the scene tree for the first time.
func _ready():
	type = 1
	rarity = 1
	
	weapon_damage = 15
	weapon_attack_speed = 1
	weapon_name = "Hammer"
	weapon_description = "damge: " + str(weapon_damage)
	weapon_story = "Hammer"
	
	get_node("ItemInfo").update_info()

