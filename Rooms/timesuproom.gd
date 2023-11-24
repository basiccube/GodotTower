extends Node2D


func _process(delta):
	var obj_camera = utils.get_instance("obj_camera")
	obj_camera.limit_left = 0
	obj_camera.limit_right = 960
	obj_camera.limit_top = 0
	obj_camera.limit_bottom = 540
