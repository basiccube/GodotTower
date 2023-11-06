extends StaticBody2D

func _ready():
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
	
func destroy():
	var debris1 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	debris1.sprite_index = "bombdebris"
	var debris2 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	debris2.sprite_index = "bombdebris"
	var debris3 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	debris3.sprite_index = "bombdebris"
	var debris4 = utils.instance_create_level(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	debris4.sprite_index = "bombdebris"
	global.saveroom.append(global.targetRoom + name)
	queue_free()
