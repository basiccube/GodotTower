tool
extends KinematicBody2D

export(bool) var flipped = false

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 0.5

var buffer = 0

func _ready():
	if (!Engine.editor_hint):
		if (global.panic):
			scale.x *= -1
	$Sprite.playing = true
	$Sprite.speed_scale = 0.5

func _process(delta):
	if (Engine.editor_hint):
		$Sprite.flip_h = flipped
	else:
		$Sprite.flip_h = flipped
		var obj_player = utils.get_player()
		if (buffer > 0):
			buffer -= 1
		if ($CollisionArea.overlaps_body(obj_player) && buffer <= 0):
			if (flipped):
				obj_player.xscale = -1
			elif (!flipped):
				obj_player.xscale = 1
			obj_player.mach2 = 100
			obj_player.machhitAnim = 0
			obj_player.flash = true
			obj_player.state = global.states.mach3
			obj_player.set_animation("mach4")
			utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
			obj_player.movespeed = 14
			buffer = 50
			utils.playsound("Bump")
			utils.playsound("Punch")
			utils.playsound("KillEnemy")
		position.x += velocity.x
		position.y += velocity.y
	
func _physics_process(delta):
	if (!Engine.editor_hint):
		velocity.y += grav
		velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
