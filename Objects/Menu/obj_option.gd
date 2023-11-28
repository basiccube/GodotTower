extends Node2D

var optionselected = 0
var optionsaved_resolution = global.option_resolution
var optionsaved_fullscreen = global.option_fullscreen

func _process(delta):
	if (!utils.instance_exists("obj_keyconfig") && !utils.instance_exists("obj_gameconfig") && !utils.instance_exists("obj_audioconfig")):
		if (Input.is_action_just_pressed("key_up") && optionselected > 0):
			optionselected -= 1
			utils.playsound("Step")
		if (Input.is_action_just_pressed("key_down") && optionselected < 3):
			optionselected += 1
			utils.playsound("Step")
	if (optionselected == 0):
		if (Input.is_action_just_pressed("key_right") && optionsaved_fullscreen):
			optionsaved_fullscreen = false
		if (Input.is_action_just_pressed("key_left") && !optionsaved_fullscreen):
			optionsaved_fullscreen = true
		if (Input.is_action_just_pressed("key_jump") && optionsaved_fullscreen):
			OS.window_fullscreen = true
			var SaveManager = ConfigFile.new()
			var SaveData = SaveManager.load("user://saveData.ini")
			SaveManager.set_value("Option", "fullscreen", true)
			global.option_fullscreen = true
			SaveManager.save("user://saveData.ini")
		if (Input.is_action_just_pressed("key_jump") && !optionsaved_fullscreen):
			OS.window_fullscreen = false
			var SaveManager = ConfigFile.new()
			var SaveData = SaveManager.load("user://saveData.ini")
			SaveManager.set_value("Option", "fullscreen", false)
			global.option_fullscreen = false
			SaveManager.save("user://saveData.ini")
	if (optionselected == 1):
		if (Input.is_action_just_pressed("key_right") && optionsaved_resolution < 2):
			optionsaved_resolution += 1
		if (Input.is_action_just_pressed("key_left") && optionsaved_resolution > 0):
			optionsaved_resolution -= 1
		if (Input.is_action_just_pressed("key_jump") && optionsaved_resolution == 0):
			OS.window_size = Vector2(480, 270)
			var SaveManager = ConfigFile.new()
			var SaveData = SaveManager.load("user://saveData.ini")
			SaveManager.set_value("Option", "resolution", 0)
			global.option_resolution = 0
			SaveManager.save("user://saveData.ini")
		if (Input.is_action_just_pressed("key_jump") && optionsaved_resolution == 1):
			OS.window_size = Vector2(960, 540)
			var SaveManager = ConfigFile.new()
			var SaveData = SaveManager.load("user://saveData.ini")
			SaveManager.set_value("Option", "resolution", 1)
			global.option_resolution = 1
			SaveManager.save("user://saveData.ini")
		if (Input.is_action_just_pressed("key_jump") && optionsaved_resolution == 2):
			OS.window_size = Vector2(1920, 1080)
			var SaveManager = ConfigFile.new()
			var SaveData = SaveManager.load("user://saveData.ini")
			SaveManager.set_value("Option", "resolution", 2)
			global.option_resolution = 2
			SaveManager.save("user://saveData.ini")
	if (optionselected == 2):
		if (!utils.instance_exists("obj_keyconfig")):
			if (Input.is_action_just_pressed("key_jump")):
				visible = false
				utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Menu/obj_keyconfig.tscn")
	if (optionselected == 3):
		if (!utils.instance_exists("obj_gameconfig")):
			if (Input.is_action_just_pressed("key_jump")):
				visible = false
				utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Menu/obj_gameconfig.tscn")
	if ((Input.is_action_just_pressed("key_grab") || Input.is_action_just_pressed("key_escape")) && !utils.instance_exists("obj_keyconfig") && !utils.instance_exists("obj_gameconfig") && !utils.instance_exists("obj_audioconfig")):
		utils.playsound("EnemyProjectile")
		var obj_mainmenuselect = utils.get_instance_level("obj_mainmenuselect")
		obj_mainmenuselect.selected = false
		queue_free()
	# Options menu draw code
	if (optionselected == 0):
		$Fullscreen.modulate.a = 1
	else:
		$Fullscreen.modulate.a = 0.5
	if (optionsaved_fullscreen):
		$FullscreenOn.modulate.a = 1
	else:
		$FullscreenOn.modulate.a = 0.5
	if (!optionsaved_fullscreen):
		$FullscreenOff.modulate.a = 1
	else:
		$FullscreenOff.modulate.a = 0.5
	if (optionselected == 1):
		$Resolution.modulate.a = 1
	else:
		$Resolution.modulate.a = 0.5
	if (optionsaved_resolution == 0):
		$Resolution480.modulate.a = 1
	else:
		$Resolution480.modulate.a = 0.5
	if (optionsaved_resolution == 1):
		$Resolution960.modulate.a = 1
	else:
		$Resolution960.modulate.a = 0.5
	if (optionsaved_resolution == 2):
		$Resolution1080.modulate.a = 1
	else:
		$Resolution1080.modulate.a = 0.5
	if (optionselected == 2):
		$KeyConfig.modulate.a = 1
	else:
		$KeyConfig.modulate.a = 0.5
	if (optionselected == 3):
		$GameConfig.modulate.a = 1
	else:
		$GameConfig.modulate.a = 0.5
