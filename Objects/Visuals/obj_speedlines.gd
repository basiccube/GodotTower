extends Node2D

onready var sprite = $Sprite

func _ready():
	sprite.playing = true
	sprite.speed_scale = 0.5
	if (utils.get_player().xscale == 1):
		$Sprite.flip_h = false
	elif (utils.get_player().xscale == -1):
		$Sprite.flip_h = true

func _process(delta):
	var obj_player = utils.get_player()
	global_position = obj_player.global_position
	if (obj_player.xscale == 1):
		$Sprite.flip_h = false
	elif (obj_player.xscale == -1):
		$Sprite.flip_h = true
	if (obj_player.movespeed <= 7):
		queue_free()
	if (obj_player.state != global.states.mach2):
		queue_free()
	
