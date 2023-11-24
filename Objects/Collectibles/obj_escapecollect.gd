extends Area2D

func _ready():
	$Sprite.playing = true
	if (global.escaperoom.has(global.targetRoom + name)):
		queue_free()
	var rng = utils.randi_range(1,5)
	if (rng == 1):
		$Sprite.animation = "egg"
	elif (rng == 2):
		$Sprite.animation = "fish"
	elif (rng == 3):
		$Sprite.animation = "banana"
	elif (rng == 4):
		$Sprite.animation = "bacon"
	elif (rng == 5):
		$Sprite.animation = "shrimp"
	$Sprite.speed_scale = 0.35
	
func _process(delta):
	if (global.panic):
		visible = true
	else:
		visible = false

func destroy():
	global.escaperoom.append(global.targetRoom + name)
	queue_free()

func _on_obj_escapecollect_body_entered(body):
	if (body is obj_player && global.panic):
		if (utils.soundplaying("Collect")):
			utils.stopsound("Collect")
		utils.playsound("Collect")
		global.combotime += 5
		global.collect += 10
		var smallnumbid = utils.instance_create(global_position.x + 16, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
		smallnumbid.number = "10"
		destroy()
