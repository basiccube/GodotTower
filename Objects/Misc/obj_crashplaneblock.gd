extends Area2D

func _process(delta):
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player) && !utils.instance_exists_level("obj_crashingplane")):
		utils.instance_create_level(obj_player.position.x, obj_player.position.y, "res://Objects/Misc/obj_crashingplane.tscn")
