extends "res://Objects/Visuals/obj_parentparticle.gd"

func _ready():
	velocity.x = utils.randi_range(-5, 5)
	velocity.y = utils.randi_range(-2, -10)
	grav = 0.5
	randomize()
	$Sprite.frame = utils.randi_range(0, 5)
	$Sprite.speed_scale = 0
	$Sprite.rotation_degrees = utils.randi_range(0, 360)
