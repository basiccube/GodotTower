extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	position.x += scale.x * 4
	if ($SolidCheck.is_colliding() && $SolidCheck.get_collider() != null && ($SolidCheck.get_collider().is_in_group("obj_solid") || $SolidCheck.get_collider().is_in_group("obj_slope"))):
		destroy()
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player)):
		if (obj_player.state != global.states.knightpep && obj_player.hurted == 0):
			utils.playsound("BecomeKnight")
			obj_player.velocity.x = 0
			obj_player.movespeed = 0
			obj_player.state = global.states.knightpep
			obj_player.set_animation("knightpep_thunder")
			destroy()
	if (!$ScreenVisibility.is_on_screen()):
		destroy()
		
func destroy():
	queue_free()
