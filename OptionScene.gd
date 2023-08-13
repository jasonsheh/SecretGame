extends Node2D

var _settings: Dictionary

const resolution_list: Array = [
	Vector2(640, 360),
	Vector2(640, 480),
	Vector2(720, 480),
	Vector2(800, 600),
	Vector2(1024, 768),
	Vector2(1280, 720),
	Vector2(1280, 1024),
	Vector2(1366, 768),
	Vector2(1600, 900),
	Vector2(1600, 1200),
	Vector2(1920, 1080),
	Vector2(1920, 1200),
	Vector2(2560, 1440),
	Vector2(3840, 2160),
]

const language_list: Array = [
	"English",
	"Chinese"
]

const language_dict: Dictionary = {
	"English": "en",
	"Chinese": "zh_CN",
}

func _ready():
	_settings = Config.new().load_config()
	$TabContainer/KEY_OPTION_VIDEO/FullScreenContainer/FullScreenButton.button_pressed = _settings.video.fullscreen
	$TabContainer/KEY_OPTION_VIDEO/VsyncContainer/VsyncButton.button_pressed = _settings.video.vsync
	$TabContainer/KEY_OPTION_VIDEO/FPSContainer/FPSButton.button_pressed = _settings.video.fps
	$TabContainer/KEY_OPTION_VIDEO/ResolutionContainer/ResolutionOption.selected = resolution_list.find(_settings.video.resolution)
	$TabContainer/KEY_OPTION_GAMEPLAY/LanguageContainer/LanguageOption.selected = language_dict.values().find(_settings.game.language)

func _on_resolution_option_item_selected(index):
	_settings.video.resolution = resolution_list[index]
	# get_viewport().content_scale_size = _settings.resolution
	DisplayServer.window_set_size(_settings.video.resolution)


func _on_full_screen_button_pressed():
	if get_node("TabContainer/KEY_OPTION_VIDEO/FullScreenContainer/FullScreenButton").button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		_settings.video.fullscreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_settings.video.fullscreen = false

func _on_vsync_button_pressed():
	if $TabContainer/KEY_OPTION_VIDEO/FullScreenContainer/FullScreenButton.button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		_settings.video.vsync = true
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		_settings.video.vsync = true

func _on_fps_button_pressed():
	if $TabContainer/KEY_OPTION_VIDEO/FPSContainer/FPSButton.button_pressed:
		_settings.video.fps = true
	else:
		_settings.video.fps = false

func _on_language_option_item_selected(index):
	_settings.game.language = language_dict[language_list[index]]
	TranslationServer.set_locale(_settings.game.language)

func _on_apply_button_pressed() -> void:
	Config.new().save_config(_settings)


func _on_close_button_pressed():
	self.hide()

