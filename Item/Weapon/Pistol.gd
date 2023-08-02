extends Weapon

const BULLET_SIMPLE_SCENE:PackedScene = preload("res://Item/Projectile/ProjectileBulletSimple.tscn")

func _ready():
	type = 1
	
	weapon_damage = 8
	
	weapon_name = "Pistol"
	weapon_description = "damge: " + str(weapon_damage)
	weapon_story = "Pistol"
	
	get_node("ItemInfo").update_info()

func shoot(offset: int) -> void:
	var projectile: Area2D = BULLET_SIMPLE_SCENE.instantiate()
	projectile.projectile_damage = weapon_damage
	get_tree().current_scene.add_child(projectile)
	projectile.launch(global_position, Vector2.RIGHT.rotated(deg_to_rad(rotation_degrees + offset)))
