extends StaticBody2D

func _ready():
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
	
func destroy():
	utils.instance_create(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	utils.instance_create(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	utils.instance_create(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	utils.instance_create(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	for obj in get_tree().get_nodes_in_group("obj_camera"):
		obj.shake_mag = 20
		obj.shake_mag_acc = 0.5
	utils.playsound("BreakMetal")
	global.saveroom.append(global.targetRoom + name)
	queue_free()
