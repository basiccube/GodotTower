extends Area2D

func _ready():
	if (global.saveroom.has(global.targetRoom + name) && !global.panic && !global.timeattack):
		$Sprite.frame = 0

func _process(delta):
	var obj_player = utils.get_player()
	if (global.panic || global.timeattack):
		$Sprite.frame = 1
	if (overlaps_body(obj_player)):
		if (!global.panic && $Sprite.frame == 1):
			if (obj_player.state == global.states.comingoutdoor && obj_player.charactersprite.frame == obj_player.charactersprite.frames.get_frame_count(obj_player.charactersprite.animation) - 2):
				utils.playsound("Groundpound")
				obj_player.set_animation("timesup")
				for i in get_tree().get_nodes_in_group("obj_camera"):
					i.shake_mag = 3
					i.shake_mag_acc = (3 / 30)
				$Sprite.frame = 0
				global.saveroom.append(global.targetRoom + name)
		if (obj_player.is_on_floor() && Input.is_action_pressed("key_up") && (obj_player.state == global.states.normal || obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3) && (global.panic || global.timeattack)):
			global.targetDoor = ""
			for i in get_tree().get_nodes_in_group("obj_camera"):
				i.dedtimer.stop()
			for i in get_tree().get_nodes_in_group("obj_music"):
				i.musicnode.stop()
			utils.savescore(global.targetLevel)
			if (!utils.instance_exists("obj_endlevelfade")):
				utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_endlevelfade.tscn")
			for i in get_tree().get_nodes_in_group("obj_endlevelfade"):
				if (i.timer.is_stopped()):
					i.timer.start()
			obj_player.state = global.states.door
			obj_player.velocity.x = 0
			obj_player.set_animation("lookdoor")
			global.panic = false
			global.timeattack = false

func _on_obj_exitgate_body_entered(body):
	if body is obj_player && (global.panic || global.timeattack):
		utils.get_player().indoor = true

func _on_obj_exitgate_body_exited(body):
	if body is obj_player && (global.panic || global.timeattack):
		utils.get_player().indoor = false
