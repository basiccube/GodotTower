extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0

func _on_Sprite_animation_finished():
	$Sprite.speed_scale = 0
	$Sprite.frame = 0

func _on_obj_sidesuperspring_body_entered(body):
	if body is obj_player:
		var obj_player = utils.get_player()
		$Sprite.speed_scale = 0.35
		if (obj_player.xscale != scale.x):
			obj_player.xscale = scale.x
		if (obj_player.movespeed < 10):
			obj_player.movespeed = 10
