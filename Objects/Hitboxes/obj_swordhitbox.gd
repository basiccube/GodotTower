extends Area2D

var bumpeffect = false

func _ready():
	scale.x = utils.get_player().xscale
	
func _process(delta):
	var obj_player = utils.get_player()
	scale.x = obj_player.xscale
	if (scale.x == 1):
		position.x = (obj_player.position.x + 100)
	elif (scale.x == -1):
		position.x = (obj_player.position.x)
	position.y = (obj_player.position.y + 50)
	if (obj_player.state != global.states.knightpepattack && obj_player.state != global.states.finishingblow):
		queue_free()
	for obj in get_overlapping_bodies():
		if obj.is_in_group("obj_hungrypillar"):
			obj.destroy()
		if obj.is_in_group("obj_baddie"):
			if obj.state == global.states.grabbed:
				obj.hp -= 1
				utils.instance_create(obj.global_position.x, obj.global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
				utils.instance_create(obj.global_position.x, obj.global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
				utils.instance_create(obj.global_position.x, obj.global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
				utils.instance_create(obj.global_position.x, obj.global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
				utils.instance_create(obj.global_position.x, obj.global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
				utils.instance_create(obj.global_position.x, obj.global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
				for i in get_tree().get_nodes_in_group("obj_camera"):
					i.shake_mag = 3
					i.shake_mag_acc = (3 / 30)
				obj.bangeffecttimer.wait_time = 0.05
				obj.bangeffecttimer.start()
				global.hit += 1
				if (obj.is_in_group("obj_pizzaball")):
					global.golfhit += 1
				obj.macheffecttimer.wait_time = 0.083
				obj.macheffecttimer.start()
				obj.thrown = true
				if (obj_player.sprite_index == "uppercutfinishingblow"):
					obj.velocity.x = 0
					obj.velocity.y = -35
				else:
					obj.velocity.x = ((obj_player.xscale) * 25)
					obj.velocity.y = -6
				obj.state = global.states.stun
