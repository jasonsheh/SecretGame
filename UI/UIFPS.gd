extends Label

func _ready():
	if Config.new().load_config().video.fps:
		show()
	else:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = str(Engine.get_frames_per_second())
