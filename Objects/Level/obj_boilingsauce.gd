extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	if (overlaps_body(utils.get_player())):
		var obj_player = utils.get_player()
		if (obj_player.state != global.states.gameover):
			obj_player.state = global.states.fireass
			obj_player.velocity.y = -25
			obj_player.set_animation("fireass")
			utils.playsound("Scream5")
	for i in get_overlapping_bodies():
		if i.is_in_group("obj_pizzacoin"):
			i.queue_free()
		if i.is_in_group("obj_baddie"):
			i.destroy()
