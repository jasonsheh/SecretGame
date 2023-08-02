extends TextureRect


@onready var border: ReferenceRect = get_node("ReferenceRect")


func select() -> void:
	border.show()
	
func deselect() -> void:
	border.hide()
