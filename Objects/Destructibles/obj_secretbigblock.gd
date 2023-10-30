extends StaticBody2D

func _ready():
	visible = false
	if (global.saveroom.has(global.targetRoom + name)):
		var position2 = position
		position2.x += 32
		var position3 = position
		position3.y += 32
		var position4 = position
		position4.x += 32
		position4.y += 32
		utils.delete_tile_at(position)
		utils.delete_tile_at(position2)
		utils.delete_tile_at(position3)
		utils.delete_tile_at(position4)
		queue_free()
	
func destroy():
	var debris1 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris1.sprite_index = "bigdebris"
	var debris2 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris2.sprite_index = "bigdebris"
	var debris3 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris3.sprite_index = "bigdebris"
	var debris4 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris4.sprite_index = "bigdebris"
	var debris5 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris5.sprite_index = "bigdebris"
	var debris6 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris6.sprite_index = "bigdebris"
	var debris7 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris7.sprite_index = "bigdebris"
	if (utils.soundplaying("BreakBlock1") || utils.soundplaying("BreakBlock2")):
		utils.stopsound("BreakBlock1")
		utils.stopsound("BreakBlock2")
	var rng = utils.randi_range(1,2)
	if (rng == 1):
		utils.playsound("BreakBlock1")
	elif (rng == 2):
		utils.playsound("BreakBlock2")
	var position2 = position
	position2.x += 32
	var position3 = position
	position3.y += 32
	var position4 = position
	position4.x += 32
	position4.y += 32
	utils.delete_tile_at(position)
	utils.delete_tile_at(position2)
	utils.delete_tile_at(position3)
	utils.delete_tile_at(position4)
	global.saveroom.append(global.targetRoom + name)
	queue_free()
