extends Area2D

var baddieid = ""

func _process(delta):
	var baddie = utils.get_instance_level(baddieid)
	if (!utils.instance_exists_level(baddieid) || baddie.state != global.states.pizzagoblinthrow):
		queue_free()
	if (utils.instance_exists_level(baddieid)):
		scale.x = baddie.xscale
		position.x = baddie.position.x + (baddie.xscale * 50)
		position.y = baddie.position.y

func _on_obj_pepgoblin_kickhitbox_body_entered(body):
	if body is obj_player:
		var obj_player = utils.get_player()
		if (utils.instance_exists_level(baddieid) && obj_player.state != global.states.tumble && obj_player.state != global.states.knightpep && obj_player.state != global.states.knightpepslopes):
			obj_player.state = global.states.tumble
			obj_player.xscale = scale.x
			obj_player.movespeed = 14
			obj_player.velocity.y = 0
			obj_player.set_animation("tumble")
