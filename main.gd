extends Node2D

const TILE_SIZE = 8
const LEVEL_SIZE = Vector2(30, 30)

func _ready():
	set_config()
	randomize()
	
	SaveData.load_data()
	if !SaveData.player_data.dead:
		# character dead or first time play, need create new game
		$CenterContainer/VBoxContainer/ContinueButton.show()
	else:
		$CenterContainer/VBoxContainer/ContinueButton.hide()
	

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


# continue game
func _on_continue_button_pressed():
	# ToDo change to certain sceen
	get_tree().change_scene_to_file("res://Levels/Level0.tscn")
	

func _on_play_button_pressed():
	SaveData.reset_data()
	get_tree().change_scene_to_file("res://Levels/Level0.tscn")


func _on_option_button_pressed():
	$OptionScene.show()


func _on_credit_button_pressed():
	$CreditScene.is_show = true
	$CreditScene.show()


