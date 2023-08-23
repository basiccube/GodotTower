extends Node2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.75
	
func _process(delta):
	position = utils.get_player().position

func _on_Sprite_animation_finished():
	queue_free()
