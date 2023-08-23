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
	if (utils.get_player().xscale == 1):
		$Sprite.flip_h = false
	elif (utils.get_player().xscale == -1):
		$Sprite.flip_h = true
	if (utils.get_player().state != global.states.mach3):
		queue_free()
	position = utils.get_player().position
