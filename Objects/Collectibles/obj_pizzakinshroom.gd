extends Area2D

var followQueue = []
var panic = false
var lag_steps = 0

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()

func destroy():
	global.saveroom.append(global.targetRoom + name)
	queue_free()

func _process(delta):
	if (global.targetRoom == "rank_room" || global.targetRoom == "timesuproom"):
		visible = false
	else:
		visible = true
	var obj_player = utils.get_player()
	if ($Sprite.animation == "intro" && $Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		$Sprite.animation = "idle"
	if (global.shroomfollow && $Sprite.animation != "intro"):
		modulate.a = obj_player.modulate.a
		if (!global.panic):
			if (obj_player.velocity.x != 0):
				$Sprite.animation = "run"
			else:
				$Sprite.animation = "idle"
		followQueue.push_front(obj_player.position.x)
		followQueue.push_front(obj_player.position.y + 12)
		lag_steps = 10
		if (followQueue.size() > lag_steps * 2):
			position.x = (followQueue.pop_back() - (scale.x * 4))
			position.y = (followQueue.pop_back() + 2)
		scale.x = obj_player.xscale
	if (global.panic && global.shroomfollow):
		$Sprite.animation = "panic"
	if (overlaps_body(obj_player)):
		if (obj_player.state != global.states.hurt && !global.shroomfollow):
			$Sprite.animation = "intro"
			global.combotime = 60
			global.saveroom.append(global.targetRoom + name)
			#global.shroomfollow = true
