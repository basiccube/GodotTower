extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 0.5

var countdown = 50

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	position.x += velocity.x
	position.y += velocity.y
	countdown -= 0.5
	if (countdown < 50):
		$Sprite.animation = "bomblit"
	if (countdown == 0):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")
	
func _physics_process(delta):
	velocity.y += grav
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)

func _on_PickupArea_body_entered(body):
	if body.is_in_group("obj_bombblock"):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")

func _on_PickupArea_area_entered(area):
	if area.is_in_group("obj_bombexplosion"):
		queue_free()
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bombexplosion.tscn")
