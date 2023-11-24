extends Node2D

onready var sprite = $Sprite

func _ready():
	sprite.playing = true
	sprite.speed_scale = 0.5
	scale.x = utils.get_player().xscale

func _process(delta):
	var obj_player = utils.get_player()
	position.x = obj_player.position.x
	position.y = obj_player.position.y
	scale.x = obj_player.xscale
	if (obj_player.movespeed <= 7):
		queue_free()
	if (obj_player.state != global.states.mach2):
		queue_free()
	
