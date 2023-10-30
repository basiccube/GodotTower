extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()

func destroy():
	global.saveroom.append(global.targetRoom + name)
	global.taseconds += 1
	var smallnumbid = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
	smallnumbid.number = "+1"
	utils.playsound("TimeBonus")
	queue_free()

func _on_obj_timebonus_body_entered(body):
	if body is obj_player:
		destroy()
