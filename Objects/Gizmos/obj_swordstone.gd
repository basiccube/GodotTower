extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	var obj_player = utils.get_player()
	if (obj_player.state == global.states.knightpep || obj_player.state == global.states.knightpepattack || obj_player.state == global.states.knightpepslopes):
		$Sprite.animation = "taken"
	else:
		$Sprite.animation = "idle"
	if (overlaps_body(utils.get_player())):
		if (obj_player.is_on_floor() && $Sprite.animation == "idle" && obj_player.state == global.states.handstandjump):
			utils.playsound("KnightSword")
			obj_player.momemtum = 0
			obj_player.movespeed = 0
			obj_player.set_animation("knightpep_start")
			obj_player.state = global.states.knightpep
			obj_player.velocity.x = 0
			
