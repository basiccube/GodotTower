extends Node2D

var playerid = ""

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.5
	scale.x = utils.get_player().xscale
	
func _process(delta):
	var obj_player = utils.get_player()
	scale.x = obj_player.xscale
	if (!obj_player.supercharged):
		queue_free()
	position.x = obj_player.position.x
	position.y = obj_player.position.y
	visible = obj_player.visible
	if (global.combotime <= 0):
		obj_player.supercharged = false
		queue_free()
