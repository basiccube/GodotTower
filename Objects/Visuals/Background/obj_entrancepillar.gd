extends Node2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	
func _process(delta):
	if (global.panic):
		$Sprite.animation = "panic"
