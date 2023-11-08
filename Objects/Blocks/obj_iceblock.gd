extends StaticBody2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	
func _process(delta):
	var obj_player = utils.get_player()
	if $PlayerCheckArea.overlaps_body(obj_player):
		if (obj_player.state == global.states.knightpep):
			obj_player.state = global.states.knightpepslopes
		elif (obj_player.state != global.states.knightpep):
			obj_player.state = global.states.slipnslide
		if (obj_player.movespeed < 12):
			obj_player.movespeed = 12
