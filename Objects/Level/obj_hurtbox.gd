extends KinematicBody2D

func _process(delta):
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider != null:
			if collision.collider.is_in_group("obj_player"):
				var obj_player = utils.get_player()
				if (obj_player.state == global.states.knightpep || obj_player.state == global.states.knightpepattack || obj_player.state == global.states.knightpepslopes):
					pass
				elif (obj_player.state == global.states.bombpep && obj_player.hurted == 0):
					pass
				elif (obj_player.state == global.states.tumble):
					pass
				elif (obj_player.state == global.states.cheesepep || obj_player.state == global.states.cheesepepstick):
					pass
				elif (obj_player.state != global.states.hurt && obj_player.hurted == 0 && obj_player.state != global.states.bump):
					obj_player.pephurtsfx.play()
					obj_player.hurttimer.wait_time = 1
					obj_player.hurttimer.start()
					obj_player.hurttimer2.wait_time = 2
					obj_player.hurttimer2.start()
					obj_player.hurted = 1
					if (obj_player.xscale == scale.x):
						obj_player.set_animation("hurtjump")
					else:
						obj_player.set_animation("hurt")
					obj_player.movespeed = 8
					obj_player.velocity.y = -5
					utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_spikehurteffect.tscn")
					obj_player.state = global.states.hurt
					if (obj_player.shotgunAnim == 0 && obj_player.character == "P"):
						global.hurtcounter += 1
						if (global.collect > 100):
							global.collect -= 100
						else:
							global.collect = 0
						if (global.collect != 0):
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_pizzaloss.tscn")
					elif (obj_player.character == "P"):
						obj_player.set_animation("shotgunback")
						obj_player.shotgunAnim = 0
