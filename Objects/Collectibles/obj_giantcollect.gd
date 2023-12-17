extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()

func destroy():
	global.saveroom.append(global.targetRoom + name)
	queue_free()

func _on_obj_giantcollect_body_entered(body):
	if body is obj_player:
		utils.playsound("CollectGiantPizza")
		global.combotime = 60
		global.collect += 1000
		global.style += 10
		global.heattime = 60
		var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
		smallnumbid.number = "1000"
		destroy()
