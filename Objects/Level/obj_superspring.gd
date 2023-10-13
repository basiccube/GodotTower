extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0

func _on_Sprite_animation_finished():
	$Sprite.speed_scale = 0
	$Sprite.frame = 0

func _on_obj_superspring_body_entered(body):
	if body is obj_player:
		var obj_player = utils.get_player()
		$Sprite.speed_scale = 0.35
		if (obj_player.state != global.states.Sjump):
			obj_player.set_animation("superjump")
			obj_player.state = global.states.Sjump
			obj_player.velocity.y = -10
			$Sprite.frame = 0
			$Sprite.speed_scale = 0.35
			obj_player.get_node("SuperJumpRelease").play()
