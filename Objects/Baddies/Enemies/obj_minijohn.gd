extends obj_baddie

var hitboxcreate = false

func _ready():
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	movespeed = 7
	state = global.states.walk
	stunned = 0
	straightthrow = false
	spr_land = "bounce"
	spr_idle = "stun"
	spr_fall = "fall"
	spr_stunfall = "stun"
	spr_walk = "charge"
	spr_turn = "turn"
	spr_recovery = "recovery"
	spr_grabbed = "stun"
	spr_scared = "stun"
	spr_dead = "minijohn_dead"
	hp = 1
	momentum = 5
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
		global.states.grabbed:
			scr_enemy_grabbed()
		global.states.pizzagoblinthrow:
			scr_pizzagoblin_throw()
		global.states.chase:
			scr_enemy_chase()
	var obj_player = utils.get_player()
	if (state == global.states.walk || state == global.states.idle):
		movespeed = 7
		xscale = (-(sign((position.x - obj_player.position.x))))
		momentum = ((-xscale) * (movespeed + 4))
		state = global.states.chase
	if (!hitboxcreate && state == global.states.chase):
		hitboxcreate = true
		var forkhitboxid = utils.instance_create(-50000, -50000, "res://Objects/Hitboxes/obj_minijohn_hitbox.tscn")
		forkhitboxid.baddieid = name
	if (state != global.states.grabbed):
		z_index = 0
	if (state != global.states.stun):
		thrown = false
