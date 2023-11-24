extends Node2D

var hspeed = 0
var vspeed = 0

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.5
	scale.x = utils.get_player().xscale
#	randomize()
#	var randcolor = utils.randi_range(0, 1)
#	if randcolor == 0:
#		modulate.r = 1
#		modulate.g = 0
#		modulate.b = 0
#	elif randcolor == 1:
#		modulate.r = 0
#		modulate.g = 1
#		modulate.b = 0
	$AlphaOffTimer.start()
	
func _process(delta):
	position.x += hspeed
	position.y += vspeed

func _on_AlphaOffTimer_timeout():
	modulate.a = 0
	$AlphaOnTimer.start()

func _on_AlphaOnTimer_timeout():
	modulate.a = 1
	$AlphaOnTimer.start()

func _on_VisibilityTimer_timeout():
	if (!$ScreenVisibility.is_on_screen()):
		queue_free()
