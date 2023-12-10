extends Node2D

onready var sprite = $Sprite

func _ready():
	$Sprite.speed_scale = 0.35
	$Sprite.playing = true
	
func _process(delta):
	if ($Sprite.animation == "peppinoselected" && $Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		$Sprite.speed_scale = 0
