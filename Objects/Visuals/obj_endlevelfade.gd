extends Node2D

var fadealpha = 0
var fadein = false

onready var timer = $Timer
var rect: Rect2
	
func _process(delta):
	modulate.a = fadealpha
	var obj_player = utils.get_player()
	if (global.targetRoom == "rank_room"):
		obj_player.xscale = 1
		obj_player.position.x = 430
		obj_player.position.y = 220
	var obj_camera = utils.get_instance("obj_camera")
	obj_camera.visible = false
	if (fadealpha > 1):
		fadein = true
		if (global.targetRoom != "rank_room"):
			utils.room_goto("", "rank_room")
	if (!fadein):
		fadealpha += 0.1
	elif (fadein):
		fadealpha -= 0.1
	rect.position.x = obj_camera.global_position.x - 540
	rect.position.y = obj_camera.global_position.y - 270
	rect.end.x = obj_camera.global_position.x + 540
	rect.end.y = obj_camera.global_position.y + 270
	update()

func _draw():
	draw_rect(rect, Color.white)

func _on_Timer_timeout():
	utils.instance_create(480, 270, "res://Objects/Misc/obj_rank.tscn")
	utils.get_player().visible = false
