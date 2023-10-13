extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 0.5
var xscale = 1
var speed = 2

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.5
	var randxscale = utils.randi_range(1, 2)
	if (randxscale == 1):
		xscale = 1
	elif (randxscale == 2):
		xscale = -1
	velocity.x = (xscale * speed)
	velocity.y = utils.randi_range(-2, -4)

func _process(delta):
	velocity.x = (xscale * speed)
	if xscale == 1:
		$WallCheck.scale.x = 1
	elif xscale == -1:
		$WallCheck.scale.x = -1
	position.x += velocity.x
	position.y += velocity.y
	if ($WallCheck.is_colliding() && $WallCheck.get_collider() != null && ($WallCheck.get_collider().is_in_group("obj_solid") || $WallCheck.get_collider().is_in_group("obj_destructibles") || $WallCheck.get_collider().is_in_group("obj_metalblock"))):
		$WallCheck.scale.x *= -1
		xscale *= -1
	
func _physics_process(delta):
	velocity.y += grav
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)

func _on_PizzacoinArea_body_entered(body):
	if body is obj_player:
		global.pizzacoin += 1
		for i in get_tree().get_nodes_in_group("obj_pizzacoinindicator"):
			i.show = 50
		if (utils.soundplaying("Pizzacoin")):
			utils.stopsound("Pizzacoin")
		utils.playsound("Pizzacoin")
		queue_free()
