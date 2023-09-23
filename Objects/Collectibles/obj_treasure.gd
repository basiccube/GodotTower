extends Area2D

export(String) var spr_got = "treasure1pick"
export(String) var spr_idle = "treasure1"

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
		
func _process(delta):
	if ($Sprite.animation == spr_got && utils.get_player().state != global.states.gottreasure):
		destroy()
	if ($Sprite.animation != spr_got):
		$Sprite.animation = spr_idle

func destroy():
	global.saveroom.append(global.targetRoom + name)
	queue_free()

func _on_obj_treasure_body_entered(body):
	if (body is obj_player && $Sprite.animation == spr_idle):
		var obj_player = utils.get_player()
		global.treasure = true
		obj_player.velocity.x = 0
		obj_player.velocity.y = 0
		if ($Sprite.animation == spr_idle):
			$Timer.start()
			obj_player.state = global.states.gottreasure
			utils.playsound("SecretFound")
		$Sprite.animation = spr_got
		position.x = obj_player.position.x
		position.y = obj_player.position.y - 35
		for obj in get_tree().get_nodes_in_group("obj_tv"):
			obj.message = "YOU GOT A TOWER SECRET TREASURE!!!"
			obj.showtext = true
			obj.resettimer.wait_time = 3.33
			obj.resettimer.start()

func _on_Timer_timeout():
	var obj_player = utils.get_player()
	obj_player.state = global.states.normal
	var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
	smallnumbid.number = "1000"
	global.collect += 1000
	destroy()
