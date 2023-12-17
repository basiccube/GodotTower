extends StaticBody2D

var baddieid = ""

func _process(_delta):
	if (utils.instance_exists_level(baddieid)):
		var baddie = utils.get_instance_level(baddieid)
		scale.x = baddie.xscale
		if (scale.x == 1):
			position.x = (baddie.position.x - 5)
		elif (scale.x == -1):
			position.x = (baddie.position.x + 5)
		position.y = (baddie.position.y - 50)
		if (baddie.state != global.states.rage):
			queue_free()
	else:
		queue_free()
