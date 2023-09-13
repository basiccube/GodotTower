extends StaticBody2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	z_index = -1
