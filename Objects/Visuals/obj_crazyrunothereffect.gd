extends Node2D

onready var sprite = $Sprite

func _ready():
	sprite.playing = true
	sprite.speed_scale = 0.5
	if (utils.get_player().xscale == 1):
		$Sprite.flip_h = false
	elif (utils.get_player().xscale == -1):
		$Sprite.flip_h = true
		
func _process(delta):
	if (utils.get_player().xscale == 1):
		$Sprite.flip_h = false
	elif (utils.get_player().xscale == -1):
		$Sprite.flip_h = true
	if (utils.get_player().movespeed <= 12 && utils.get_player().state != global.states.faceplant && utils.get_player().state != global.states.shoulderbash && utils.get_player().state != global.states.punch):
		queue_free()

func _on_Sprite_animation_finished():
	queue_free()
