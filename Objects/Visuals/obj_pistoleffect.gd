extends Node2D

onready var sprite = $Sprite
var xscale = 1

func _ready():
	sprite.playing = true
	sprite.speed_scale = 0.35

func _process(delta):
	scale.x = xscale

func _on_Sprite_animation_finished():
	queue_free()
