extends Node2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	position.x = utils.get_player().position.x
	position.y = utils.get_player().position.y - 50
	
func _process(delta):
	$Sprite.speed_scale = 0.35
	if (!utils.get_player().indoor):
		queue_free()
	position.x = utils.get_player().position.x
	position.y = utils.get_player().position.y - 50
