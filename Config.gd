extends Node

class_name Config

func save_config(_settings: Dictionary) -> void:
	# Create new ConfigFile object.
	var config = ConfigFile.new()
	# Store some values.
	for section in _settings.keys():
		for key in _settings[section].keys():
			config.set_value(section, key, _settings[section][key])

	# Save it to a file (overwrite if already exists).
	config.save("user://saves.cfg")


func load_config() -> Dictionary:
	var score_data = {}
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load("user://saves.cfg")
	if err != OK:
		return set_default_config()

	# Iterate over all sections.
	for _section in config.get_sections():
		score_data[_section] = {}
		for _key in config.get_section_keys(_section):
			score_data[_section][_key] = config.get_value(_section, _key)
	
	return score_data


func set_default_config() -> Dictionary:
	var _settings: Dictionary = {
		video = {
			resolution = Vector2(640, 480),
			fullscreen = false,
			vsync = false
		},
		audio = {},
		game = {
			language = "en"
		},
		input = {},
	}
	save_config(_settings)
	return _settings
