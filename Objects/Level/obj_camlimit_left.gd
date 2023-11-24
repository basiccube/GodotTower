extends Node2D

func _process(delta):
	$Sprite.visible = false
	if utils.instance_exists("obj_camera") && !global.debugview:
		var camera = utils.get_instance("obj_camera")
		camera.limit_left = global_position.x
