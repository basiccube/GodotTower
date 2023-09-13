extends "res://Objects/Visuals/obj_parentparticle.gd"

func _ready():
	var rng = utils.randi_range(1, 5)
	if (rng == 1):
		$Sprite.animation = "shroom"
	elif (rng == 2):
		$Sprite.animation = "tomato"
	elif (rng == 3):
		$Sprite.animation = "cheese"
	elif (rng == 4):
		$Sprite.animation = "sausage"
	elif (rng == 5):
		$Sprite.animation = "pineapple"
	velocity.x = utils.randi_range(-10, 10)
	velocity.y = utils.randi_range(-5, 0)
	grav = 0.5
