extends obj_baddie

var hitboxcreate = false

var ystart

func _ready():
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	movespeed = 0
	state = global.states.walk
	stunned = 0
	straightthrow = false
	spr_idle = "idle"
	spr_stunfall = "bounce"
	spr_walk = "idle"
	spr_grabbed = "bounce"
	spr_scared = "scared"
	spr_dead = "dead"
	xscale = -1
	hp = 1
	ystart = position.y
	important = false
	
func _process(delta):
	match state:
		global.states.idle:
			scr_enemy_idle()
		global.states.charge:
			scr_enemy_charge()
		global.states.turn:
			scr_enemy_turn()
		global.states.walk:
			scr_enemy_walk()
		global.states.land:
			scr_enemy_land()
		global.states.hit:
			scr_enemy_hit()
		global.states.stun:
			scr_enemy_stun()
		global.states.pizzagoblinthrow:
			scr_pizzagoblin_throw()
		global.states.grabbed:
			scr_enemy_grabbed()
	var obj_player = utils.get_player()
	scr_scareenemy()
	if (state == global.states.walk && floor(position.y) > ystart && !$CeilingCheck.is_colliding()):
		position.y -= 1
	if (state == global.states.walk && floor(position.y) < ystart && !$CeilingCheck.is_colliding()):
		position.y += 1
	if (state == global.states.stun):
		grav = 0.5
	else:
		grav = 0
	if (position.x != obj_player.position.x && state != global.states.charge && floor(global_position.y) == ystart && obj_player.position.x > (position.x - 200) && obj_player.position.x < (position.x + 200) && position.y <= (obj_player.position.y + 50) && position.y >= (obj_player.position.y - 50)):
		if (state == global.states.walk):
			xscale = (-(sign(position.x - obj_player.position.x)))
			$Sprite.animation = "chargestart"
			state = global.states.charge
	if (state == global.states.stun || state == global.states.walk):
		movespeed = 0
	if ($Sprite.animation == "chargestart" && $Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		if (!hitboxcreate && state == global.states.charge):
			var forkhitboxid = utils.instance_create(-50000, -50000, "res://Objects/Hitboxes/obj_forkhitbox.tscn")
			forkhitboxid.baddieid = name
			hitboxcreate = true
		$Sprite.animation = "charge"
		movespeed = 10
	if (state != global.states.grabbed):
		z_index = 0
	if (state != global.states.stun):
		thrown = false
