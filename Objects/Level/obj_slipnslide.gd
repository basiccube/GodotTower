extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 0.4
var drop = false
var banana = 0

func destroy():
	utils.instance_create((position.x + utils.randi_range(-10, 10)), (position.y + utils.randi_range(-10, 10)), "res://Objects/Visuals/obj_cloudeffect.tscn")
	utils.instance_create((position.x + utils.randi_range(-10, 10)), (position.y + utils.randi_range(-10, 10)), "res://Objects/Visuals/obj_cloudeffect.tscn")
	utils.instance_create((position.x + utils.randi_range(-10, 10)), (position.y + utils.randi_range(-10, 10)), "res://Objects/Visuals/obj_cloudeffect.tscn")
	utils.instance_create((position.x + utils.randi_range(-10, 10)), (position.y + utils.randi_range(-10, 10)), "res://Objects/Visuals/obj_cloudeffect.tscn")
	queue_free()

func _process(delta):
	position.x += velocity.x
	position.y += velocity.y
	if (!drop):
		velocity = move_and_slide(velocity, FLOOR_NORMAL)
		velocity.y += grav
	else:
		if (velocity.y < 12):
			velocity.y += grav
		position.x += velocity.x
		position.y += floor(velocity.y)
		if (!$ScreenVisibility.is_on_screen()):
			destroy()
	if (is_on_floor() && !drop):
		velocity.x = 0
	if (banana == 4):
		destroy()

func _on_CollisionArea_body_entered(body):
	if body is obj_player:
		if (!drop):
			var obj_player = utils.get_player()
			drop = true
			obj_player.state = global.states.slipnslide
			obj_player.movespeed = 12
