extends StaticBody2D

var baddieid = ""

func _process(_delta):
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
		var obj_player = utils.get_player()
		if (obj_player.instakillmove == 1 || obj_player.state == global.states.knightpep || obj_player.state == global.states.knightpepslopes):
			set_collision_mask_bit(0, false)
		else:
			set_collision_mask_bit(0, true)
		if (baddie.is_in_group("obj_forknight") || baddie.is_in_group("obj_indiancheese") || baddie.is_in_group("obj_noisey")):
			if (baddie.state != global.states.walk):
				baddie.hitboxcreate = false
				queue_free()
		if (baddie.is_in_group("obj_peasanto") || baddie.is_in_group("obj_fencer") || baddie.is_in_group("obj_ninja") || baddie.is_in_group("obj_pizzice") || baddie.is_in_group("obj_ancho")):
			if (baddie.state != global.states.charge):
				baddie.hitboxcreate = false
				queue_free()
