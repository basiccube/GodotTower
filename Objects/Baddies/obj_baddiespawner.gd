extends KinematicBody2D

export(PackedScene) var content
var baddieid = ""
var refresh = 20

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 0.5

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0

func _process(delta):
	if (!utils.instance_exists_level(baddieid)):
		refresh -= 1
	if (refresh <= 0):
		$Sprite.speed_scale = 0.35
		if ($Sprite.frame == 5):
			var spawnid = content.instance()
			utils.get_level().add_child(spawnid)
			spawnid.position = position
			spawnid.xscale = scale.x
			spawnid.state = global.states.stun
			spawnid.stunned = 50
			spawnid.velocity.y = -5
			print(str(content))
			spawnid.name = str(content)
			baddieid = spawnid.name
			spawnid.important = true
			refresh = 100
	position.x += velocity.x
	position.y += velocity.y
	
func _physics_process(delta):
	velocity.y += grav
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)

func _on_Sprite_animation_finished():
	$Sprite.speed_scale = 0
	$Sprite.frame = 0
