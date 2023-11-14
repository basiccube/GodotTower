extends Node2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _on_Sprite_animation_finished():
	queue_free()
