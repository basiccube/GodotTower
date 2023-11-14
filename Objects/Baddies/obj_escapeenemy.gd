extends Node2D

export(PackedScene) var content
export(int) var xscale = 1

func _ready():
	visible = false
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
	elif (global.panic):
		$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	global.saveroom.append(global.targetRoom + name)
	var spawnid = utils.instance_create_level_scene(position.x, position.y, content)
	if ("xscale" in spawnid):
		spawnid.xscale = xscale
	else:
		spawnid.scale.x = xscale
	utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaportalfade.tscn")
	queue_free()
