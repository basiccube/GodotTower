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
	utils.instance_create(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	utils.instance_create(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	utils.instance_create(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	utils.instance_create(global_position.x + 32, global_position.y + 32, "res://Objects/Visuals/obj_metaldebris.tscn")
	for obj in get_tree().get_nodes_in_group("obj_camera"):
		obj.shake_mag = 20
		obj.shake_mag_acc = 0.5
	utils.playsound("BreakMetal")
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
