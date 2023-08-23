extends Node2D

onready var sprite = $Sprite

func _ready():
	sprite.playing = true
	sprite.speed_scale = 0.4
	if (utils.instance_exists("obj_player")):
		if (utils.get_player().xscale == 1):
			$Sprite.flip_h = false
		elif (utils.get_player().xscale == -1):
			$Sprite.flip_h = true

func _on_Sprite_animation_finished():
	queue_free()
