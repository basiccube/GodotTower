extends Node2D

onready var phone = $Phone
onready var menulight = $MenuLightBG

func _process(delta):
	$Phone.playing = true
	$Phone.speed_scale = 0.35
	utils.get_player().state = global.states.titlescreen
	var obj_camera = utils.get_instance("obj_camera")
	obj_camera.limit_left = 0
	obj_camera.limit_right = 960
	obj_camera.limit_top = 0
	obj_camera.limit_bottom = 540
