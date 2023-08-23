extends Node2D

onready var sprite = $Sprite

func _ready():
	sprite.playing = true
	sprite.speed_scale = 0.45

func _on_Sprite_animation_finished():
	queue_free()
