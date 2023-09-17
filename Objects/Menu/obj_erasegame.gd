extends Node2D

var optionselected = 0

func _process(delta):
	if (Input.is_action_just_pressed("key_left") && optionselected > 0):
		optionselected -= 1
		utils.playsound("Step")
	if (Input.is_action_just_pressed("key_right") && optionselected < 1):
		optionselected += 1
		utils.playsound("Step")
	if (optionselected == 1 && Input.is_action_just_pressed("key_jump")):
		var SaveManager = ConfigFile.new()
		var SaveData = SaveManager.load("user://saveData.ini")
		SaveManager.clear()
		SaveManager.save("user://saveData.ini")
		utils.playsound("BreakBlock1")
		var obj_mainmenuselect = utils.get_instance_level("obj_mainmenuselect")
		obj_mainmenuselect.selected = false
		queue_free()
	if ((Input.is_action_just_pressed("key_grab") || (optionselected == 0 && Input.is_action_just_pressed("key_jump")) || Input.is_action_just_pressed("key_escape"))):
		utils.playsound("EnemyProjectile")
		var obj_mainmenuselect = utils.get_instance_level("obj_mainmenuselect")
		obj_mainmenuselect.selected = false
		queue_free()
	# Draw code
	if (optionselected == 0):
		$No.modulate.a = 1
	else:
		$No.modulate.a = 0.5
	if (optionselected == 1):
		$Yes.modulate.a = 1
	else:
		$Yes.modulate.a = 0.5
