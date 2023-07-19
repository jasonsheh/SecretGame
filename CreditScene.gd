extends Node2D

var is_show: bool = false
var line: float = 0.0
@onready var credit_text: RichTextLabel = get_node("RichTextLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		self.hide()
	
	if is_show:
		line += delta
		credit_text.scroll_to_line(int(line))

