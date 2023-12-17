extends Node2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	scale.x = utils.get_player().xscale

func _process(delta):
	var obj_player = utils.get_player()
	position.x = obj_player.position.x
	position.y = obj_player.position.y
	scale.x = obj_player.xscale
	if (obj_player.state != global.states.normal || global.heatstylethreshold < 2):
		queue_free()
