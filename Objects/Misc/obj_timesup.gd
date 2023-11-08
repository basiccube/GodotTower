extends Area2D

var grav = 0
var velocity = Vector2.ZERO
var grounded = false

func _ready():
	$Sprite.speed_scale = 0
	$Sprite.playing = true
	$FallTimer.start()
	global.panic = false

func _process(delta):
	if (!grounded):
		$Sprite.speed_scale = 0
	elif ($Sprite.frame != 8):
		$Sprite.speed_scale = 0.35
	else:
		$Sprite.speed_scale = 0
	position.x += velocity.x
	position.y += velocity.y
	if (velocity.y < 10):
		velocity.y += grav
	for i in get_overlapping_bodies():
		if i.is_in_group("obj_solid"):
			grounded = true
			velocity.y = 0
			grav = 0
		if i.is_in_group("obj_player") && !grounded:
			var obj_player = utils.get_player()
			obj_player.state = global.states.gameover
			obj_player.set_animation("deathend")
			obj_player.velocity.y = -8
			obj_player.velocity.x = -4

func _on_FallTimer_timeout():
	grav = 0.5
