extends "res://Objects/Visuals/obj_parentparticle.gd"

func _ready():
	velocity.x = utils.randi_range(-10, 10)
	velocity.y = utils.randi_range(-10, 10)
	grav = 0.4
	randomize()
	$Sprite.frame = utils.randi_range(0, 13)
	$Sprite.speed_scale = 0
	$Sprite.rotation_degrees = utils.randi_range(0, 270)
