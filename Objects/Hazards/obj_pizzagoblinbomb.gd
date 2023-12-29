extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 1

var countdown = 50

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	position.x += velocity.x
	position.y += velocity.y
	if (is_on_floor() && velocity.y >= 0):
		velocity.x = 0
	countdown -= 0.5
	if (countdown < 50):
		$Sprite.animation = "bomblit"
	if (countdown <= 0):
		queue_free()
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")
	if ($PickupArea.overlaps_body(utils.get_player())):
		var obj_player = utils.get_player()
		if (!obj_player.cutscene && is_on_floor() && obj_player.state != global.states.bombpep && obj_player.state == global.states.handstandjump):
			obj_player.bombpeptimer = 100
			obj_player.state = global.states.bombpep
			obj_player.set_animation("bombpep_intro")
			queue_free()
		if (obj_player.hurted == 0 && !is_on_floor()):
			queue_free()
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")
	
func _physics_process(delta):
	if (velocity.y < 12):
		velocity.y += grav
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)

func _on_PickupArea_body_entered(body):
	if body.is_in_group("obj_bombblock"):
		body.destroy()
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")

func _on_PickupArea_area_entered(area):
	if area.is_in_group("obj_bombexplosion"):
		queue_free()
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")
