extends Node2D

const TILE_SIZE = 8
const LEVEL_SIZE = Vector2(30, 30)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_config()
	randomize()
	

func set_config():
	var _settings:Dictionary = Config.new().load_config()
	
	DisplayServer.window_set_size(_settings.video.resolution)
	
	if _settings.video.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if _settings.video.vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	TranslationServer.set_locale(_settings.game.language)



func _on_quit_button_pressed():
	get_tree().quit()



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Level0.tscn")


func _on_option_button_pressed():
	get_node("OptionScene").show()


func _on_credit_button_pressed():
	var CreditScene:Node2D = get_node("CreditScene")
	CreditScene.is_show = true
	CreditScene.show()
