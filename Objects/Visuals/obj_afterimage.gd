extends Node2D

var sprite = load("res://Objects/Player/sprites/mach_0.png")

func _ready():
	$DestroyTimer.start()
	randomize()
	var randcolor = utils.randi_range(0, 1)
	if randcolor == 0:
		modulate.r = 1
		modulate.g = 0
		modulate.b = 0
	elif randcolor == 1:
		modulate.r = 0
		modulate.g = 1
		modulate.b = 0
	$AlphaOffTimer.start()

func _process(delta):
	$Sprite.texture = sprite

func _on_DestroyTimer_timeout():
	queue_free()

func _on_AlphaOffTimer_timeout():
	modulate.a = 0
	$AlphaOnTimer.start()

func _on_AlphaOnTimer_timeout():
	modulate.a = 1
	$AlphaOnTimer.start()
