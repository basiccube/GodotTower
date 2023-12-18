extends StaticBody2D

func _ready():
	if (global.escaperoom.has(global.targetRoom + name)):
		queue_free()
	if (!global.panic):
		queue_free()
	
func destroy():
	var debris1 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris1.sprite_index = "bigpizzadebrisescape"
	var debris2 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris2.sprite_index = "bigpizzadebrisescape"
	var debris3 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris3.sprite_index = "bigpizzadebrisescape"
	var debris4 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris4.sprite_index = "bigpizzadebrisescape"
	var debris5 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris5.sprite_index = "bigpizzadebrisescape"
	var debris6 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris6.sprite_index = "bigpizzadebrisescape"
	var debris7 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_debris.tscn")
	debris7.sprite_index = "bigpizzadebrisescape"
	var pizzaslice1 = utils.instance_create_unique(global_position.x + 32, global_position.y + 32, "res://Objects/Collectibles/obj_pizzaslice.tscn")
	pizzaslice1.xscale = 1
	var pizzaslice2 = utils.instance_create_unique(global_position.x + 32, global_position.y + 32, "res://Objects/Collectibles/obj_pizzaslice.tscn")
	pizzaslice2.xscale = -1
	if (utils.soundplaying("BreakBlock1") || utils.soundplaying("BreakBlock2")):
		utils.stopsound("BreakBlock1")
		utils.stopsound("BreakBlock2")
	var rng = utils.randi_range(1,2)
	if (rng == 1):
		utils.playsound("BreakBlock1")
	elif (rng == 2):
		utils.playsound("BreakBlock2")
	global.escaperoom.append(global.targetRoom + name)
	queue_free()
