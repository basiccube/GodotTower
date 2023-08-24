extends Node2D

var rect: Rect2

func _process(delta):
	var obj_camera = utils.get_instance("obj_camera")
	rect.position.x = obj_camera.global_position.x - 540
	rect.position.y = obj_camera.global_position.y - 270
	rect.end.x = obj_camera.global_position.x + 540
	rect.end.y = obj_camera.global_position.y + 270
	update()

func _draw():
	draw_rect(rect, Color.black)
