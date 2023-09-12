extends "res://Objects/Level/obj_hurtbox.gd"

var baddieid = ""

func _process(delta):
	if (!utils.instance_exists_level(baddieid)):
		queue_free()
	if (utils.instance_exists_level(baddieid)):
		var baddie = utils.get_instance_level(baddieid)
		position.x = baddie.position.x
		position.y = baddie.position.y
