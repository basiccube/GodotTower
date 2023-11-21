extends obj_baddie

var hitboxcreate = false

var charging = false

func _ready():
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	movespeed = 0
	state = global.states.walk
	stunned = 0
	straightthrow = false
	spr_idle = "idle"
	spr_stunfall = "stun"
	spr_walk = "idle"
	spr_grabbed = "stun"
	spr_scared = "scared"
	spr_dead = "dead"
	xscale = -1
	hp = 1
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
	if (obj_player.position.x > (position.x - 450) && obj_player.position.x < (position.x + 450) && position.y <= (obj_player.position.y + 110) && position.y >= (obj_player.position.y - 110)):
		if (state != global.states.idle && obj_player.state == global.states.mach3):
			state = global.states.idle
			$Sprite.animation = spr_scared
			if (position.x != obj_player.position.x):
				xscale = (-(sign(position.x - obj_player.position.x)))
	if (position.x != obj_player.position.x + 50 && is_on_floor() && obj_player.position.x > (position.x - 450) && obj_player.position.x < (position.x + 450) && position.y <= (obj_player.position.y + 110) && position.y >= (obj_player.position.y - 110)):
		if (state == global.states.walk && !charging):
			var forkhitboxid = utils.instance_create(-50000, -50000, "res://Objects/Hitboxes/obj_forkhitbox.tscn")
			forkhitboxid.baddieid = name
			charging = true
			state = global.states.charge
			movespeed = 5
			velocity.y = -7
			$Sprite.animation = "chargestart"
	if (state == global.states.stun || state == global.states.walk):
		charging = false
		movespeed = 0
	if ($Sprite.animation == "chargestart" && $Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		$Sprite.animation = "charge"
	if (!hitboxcreate && state == global.states.walk):
		var forkhitboxid = utils.instance_create(-50000, -50000, "res://Objects/Hitboxes/obj_forkhitbox.tscn")
		forkhitboxid.baddieid = name
		hitboxcreate = true
	if (state != global.states.grabbed):
		z_index = 0
	if (state != global.states.stun):
		thrown = false
