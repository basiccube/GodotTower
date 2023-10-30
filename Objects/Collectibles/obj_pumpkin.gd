extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()

func destroy():
	global.saveroom.append(global.targetRoom + name)
	global.taseconds += 10
	global.collect += 100
	var smallnumbid = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
	smallnumbid.number = "+10"
	utils.playsound("CollectToppin")
	var debris1 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris1.sprite_index = "pumpkinchunks"
	var debris2 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris2.sprite_index = "pumpkinchunks"
	var debris3 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris3.sprite_index = "pumpkinchunks"
	var debris4 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris4.sprite_index = "pumpkinchunks"
	var debris5 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris5.sprite_index = "pumpkinchunks"
	var debris6 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris6.sprite_index = "pumpkinchunks"
	var debris7 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris7.sprite_index = "pumpkinchunks"
	queue_free()

func _on_obj_pumpkin_body_entered(body):
	if body is obj_player:
		destroy()
