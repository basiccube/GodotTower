extends Node2D

export(PackedScene) var content
export(int) var xscale = 1

func _ready():
	visible = false
	if (global.escaperoom.has(global.targetRoom + name)):
		queue_free()
	elif (global.panic):
		$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	global.escaperoom.append(global.targetRoom + name)
	#var spawnid = utils.instance_create_level_scene(position.x, position.y, content)
	var spawnid = content.instance()
	spawnid.name = name + str(content) + str(utils.randi_range(0, 10000))
	utils.get_level().add_child(spawnid)
	spawnid.position = position
	if ("xscale" in spawnid):
		spawnid.xscale = xscale
	else:
		spawnid.scale.x = xscale
	utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_pizzaportalfade.tscn")
	queue_free()
