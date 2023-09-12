extends StaticBody2D

var bumpeffect = false

func _ready():
	scale.x = utils.get_player().xscale
	
func _process(delta):
	var obj_player = utils.get_player()
	scale.x = obj_player.xscale
	if (scale.x == 1):
		position.x = (obj_player.position.x + 100)
	elif (scale.x == -1):
		position.x = (obj_player.position.x)
	position.y = (obj_player.position.y + 50)
	if (obj_player.state != global.states.knightpepattack && obj_player.state != global.states.finishingblow):
		queue_free()
