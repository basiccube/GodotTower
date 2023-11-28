extends Node2D

func _ready():
	$DestroyTimer.start()
	if (utils.get_player().xscale == 1):
		$Sprite.flip_h = false
	elif (utils.get_player().xscale == -1):
		$Sprite.flip_h = true
	$Sprite.texture = utils.get_player().get_sprite_frame()
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
	var obj_player = utils.get_player()
	if (obj_player.state != global.states.mach3 && obj_player.state != global.states.climbwall && obj_player.state != global.states.mach2 && obj_player.state != global.states.handstandjump && obj_player.state != global.states.machslide && obj_player.state != global.states.slam && obj_player.state != global.states.machfreefall && obj_player.state != global.states.superslam && obj_player.state != global.states.machroll && obj_player.state != global.states.Sjump && obj_player.state != global.states.shoulderbash):
		queue_free()

func _on_DestroyTimer_timeout():
	queue_free()

func _on_AlphaOffTimer_timeout():
	modulate.a = 0
	$AlphaOnTimer.start()

func _on_AlphaOnTimer_timeout():
	modulate.a = 1
	$AlphaOnTimer.start()
