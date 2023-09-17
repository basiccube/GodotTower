extends Node2D

var fadealpha = 0
var fadein = 0

var rect: Rect2

func _process(delta):
	modulate.a = fadealpha
	if (fadealpha > 1 && fadein == 0):
		var obj_pause = utils.get_instance("obj_pause")
		if (obj_pause.pause):
			obj_pause.pause = false
			get_tree().paused = false
		elif (!obj_pause.pause):
			obj_pause.pause = true
			get_tree().paused = true
		fadein = 1
	if (fadein == 0):
		fadealpha += 0.1
	elif (fadein == 1):
		fadealpha -= 0.1
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
