extends obj_baddie

var hitboxcreate = false

func _ready():
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	movespeed = 1
	state = global.states.walk
	stunned = 0
	straightthrow = false
	spr_idle = "idle"
	spr_stunfall = "stun"
	spr_walk = "walk"
	spr_turn = "turn"
	spr_grabbed = "grabbed"
	spr_scared = "scared"
	spr_dead = "forknight_dead"
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
	scr_scareenemy()
	if (!hitboxcreate && state == global.states.walk):
		hitboxcreate = true
		var forkhitboxid = utils.instance_create(-50000, -50000, "res://Objects/Hitboxes/obj_forkhitbox.tscn")
		forkhitboxid.baddieid = name
	if (state != global.states.grabbed):
		z_index = 0
	if (state != global.states.stun):
		thrown = false
