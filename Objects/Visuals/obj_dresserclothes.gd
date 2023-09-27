extends Node2D

var velocity = Vector2.ZERO
var grav = 0.4
var palette = 0

func _ready():
	$Sprite.playing = true

func _process(delta):
	$Sprite.material.set_shader_param("current_palette", palette)
	if (velocity.y < 20):
		velocity.y += grav
	position.x += velocity.x
	position.y += floor(velocity.y)
	if (!$CamVisibility.is_on_screen()):
		queue_free()
