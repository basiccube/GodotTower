extends Node2D

func _process(delta):
	$Sprite.visible = false
	if utils.instance_exists("obj_camera"):
		var camera = utils.get_instance("obj_camera")
		camera.limit_right = global_position.x
