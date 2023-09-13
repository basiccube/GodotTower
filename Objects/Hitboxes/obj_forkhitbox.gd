extends StaticBody2D

var baddieid = ""

func _process(delta):
	if (!utils.instance_exists_level(baddieid)):
		queue_free()
	if (utils.instance_exists_level(baddieid)):
		var baddie = utils.get_instance_level(baddieid)
		scale.x = baddie.xscale
		if (scale.x == 1):
			position.x = (baddie.position.x - 50)
		elif (scale.x == -1):
			position.x = (baddie.position.x + 50)
		position.y = (baddie.position.y - 50)
		if (baddie.is_in_group("obj_forknight") || baddie.is_in_group("obj_indiancheese") || baddie.is_in_group("obj_noisey")):
			if (baddie.state != global.states.walk):
				baddie.hitboxcreate = false
				queue_free()
		if (baddie.is_in_group("obj_peasanto") || baddie.is_in_group("obj_fencer") || baddie.is_in_group("obj_ninja") || baddie.is_in_group("obj_pizzice") || baddie.is_in_group("obj_ancho")):
			if (baddie.state != global.states.charge):
				baddie.hitboxcreate = false
				queue_free()
