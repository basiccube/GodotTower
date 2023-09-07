extends Node2D

var grav
var velocity = Vector2.ZERO

func _process(delta):
	if (velocity.y < 12):
		velocity.y += grav
	position.x += velocity.x
	position.y += floor(velocity.y)

func _on_CamVisibility_screen_exited():
	queue_free()
