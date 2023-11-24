extends Node2D

var up = 560

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	
func _process(delta):
	up -= 5
	if (up <= -100):
		queue_free()
	var obj_camera = utils.get_instance("obj_camera")
	position.x = obj_camera.position.x
	position.y = ((obj_camera.position.y - 270) + up)
