extends Node2D

var pause = false
var selected = 0

func _process(delta):
	if (!pause && !utils.instance_exists("obj_fadeout")):
		if (Input.is_action_just_pressed("key_escape") && global.targetRoom != "rank_room" && global.targetRoom != "Realtitlescreen" && global.targetRoom != "timesuproom"):
			selected = 0
			if (!utils.instance_exists("obj_pausefadeout")):
				utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_pausefadeout.tscn")
	if (utils.instance_exists("obj_pausefadeout") && utils.instance_exists("obj_fadeout")):
		utils.get_instance("obj_pausefadeout").queue_free()
	if (pause):
		if (Input.is_action_just_pressed("key_down") && selected < 2):
			selected += 1
			utils.playsound("Step")
		if (Input.is_action_just_pressed("key_up") && selected > 0):
			selected -= 1
			utils.playsound("Step")
		if (Input.is_action_just_pressed("key_jump") && selected == 0):
			if (!utils.instance_exists("obj_pausefadeout")):
				utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_pausefadeout.tscn")
		if (Input.is_action_just_pressed("key_jump") && selected == 1):
			if (global.leveltorestart != "" && global.roomtorestart != ""):
				if utils.soundplaying("EscapeRumble"):
					utils.stopsound("EscapeRumble")
				get_tree().paused = false
				global.targetDoor = "A"
				utils.room_goto(global.leveltorestart, global.roomtorestart)
				utils.get_player().scr_playerreset()
				pause = false
			else:
				utils.playsound("EnemyProjectile")
		if (Input.is_action_just_pressed("key_jump") && selected == 2):
			if (global.targetRoom == "hub_room1" || global.targetRoom == "Titlescreen" || global.targetRoom == "Scootertransition"):
				pause = false
				get_tree().paused = false
				utils.get_player().character = "P"
				utils.get_player().scr_playerreset()
				utils.get_player().state = global.states.titlescreen
				global.targetDoor = "A"
				utils.room_goto("", "Realtitlescreen")
			else:
				pause = false
				get_tree().paused = false
				utils.get_player().scr_playerreset()
				global.targetDoor = "A"
				utils.room_goto("", "hub_room1")
			if utils.soundplaying("EscapeRumble"):
				utils.stopsound("EscapeRumble")
			global.roomtorestart = ""
			global.leveltorestart = ""
	var obj_camera = utils.get_instance("obj_camera")
	position.x = obj_camera.position.x - 480
	position.y = obj_camera.position.y - 270
	if (pause):
		$Sprite.frame = selected
		visible = true
	else:
		visible = false
