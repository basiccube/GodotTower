extends StaticBody2D

func _ready():
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
	if (!global.panic):
		queue_free()
	
func destroy():
	var debris1 = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris1.sprite_index = "bigdebrisescape"
	var debris2 = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris2.sprite_index = "bigdebrisescape"
	var debris3 = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris3.sprite_index = "bigdebrisescape"
	var debris4 = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris4.sprite_index = "bigdebrisescape"
	var debris5 = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris5.sprite_index = "bigdebrisescape"
	var debris6 = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris6.sprite_index = "bigdebrisescape"
	var debris7 = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris7.sprite_index = "bigdebrisescape"
	if (utils.soundplaying("BreakBlock1") || utils.soundplaying("BreakBlock2")):
		utils.stopsound("BreakBlock1")
		utils.stopsound("BreakBlock2")
	var rng = utils.randi_range(1,2)
	if (rng == 1):
		utils.playsound("BreakBlock1")
	elif (rng == 2):
		utils.playsound("BreakBlock2")
	global.saveroom.append(global.targetRoom + name)
	queue_free()
