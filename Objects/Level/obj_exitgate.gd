extends Area2D

func _ready():
	if (global.saveroom.has(global.targetRoom + name) && !global.panic && !global.timeattack):
		$Sprite.frame = 0

func _process(delta):
	if (global.panic || global.timeattack):
		$Sprite.frame = 1
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player)):
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
				i.timer.wait_time = 3
				if (i.timer.is_stopped()):
					i.timer.start()
			obj_player.state = global.states.door
			obj_player.set_animation("lookdoor")
			global.panic = false
			global.timeattack = false

func _on_obj_exitgate_body_entered(body):
	if body is obj_player && (global.panic || global.timeattack):
		utils.get_player().indoor = true

func _on_obj_exitgate_body_exited(body):
	if body is obj_player && (global.panic || global.timeattack):
		utils.get_player().indoor = false
