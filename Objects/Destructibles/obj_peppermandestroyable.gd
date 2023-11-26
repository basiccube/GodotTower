extends StaticBody2D

func _ready():
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
	
func destroy():
	if ($ScreenVisibility.is_on_screen()):
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
	global.saveroom.append(global.targetRoom + name)
	queue_free()
