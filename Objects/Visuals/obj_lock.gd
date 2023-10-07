extends Node2D

var velocity = Vector2.ZERO
var grav = 0.4

func _ready():
	velocity.y = utils.randi_range(-5, 0)
	velocity.x = utils.randi_range(-3, 3)

func _process(delta):
	if (velocity.y < 20):
		velocity.y += grav
	position.x += velocity.x
	position.y += floor(velocity.y)
	if (!$CamVisibility.is_on_screen()):
		queue_free()
