extends CanvasLayer

const INVENTORY_ITEM_SCENE: PackedScene = preload("res://UI/InventoryItem.tscn")
const INVENTORY_RELIC_SCENE: PackedScene = preload("res://UI/InventoryRelic.tscn")


@onready var player: CharacterBody2D = get_node("../Player")
@onready var health_bar: TextureProgressBar = get_node("HealthBar")
@onready var health_label: Label = get_node("HealthBar/HealthLabel")
@onready var energy_bar: TextureProgressBar = get_node("EnergyBar")
@onready var energy_label: Label = get_node("EnergyBar/EnergyLabel")

@onready var MeleeInventory: PanelContainer = get_node("MeleeInventory")
@onready var RangeInventory: PanelContainer = get_node("RangeInventory")
@onready var RelicInventory: GridContainer = get_node("RelicInventory")


func _ready() -> void:
	_update_health_bar(player.max_hp)


func _update_health_bar(current_hp: int) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(health_bar, "value", current_hp, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
func _update_health_label(current_hp: int, max_hp: int) -> void:
	health_label.text = str(current_hp) + "/" + str(max_hp)


func _on_player_hp_changed(new_hp: int, max_hp: int) -> void:
	_update_health_bar(new_hp)
	_update_health_label(new_hp, max_hp)


func _on_player_weapon_droped(type: int) -> void:
	if type == 0:
		MeleeInventory.get_child(0).queue_free()
	elif type == 1:
		RangeInventory.get_child(0).queue_free()


func _on_player_weapon_picked_up(type: int, weapon_texture: Texture2D) -> void:
	var new_inventory_item: TextureRect = INVENTORY_ITEM_SCENE.instantiate()
	if type == 0:
		MeleeInventory.add_child(new_inventory_item)
	elif type == 1:
		RangeInventory.add_child(new_inventory_item)
	new_inventory_item.texture = weapon_texture


func _on_player_weapon_switched(type: int) -> void:
	if type == 0:
		MeleeInventory.get_child(0).select()
		if RangeInventory.get_child_count() > 0:
			RangeInventory.get_child(0).deselect()
	elif type == 1:
		RangeInventory.get_child(0).select()
		if MeleeInventory.get_child_count() > 0:
			MeleeInventory.get_child(0).deselect()


func _on_player_relic_picked_up(relic_texture: Texture2D) -> void:
	var new_relic_item: TextureRect = INVENTORY_RELIC_SCENE.instantiate()
	new_relic_item.texture = relic_texture
	RelicInventory.add_child(new_relic_item)


