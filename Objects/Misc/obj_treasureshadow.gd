extends Node2D

func _process(delta):
	var obj_player = utils.get_player()
	position.x = obj_player.position.x
	position.y = obj_player.position.y
	if (obj_player.is_on_floor()):
		visible = true
	else:
		visible = false
