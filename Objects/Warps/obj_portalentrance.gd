extends Node2D

func _ready():
	if (utils.get_player().state != global.states.portal):
		queue_free()
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	$Sprite.material.set_shader_param("current_palette", global.peppalette)
	var obj_player = utils.get_player()
	if (obj_player.state != global.states.portal):
		queue_free()
	if (obj_player.state == global.states.portal):
		obj_player.position.x = position.x
		obj_player.position.y = position.y
		obj_player.set_animation("pizzaportalentrancestart")
		$Sprite.animation = "pizzaportalentrancestart"

func _on_Sprite_animation_finished():
	if ($Sprite.animation == "pizzaportalentrancestart"):
		queue_free()
