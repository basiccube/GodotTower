extends "res://Objects/Visuals/obj_parentparticle.gd"

onready var sprite = $Sprite

func _ready():
	if (utils.get_player().character == "N"):
		$Sprite.animation = "noise"
	velocity.y = utils.randi_range(-10, -5)
	velocity.x = (utils.get_player().xscale * utils.randi_range(4, 8))
	grav = 0.4
	scale.x = utils.get_player().xscale
	$Sprite.speed_scale = 0
