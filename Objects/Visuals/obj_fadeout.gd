extends Node2D

var fadealpha = 0
var fadein = 0

var rect: Rect2

func _process(delta):
	modulate.a = fadealpha
	if (fadealpha > 1):
		fadein = 1
		if (utils.instance_exists("obj_player")):
			if (global.targetRoom != utils.get_player().targetRoom):
				utils.room_goto(utils.get_player().targetLevel, utils.get_player().targetRoom)
	if (fadein == 0):
		fadealpha += 0.1
	elif (fadein == 1):
		fadealpha -= 0.1
	if (utils.instance_exists("obj_player")):
		for i in get_tree().get_nodes_in_group("obj_player"):
			if (fadein == 1 && (i.state == global.states.victory || i.state == global.states.door) && i.indoor == true):
				i.state = global.states.comingoutdoor
			if (fadein == 1 && i.state == global.states.door && (i.sprite_index == "downpizzabox" || i.sprite_index == "uppizzabox")):
				i.state = global.states.comingoutdoor
	if (fadein == 1 && fadealpha < 0):
		queue_free()
	var obj_camera = utils.get_instance("obj_camera")
	rect.position.x = obj_camera.global_position.x - 540
	rect.position.y = obj_camera.global_position.y - 270
	rect.end.x = obj_camera.global_position.x + 540
	rect.end.y = obj_camera.global_position.y + 270
	update()
		
func _draw():
	draw_rect(rect, Color.black)
