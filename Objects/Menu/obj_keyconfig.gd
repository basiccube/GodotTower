extends Node2D

var key_select = 0
var selecting = -1

func _process(delta):
	if (selecting == -1):
		if (Input.is_action_just_pressed("key_up") && key_select > -1):
			key_select -= 1
			utils.playsound("Step")
		if (Input.is_action_just_pressed("key_down") && key_select < 8):
			key_select += 1
			utils.playsound("Step")
		if (Input.is_action_just_pressed("key_left")):
			key_select = -1
	if (key_select == -1 && selecting == -1 && Input.is_action_just_pressed("key_jump")):
		utils.playsound("EnemyProjectile")
		var SaveManager = ConfigFile.new()
		var SaveData = SaveManager.load("user://saveData.ini")
		SaveManager.save("user://saveData.ini")
		var obj_option = utils.get_instance("obj_option")
		obj_option.visible = true
		queue_free()
	if (key_select == -1):
		$Back.modulate.a = 1
	else:
		$Back.modulate.a = 0.5
	if (key_select == 0):
		$Up.modulate.a = 1
		$UpKey.modulate.a = 1
	else:
		$Up.modulate.a = 0.5
		$UpKey.modulate.a = 0.5
	if (key_select == 1):
		$Down.modulate.a = 1
		$DownKey.modulate.a = 1
	else:
		$Down.modulate.a = 0.5
		$DownKey.modulate.a = 0.5
	if (key_select == 2):
		$Right.modulate.a = 1
		$RightKey.modulate.a = 1
	else:
		$Right.modulate.a = 0.5
		$RightKey.modulate.a = 0.5
	if (key_select == 3):
		$Left.modulate.a = 1
		$LeftKey.modulate.a = 1
	else:
		$Left.modulate.a = 0.5
		$LeftKey.modulate.a = 0.5
	if (key_select == 4):
		$Jump.modulate.a = 1
		$JumpKey.modulate.a = 1
	else:
		$Jump.modulate.a = 0.5
		$JumpKey.modulate.a = 0.5
	if (key_select == 5):
		$Grab.modulate.a = 1
		$GrabKey.modulate.a = 1
	else:
		$Grab.modulate.a = 0.5
		$GrabKey.modulate.a = 0.5
	if (key_select == 6):
		$Dash.modulate.a = 1
		$DashKey.modulate.a = 1
	else:
		$Dash.modulate.a = 0.5
		$DashKey.modulate.a = 0.5
	if (key_select == 7):
		$Taunt.modulate.a = 1
		$TauntKey.modulate.a = 1
	else:
		$Taunt.modulate.a = 0.5
		$TauntKey.modulate.a = 0.5
	if (key_select == 8):
		$Pause.modulate.a = 1
		$PauseKey.modulate.a = 1
	else:
		$Pause.modulate.a = 0.5
		$PauseKey.modulate.a = 0.5
