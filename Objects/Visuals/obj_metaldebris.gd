extends "res://Objects/Visuals/obj_parentparticle.gd"

var sprite_index = "metalblockdebris"

func _ready():
	velocity.x = utils.randi_range(-4, 4)
	velocity.y = utils.randi_range(-4, 0)
	grav = 0.4
	randomize()
	$Sprite.frame = utils.randi_range(0, 3)
	$Sprite.speed_scale = 0
	$Sprite.rotation_degrees = utils.randi_range(0, 270)

func _process(delta):
	$Sprite.animation = sprite_index
