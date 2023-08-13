extends Node2D


# Called when the node enters the scene tree for the first time.
func update_info():
	
	$Panel/VBoxContainer/ItemName.text = "[center][color={color}]{name}[/color][/center]".format(
		{
			"color": GlobalData.item_rarity_color[get_parent().rarity],
			"name": get_parent().weapon_name,
		}
	)
	get_node("Panel/VBoxContainer/ItemDescription").text = get_parent().weapon_description
	get_node("Panel/VBoxContainer/ItemStory").text = get_parent().weapon_story

