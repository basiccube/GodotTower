extends Node2D

func _ready():
	var obj_player = utils.get_player()
	if (obj_player.state == global.states.titlescreen):
		obj_player.set_animation("machfreefall")
		obj_player.state = global.states.backbreaker
		obj_player.movespeed = 20
		obj_player.velocity.y = 5
		obj_player.xscale = 1

func _process(delta):
	var obj_camera = utils.get_instance("obj_camera")
	obj_camera.limit_left = -48
	obj_camera.limit_right = 912
	obj_camera.limit_top = 0
	obj_camera.limit_bottom = 540
