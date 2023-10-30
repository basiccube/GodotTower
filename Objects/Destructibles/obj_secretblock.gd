extends StaticBody2D

func _ready():
	visible = false
	if (global.saveroom.has(global.targetRoom + name)):
		utils.delete_tile_at(position)
		queue_free()
	
func destroy():
	utils.instance_create_level(global_position.x + 16, global_position.y + 16, "res://Objects/Visuals/obj_debris.tscn")
	utils.instance_create_level(global_position.x + 16, global_position.y + 16, "res://Objects/Visuals/obj_debris.tscn")
	utils.instance_create_level(global_position.x + 16, global_position.y + 16, "res://Objects/Visuals/obj_debris.tscn")
	utils.instance_create_level(global_position.x + 16, global_position.y + 16, "res://Objects/Visuals/obj_debris.tscn")
	if (utils.soundplaying("BreakBlock1") || utils.soundplaying("BreakBlock2")):
		utils.stopsound("BreakBlock1")
		utils.stopsound("BreakBlock2")
	var rng = utils.randi_range(1,2)
	if (rng == 1):
		utils.playsound("BreakBlock1")
	elif (rng == 2):
		utils.playsound("BreakBlock2")
	utils.delete_tile_at(position)
	global.saveroom.append(global.targetRoom + name)
	var pizzacoin = utils.randi_range(1, 100)
	if (pizzacoin >= 90):
		var pizzacoininst = utils.instance_create_level(global_position.x, global_position.y, "res://Objects/Collectibles/obj_pizzacoin.tscn")
		pizzacoininst.velocity.x = 2
	queue_free()
