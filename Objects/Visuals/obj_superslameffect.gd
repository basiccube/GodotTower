extends Node2D

onready var sprite = $Sprite

func _ready():
	sprite.playing = true
	sprite.speed_scale = 0.35

func _process(delta):
	position.x = utils.get_player().position.x
	position.y = utils.get_player().position.y
	if (utils.get_player().state != global.states.freefall):
		queue_free()
