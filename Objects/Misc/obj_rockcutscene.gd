extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO

var frame = 0

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0
	$Timer.start()
	
func _process(delta):
	$Sprite.frame = frame
	position.x += velocity.x
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider != null:
			if collision.collider.is_in_group("obj_titlecutscene"):
				$Collision.set_deferred("disabled", true)
				collision.collider.rockcollision()

func _on_Timer_timeout():
	velocity.x = -20
