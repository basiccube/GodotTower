extends Node2D

var optionselected = 0
var optionsaved_master = global.option_mastervolume
var optionsaved_sfx = global.option_sfxvolume
var optionsaved_music = global.option_musicvolume

var key_buffer = 0

func set_audio_config():
	global.option_mastervolume = optionsaved_master
	global.option_musicvolume = optionsaved_music
	global.option_sfxvolume = optionsaved_sfx
	var SaveManager = ConfigFile.new()
	var SaveData = SaveManager.load("user://saveData.ini")
	SaveManager.set_value("Option", "mastervolume", optionsaved_master)
	SaveManager.set_value("Option", "musicvolume", optionsaved_music)
	SaveManager.set_value("Option", "sfxvolume", optionsaved_sfx)
	SaveManager.save("user://saveData.ini")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(global.option_mastervolume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(global.option_musicvolume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(global.option_sfxvolume))

func _process(delta):
	if (Input.is_action_just_pressed("key_up") && optionselected > 0):
		optionselected -= 1
		utils.playsound("Step")
	if (Input.is_action_just_pressed("key_down") && optionselected < 2):
		optionselected += 1
		utils.playsound("Step")
	if (Input.is_action_just_pressed("key_jump")):
		set_audio_config()
	optionsaved_master = clamp(optionsaved_master, 0, 1)
	optionsaved_music = clamp(optionsaved_music, 0, 1)
	optionsaved_sfx = clamp(optionsaved_sfx, 0, 1)
	if (key_buffer > 0):
		key_buffer -= 1
	elif (optionselected == 0):
		if (Input.is_action_pressed("key_right") && optionsaved_master < 1):
			optionsaved_master += 0.01
		if (Input.is_action_pressed("key_left") && optionsaved_master > 0):
			optionsaved_master -= 0.01
	elif (optionselected == 1):
		if (Input.is_action_pressed("key_right") && optionsaved_music < 1):
			optionsaved_music += 0.01
		if (Input.is_action_pressed("key_left") && optionsaved_music > 0):
			optionsaved_music -= 0.01
	elif (optionselected == 2):
		if (Input.is_action_pressed("key_right") && optionsaved_sfx < 1):
			optionsaved_sfx += 0.01
		if (Input.is_action_pressed("key_left") && optionsaved_sfx > 0):
			optionsaved_sfx -= 0.01
	if (Input.is_action_just_pressed("key_left") || Input.is_action_just_pressed("key_right")):
		key_buffer = 7
	if ((Input.is_action_just_pressed("key_grab") || Input.is_action_just_pressed("key_escape"))):
		utils.playsound("EnemyProjectile")
		set_audio_config()
		var obj_option = utils.get_instance("obj_option")
		obj_option.visible = true
		queue_free()
	# Menu draw code
	$MasterVol.text = str(optionsaved_master * 100)
	$MusicVol.text = str(optionsaved_music * 100)
	$SFXVol.text = str(optionsaved_sfx * 100)
	if (optionselected == 0):
		$MasterText.modulate.a = 1
		$MasterVol.modulate.a = 1
	else:
		$MasterText.modulate.a = 0.5
		$MasterVol.modulate.a = 0.5
	if (optionselected == 1):
		$MusicText.modulate.a = 1
		$MusicVol.modulate.a = 1
	else:
		$MusicText.modulate.a = 0.5
		$MusicVol.modulate.a = 0.5
	if (optionselected == 2):
		$SFXText.modulate.a = 1
		$SFXVol.modulate.a = 1
	else:
		$SFXText.modulate.a = 0.5
		$SFXVol.modulate.a = 0.5
