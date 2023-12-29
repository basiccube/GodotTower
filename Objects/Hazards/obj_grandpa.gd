extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (global.baddieroom.has(global.targetRoom + name)):
		queue_free()

func destroy():
	if (!global.baddieroom.has(global.targetRoom + name)):
		utils.playsound("KillEnemy")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for obj in get_tree().get_nodes_in_group("obj_camera"):
			obj.shake_mag = 3
			obj.shake_mag_acc = 0.1
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
		var deadbaddieid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_sausageman_dead.tscn")
		deadbaddieid.sprite_index = $Sprite.frames.get_frame("dead", 0)
		global.baddieroom.append(global.targetRoom + name)
		for obj in get_tree().get_nodes_in_group("obj_tv"):
			obj.sprite.frame = utils.randi_range(0, 4)
		global.combo += 1
		global.combotime = 60
		queue_free()

func _process(delta):
	if ($Sprite.animation == "punch" && $Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		$Sprite.animation = "idle"
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player)):
		$Sprite.animation = "punch"
		obj_player.destroy(get_node("."))
	for i in get_overlapping_bodies():
		if i.is_in_group("obj_baddie"):
			if ((i.state == global.states.stun && i.thrown) || obj_player.state == global.states.superslam):
				i.destroy()
				destroy()
