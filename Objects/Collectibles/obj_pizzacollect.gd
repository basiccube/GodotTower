extends Area2D

func _ready():
	$Sprite.playing = true
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
	var rng = utils.randi_range(1,3)
	if (rng == 1):
		$Sprite.animation = "pizzacollect1"
	elif (rng == 2):
		$Sprite.animation = "pizzacollect2"
	elif (rng == 3):
		$Sprite.animation = "pizzacollect3"
	$Sprite.speed_scale = 0.35

func destroy():
	global.saveroom.append(global.targetRoom + name)
	queue_free()

func _on_obj_collect_body_entered(body):
	if body is obj_player:
		utils.playsound("CollectPizza")
		global.combotime += 30
		global.collect += 100 * global.multiplier
		global.style += 5
		var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
		smallnumbid.number = str(100 * global.multiplier)
		destroy()
