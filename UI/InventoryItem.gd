extends TextureRect


@onready var border: ReferenceRect = get_node("ReferenceRect")

func initialize(_texture: Texture) -> void:
	self.texture = _texture
	

func select() -> void:
	border.show()
	
func deselect() -> void:
	border.hide()
